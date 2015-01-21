
#import "HTTPServer.h"

FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result) = NULL;
FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result) = NULL;

NSString *_enableHook = nil;

//
FUNHOOK(CFTypeRef, MGCopyAnswer, NSString *property)
{
	CFTypeRef ret = _MGCopyAnswer(property);
	if (_enableHook)
	{
		_Log(@"MGCopyAnswer %@=> %@(%@)", property, ret, [(__bridge id)ret class]);
		if ([property isEqualToString:@"UniqueDeviceID"])
		{
			NSLog(@"MGCopyAnswer UniqueDeviceID FAKE as %@", _enableHook);
			return CFStringCreateWithCString(NULL, _enableHook.UTF8String, kCFStringEncodingUTF8);
		}
	}
	return ret;
} ENDHOOK

//
//FUNPTR(kern_return_t, IORegistryEntryGetName, unsigned int entry, char name[128]) = NULL;
//FUNHOOK(CFTypeRef, IORegistryEntrySearchCFProperty, unsigned int entry, const char plane[128], CFStringRef key, CFAllocatorRef allocator, UInt32 options)
//{
//	CFTypeRef ret = _IORegistryEntrySearchCFProperty(entry, plane, key, allocator, options);
//
//	char name[128] = {0};
//	_IORegistryEntryGetName(entry, name);
//	if (_enableHook) _Log(@"IORegistryEntrySearchCFProperty (%s) %@ = %@", name, key, ret);
//
//	return ret;
//} ENDHOOK
//
////
//FUNHOOK(CFTypeRef, IORegistryEntryCreateCFProperty, unsigned int entry, CFStringRef key, CFAllocatorRef allocator, UInt32 options)
//{
//	CFTypeRef ret = _IORegistryEntryCreateCFProperty(entry, key, allocator, options);
//
//	char name[128] = {0};
//	_IORegistryEntryGetName(entry, name);
//	if (_enableHook) _Log(@"IORegistryEntryCreateCFProperty (%s) %@ = %@", name, key, ret);
//
//	return ret;
//} ENDHOOK
//
////
//FUNHOOK(int, IORegistryEntryCreateCFProperties, unsigned int entry, CFMutableDictionaryRef **properties, CFAllocatorRef allocator, UInt32 options)
//{
//	int ret = _IORegistryEntryCreateCFProperties(entry, properties, allocator, options);
//	if (properties)
//	{
//		NSMutableDictionary *dict = (__bridge NSMutableDictionary *)(*properties);
//		if (_enableHook) _Log(@"IORegistryEntryCreateCFProperties %@ %@", dict, dict[@"name"] ? [[NSString alloc] initWithData:dict[@"name"] encoding:NSUTF8StringEncoding] : @"NONAME");
//	}
//	return ret;
//} ENDHOOK

//
//MSGHOOK(void, PurchaseOperation_operation_willSendRequest, id arg1, id arg2)
//{
//	_enableHook = YES;
//	_Log(@"PurchaseOperation_operation_willSendRequest Begin %@, %@\n<<<<", arg1, arg2);
//	_PurchaseOperation_operation_willSendRequest(self, sel, arg1, arg2);
//	_Log(@"PurchaseOperation_operation_willSendRequest Ended %@, %@\n>>>>", arg1, arg2);
//	_enableHook = NO;
//} ENDHOOK
//
////
//MSGHOOK(id, AARequest_urlRequest)
//{
//	_enableHook = YES;
//	_Log(@"AARequest_urlRequest Begin\n<<<<");
//	id ret = _AARequest_urlRequest(self, sel);
//	_Log(@"AARequest_urlRequest Ended: %@\n>>>>", ret);
//	_enableHook = NO;
//	return ret;
//} ENDHOOK

//
int main()
{
	@autoreleasepool
	{
		NSString *processName = NSProcessInfo.processInfo.processName;

		if ([processName isEqualToString:@"itunesstored"] || [processName isEqualToString:@"Preferences"])
		{
			// 初始化函数指针
			_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookFunction);
			_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookMessageEx);

			_HOOKFUN(/usr/lib/libMobileGestalt.dylib, MGCopyAnswer);

//			_PTRFUN(/System/Library/Frameworks/IOKit.framework/IOKit, IORegistryEntryGetName);
//			_HOOKFUN(/System/Library/Frameworks/IOKit.framework/IOKit, IORegistryEntrySearchCFProperty);
//			_HOOKFUN(/System/Library/Frameworks/IOKit.framework/IOKit, IORegistryEntryCreateCFProperty);
//			_HOOKFUN(/System/Library/Frameworks/IOKit.framework/IOKit, IORegistryEntryCreateCFProperties);

			if ([processName isEqualToString:@"itunesstored"])
			{
				//_HOOKMSG(PurchaseOperation_operation_willSendRequest, PurchaseOperation, operation:willSendRequest:);

				//[[HTTPServer sharedHTTPServer] start];
			}
			else
			{
				HTTP_SERVER_PORT = 81;

				//_HOOKMSG(AARequest_urlRequest, AARequest, urlRequest);
			}

			[[HTTPServer sharedHTTPServer] start];
		}

		return 0;
	}
}
