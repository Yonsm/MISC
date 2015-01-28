
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

MSGHOOK(BOOL, NewYearShakeMgr_shouldShake)
{
	NSLog(@"NewYearShakeMgr_shouldShake:%d", _NewYearShakeMgr_shouldShake(self, sel));
	return YES;
} ENDHOOK
MSGHOOK(BOOL, NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance)
{
	NSLog(@"NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance(self, sel));
	return YES;
} ENDHOOK
MSGHOOK(BOOL, NewYearShakeMgr_shouldShowFamilyPhotoEntrance)
{
	NSLog(@"NewYearShakeMgr_shouldShowFamilyPhotoEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoEntrance(self, sel));
	return YES;
} ENDHOOK
MSGHOOK(BOOL, NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance)
{
	NSLog(@"NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance(self, sel));
	return YES;
} ENDHOOK

MSGHOOK(BOOL, NewYearCtrlMgr_shouldShowRedDot)
{
	NSLog(@"NewYearCtrlMgr_shouldShowRedDot:%d", _NewYearCtrlMgr_shouldShowRedDot(self, sel));
	return YES;
} ENDHOOK

MSGHOOK(id, NewYearCtrlMgr_getRedDotMsg)
{
	NSLog(@"NewYearCtrlMgr_getRedDotMsg:%@", _NewYearCtrlMgr_getRedDotMsg(self, sel));
	return @"哈哈哈哈，红包开启咯";
} ENDHOOK

int type = 0;
MSGHOOK(int, NewYearShakeResponse_type)
{
	int ret = _NewYearShakeResponse_type(self, sel);
	NSLog(@"NewYearShakeResponse_type:%d", ret);
	//_LogStack();
	return type++;
} ENDHOOK

MSGHOOK(int, NewYearShakeResponse_flag)
{
	int ret = _NewYearShakeResponse_flag(self, sel);
	NSLog(@"NewYearShakeResponse_flag:%d", ret);
	//_LogStack();
	return ret;
} ENDHOOK

MSGHOOK(id, NewYearShakeResponse_parseFromData, id a3)
{
	id ret = _NewYearShakeResponse_parseFromData(self, sel, a3);
	NSLog(@"NewYearShakeResponse_parseFromData:%@=>%@", ret, a3);
	_LogStack();
	return ret;
} ENDHOOK

MSGHOOK(unsigned int, NewYearShakeMgr_getRespType)
{
	unsigned int ret = _NewYearShakeMgr_getRespType(self, sel);
	NSLog(@"NewYearShakeMgr_getRespType:%d", ret);
	_LogStack();
	return ret;
} ENDHOOK

MSGHOOK(void, NewYearShakeViewController_onNewYearShake_errCode, id a3, unsigned int a4)
{
	NSLog(@"NewYearShakeViewController_onNewYearShake_errCode:%@->%d", a3, a4);
	_NewYearShakeViewController_onNewYearShake_errCode(self, sel, a3, a4);
	//[self showshowShakeFamilyPhoto]
} ENDHOOK

//
@protocol NewYearShakeViewControllerProtocol <NSObject>
- (void)showShakeFamilyPhoto:(BOOL)flag;
- (void)showShakeFriend:(id)a1 Fee:(unsigned int)a2;
- (void)showShowList:(id)a1 CurShowID:(unsigned int)a2;
- (void)ShowWebWithResUrl:(id)a1 Type:(unsigned int)a2;
- (void)showPostCard;
- (void)showNoHongBao:(unsigned int)a;
- (void)showNoSvr:(BOOL)flag;
- (void)showErr;
- (void)ShowSight;
- (void)Report;
- (id)initWithSponsorResID:(unsigned int)a1 countDown:(int)a2;
@end

//
@interface MyNewYear : NSObject <UIActionSheetDelegate>
@property(nonatomic,weak) id<NewYearShakeViewControllerProtocol> controller;
@end

@implementation MyNewYear

//
- (id)initWithController:(id)controller
{
	self = [super init];
	self.controller = controller;
	return self;
}

//
- (void)show:(id)sender
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"新春功能，请随意"
													   delegate:self
											  cancelButtonTitle:@"取消"
										 destructiveButtonTitle:nil
											  otherButtonTitles:
							@"showShakeFamilyPhoto(YES)",
							@"showShakeFriend(Fee)",
							@"showShowList(0)",
							@"showShowList(1)",
							@"ShowWebWithResUrl",
							@"showPostCard",
							@"showNoHongBao(0)",
							@"showNoSvr(YES)",
							@"showErr",
							@"ShowSight",
							@"Report",
							nil];
	[sheet showFromBarButtonItem:sender animated:YES];
}

//
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
			[_controller showShakeFamilyPhoto:YES];
			break;

		case 1:
			[_controller showShakeFriend:nil Fee:99];
			break;

		case 2:
			[_controller showShowList:nil CurShowID:0];
			break;
		case 3:
			[_controller showShowList:nil CurShowID:1];
			break;
		case 4:
			[_controller ShowWebWithResUrl:@"http://m.163.com" Type:0];
			break;

		case 5:
			[_controller showPostCard];
			break;

		case 6:
			[_controller showNoHongBao:1];
			break;

		case 7:
			[_controller showErr];
			break;

		case 8:
			[_controller showShakeFamilyPhoto:NO];
			break;

		case 9:
			[_controller ShowSight];
			break;

		case 10:
			//[_controller Report];
		{
			id vc = [[NSClassFromString(@"WCRedEnvelopesRedEnvelopesHistoryListViewController") alloc] init/*WithSponsorResID:110 countDown:110*/];
			[[(UIViewController *)_controller navigationController] pushViewController:vc animated:YES];
		}
			break;
	}
}

