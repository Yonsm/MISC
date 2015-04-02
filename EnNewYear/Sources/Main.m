

//
int main()
{
#if !DEBUG
	@autoreleasepool
#endif
	{
		// 信息
		NSString *processName = NSProcessInfo.processInfo.processName;

		//
#ifdef _WECHAT
		if ([processName isEqualToString:@"MicroMessenger"] || [processName isEqualToString:@"SDKSample"])
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

	}
	return 0;
}
