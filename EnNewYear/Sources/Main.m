
//FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result) = NULL;
FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result) = NULL;

//
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result)
{
	(*(result) = method_setImplementation(class_getInstanceMethod((_class), (sel)), (imp)));
}

//
#ifdef TEST
MSGHOOK(BOOL, UIApplication_openURL, NSURL *URL)
{
	_Log(@"UIApplication_openURL: %@", URL);
	return _UIApplication_openURL(self, sel, URL);

} ENDHOOK
#endif

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
#ifdef _ACCELERATE
		if (!_MSHookMessageEx)
		{
			_MSHookMessageEx = &MSHookMessageEx;	// 如果不需要 MSHookFunction，可以不用引入 CydiaSubstrate

			// TODO: Crash
			//_PTRFUN(@executable_path/CydiaSubstrate, MSHookFunction);
			//_PTRFUN(@executable_path/CydiaSubstrate, MSHookMessageEx);

			extern void AccelerateFaker();
			AccelerateFaker();
			_LogLine();
		}
#endif

		// 信息
		NSProcessInfo *processInfo = NSProcessInfo.processInfo;
		NSString *processName = processInfo.processName;
		_Log(@"Process(%@) ARGS(%@) UID(%d) MSHookMessageEx(%p)", processName, processInfo.arguments, geteuid(), _MSHookMessageEx);

		//
#ifdef _WECHAT
		if ([processName isEqualToString:@"MicroMessenger"])
		{
			_LogLine();
			extern void WeChatFaker();
			WeChatFaker();
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

#ifdef TEST
		_HOOKMSG(UIApplication_openURL, UIApplication, openURL:);
#endif

	}
	return 0;
}