@end

//
MyNewYear *_myNewYear;
MSGHOOK(void, NewYearShakeViewController_viewDidLoad)
{
	NSLog(@"NewYearShakeViewController_viewDidLoad:%@", self);
	_NewYearShakeViewController_viewDidLoad(self, sel);

	_myNewYear = [[MyNewYear alloc] initWithController:self];
	[self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"功能" style:UIBarButtonItemStylePlain target:_myNewYear action:@selector(show:)];
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
			_HOOKMSG(NewYearCtrlMgr_getRedDotMsg, NewYearCtrlMgr, getRedDotMsg);
			_HOOKMSG(NewYearCtrlMgr_shouldShowRedDot, NewYearCtrlMgr, shouldShowRedDot);
			_HOOKMSG(NewYearCtrlMgr_shouldShowHongBaoEntrance, NewYearCtrlMgr, shouldShowHongBaoEntrance);
			_HOOKMSG(FindFriendEntryViewController_viewDidLoad, FindFriendEntryViewController, viewDidLoad);

			_HOOKMSG(NewYearShakeMgr_shouldShake, NewYearShakeMgr, shouldShake);
//			_HOOKMSG(NewYearShakeMgr_shouldShowFamilyPhotoEntrance, NewYearShakeMgr, shouldShowFamilyPhotoEntrance);
//			_HOOKMSG(NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance, NewYearShakeMgr, shouldShowFamilyPhotoShareEntrance);
//			_HOOKMSG(NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance, NewYearShakeMgr, shouldShowFamilyPhotoShareTimeLineEntrance);

//			_HOOKMSG(NewYearShakeMgr_getRespType, NewYearShakeMgr, getRespType);
//
//			_HOOKMSG(NewYearShakeResponse_type, NewYearShakeResponse, type);
//			_HOOKMSG(NewYearShakeResponse_flag, NewYearShakeResponse, flag);

			_HOOKMSG(NewYearShakeResponse_parseFromData, NewYearShakeResponse, parseFromData:);

			_HOOKMSG(NewYearShakeViewController_onNewYearShake_errCode, NewYearShakeViewController, onNewYearShake:errCode:);

			_HOOKMSG(NewYearShakeViewController_viewDidLoad, NewYearShakeViewController, viewDidLoad);
		}
	}
	return 0;
}
