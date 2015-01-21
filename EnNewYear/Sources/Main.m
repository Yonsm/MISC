
FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result) = NULL;
FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result) = NULL;



MSGHOOK(void, FindFriendEntryViewController_viewDidLoad)
{
	NSLog(@"FindFriendEntryViewController_viewDidLoad:%@", self);
	_FindFriendEntryViewController_viewDidLoad(self, sel);

	[self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"春摇" style:UIBarButtonItemStylePlain target:self action:@selector(openNewYearShake)];
} ENDHOOK

//
//MSGHOOK(void, SettingAboutMMViewController_ShowWhatsNew)
//{
//	_LineLog();
//	id controller = [[NSClassFromString(@"NewYearShakeViewController") alloc] init];
//	[[self navigationController] pushViewController:controller animated:YES];
//	_LineLog();
//} ENDHOOK

MSGHOOK(BOOL, NewYearSweetTimeViewController_bNeedMoreFun)
{
	NSLog(@"NewYearSweetTimeViewController_bNeedMoreFun:%d", _NewYearSweetTimeViewController_bNeedMoreFun(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(BOOL, NewYearCtrlMgr_shouldShowHongBaoEntrance)
{
	NSLog(@"NewYearCtrlMgr_shouldShowHongBaoEntrance:%d", _NewYearCtrlMgr_shouldShowHongBaoEntrance(self, sel));
	return YES;
} ENDHOOK

//
int main()
{
#if !DEBUG
	@autoreleasepool
#endif
	{
		// 信息
		NSProcessInfo *processInfo = NSProcessInfo.processInfo;
		NSString *processName = processInfo.processName;
		//NSArray *arguments = processInfo.arguments;
		//NSLog(@"Process(%@) ARGS(%@) UID(%d)", processName, arguments, geteuid());
		if ([processName isEqualToString:@"MicroMessenger"])
		{
			// 初始化函数指针
			_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookFunction);
			_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookMessageEx);

			//_HOOKMSG(SettingAboutMMViewController_ShowWhatsNew, SettingAboutMMViewController, ShowWhatsNew);
			_HOOKMSG(NewYearSweetTimeViewController_bNeedMoreFun, NewYearSweetTimeViewController, bNeedMoreFun);
			_HOOKMSG(NewYearCtrlMgr_shouldShowHongBaoEntrance, NewYearCtrlMgr, shouldShowHongBaoEntrance);
			_HOOKMSG(FindFriendEntryViewController_viewDidLoad, FindFriendEntryViewController, viewDidLoad);
		}

	}
	return 0;
}
