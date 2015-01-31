
//FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result) = NULL;
FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result) = NULL;

//
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result)
{
	(*(result) = method_setImplementation(class_getInstanceMethod((_class), (sel)), (imp)));
}

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

			extern void AccelerateFaker();
			AccelerateFaker();
			_LogLine();
		}

		// 信息
		NSProcessInfo *processInfo = NSProcessInfo.processInfo;
		NSString *processName = processInfo.processName;
		NSArray *arguments = processInfo.arguments;
		_Log(@"Process(%@) ARGS(%@) UID(%d) MSHookMessageEx(%p)", processName, arguments, geteuid(), _MSHookMessageEx);

		//
		if ([processName isEqualToString:@"MicroMessenger"])
		{
			_LogLine();
			extern void WeChatFaker();
			WeChatFaker();
		}
		else if ([processName isEqualToString:@"Portal"])
		{
			_LogLine();
			extern void PortalFaker();
			PortalFaker();
		}
	}
	return 0;
}
