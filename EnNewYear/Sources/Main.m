
//FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result) = NULL;
FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result) = NULL;

//
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result)
{
	*(result) = method_setImplementation(class_getInstanceMethod((_class), (sel)), (imp));
}

#import "WeChatShareFaker.h"

@interface XXXXX : NSObject

@end
@implementation XXXXX

-(void)test
{
	WeChatShareDirect(@[[UIImage imageNamed:@"Icon"]], 0, kWeChatShareFromExtension);
}

@end

//
int main()
{
#if !DEBUG
	@autoreleasepool
#endif
	{
		// 初始化函数指针
		//_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookFunction);
		_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookMessageEx);
		if (!_MSHookMessageEx)
		{
			_MSHookMessageEx = &MSHookMessageEx;	// 如果不需要 MSHookFunction，可以不用引入 CydiaSubstrate

			// TODO: Crash
			//_PTRFUN(@executable_path/CydiaSubstrate, MSHookFunction);
			//_PTRFUN(@executable_path/CydiaSubstrate, MSHookMessageEx);
		}

		// 信息
		NSProcessInfo *processInfo = NSProcessInfo.processInfo;
		NSString *processName = processInfo.processName;
		_Log(@"Process(%@) ARGS(%@) UID(%d) MSHookMessageEx(%p)", processName, processInfo.arguments, geteuid(), _MSHookMessageEx);

		//
#ifdef _WECHAT
		if ([processName isEqualToString:@"MicroMessenger"] || [processName isEqualToString:@"SDKSample"])
		{
			_LogLine();
			extern void WeChatFaker();
			WeChatFaker();

			if ([processName isEqualToString:@"SDKSample"])
			{
				[[[XXXXX alloc] init] performSelector:@selector(test) withObject:nil afterDelay:2];
			}
		}
#endif
#ifdef _PORTAL
		if ([processName isEqualToString:@"Portal"])
		{
			_LogLine();
			extern void PortalFaker();
			PortalFaker();
		}
#endif

	}
	return 0;
}
