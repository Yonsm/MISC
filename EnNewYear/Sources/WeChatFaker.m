
#ifdef _WECHAT

//
MSGHOOK(void, FindFriendEntryViewController_viewDidLoad)
{
	_Log(@"FindFriendEntryViewController_viewDidLoad:%@", self);
	_FindFriendEntryViewController_viewDidLoad(self, sel);

	[self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"春摇" style:UIBarButtonItemStylePlain target:self action:@selector(openNewYearShake)];
} ENDHOOK

//
MSGHOOK(void, NewYearShakeViewController_viewDidLoad)
{
	_Log(@"NewYearShakeViewController_viewDidLoad:%@", self);
	_NewYearShakeViewController_viewDidLoad(self, sel);

	[self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"功能" style:UIBarButtonItemStylePlain target:self action:@selector(NewYearShakeViewController_more:)];
} ENDHOOK

//
@protocol NewYearShakeViewController
- (id)initWithSponsorResID:(unsigned int)a1 countDown:(int)a2;
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
@end

@interface NewYearActionSheet : UIActionSheet <UIActionSheetDelegate>
@property(nonatomic,weak) id<NewYearShakeViewController> controller;
@end
@implementation NewYearActionSheet
- (id)initWithController:(id)controller
{
	self = [super initWithTitle:@"新春功能，请随意"
					   delegate:(id<UIActionSheetDelegate>)self
			  cancelButtonTitle:@"取消"
		 destructiveButtonTitle:nil
			  otherButtonTitles:
			@"功能一",
			@"功能二",
			@"功能三",
			@"功能四",
			@"功能五",
			@"功能六",
			@"功能七",
			@"功能八",
			@"功能九",
			@"功能十",
			@"功能零",
			nil];
	self.controller = controller;
	return self;
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
			[_controller Report];
			break;
	}
}

@end

//
@implementation UIViewController (NewYearShakeViewController)

//
- (void)NewYearShakeViewController_more:(UIBarButtonItem *)sender
{
	UIActionSheet *sheet = [[NewYearActionSheet alloc] initWithController:self];
	[sheet showFromBarButtonItem:sender animated:YES];
}
@end


//
#ifdef TEST
MSGHOOK(BOOL, NewYearSweetTimeViewController_bNeedMoreFun)
{
	_Log(@"NewYearSweetTimeViewController_bNeedMoreFun:%d", _NewYearSweetTimeViewController_bNeedMoreFun(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(BOOL, NewYearCtrlMgr_shouldShowHongBaoEntrance)
{
	_Log(@"NewYearCtrlMgr_shouldShowHongBaoEntrance:%d", _NewYearCtrlMgr_shouldShowHongBaoEntrance(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(BOOL, NewYearShakeMgr_shouldShake)
{
	_Log(@"NewYearShakeMgr_shouldShake:%d", _NewYearShakeMgr_shouldShake(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(BOOL, NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance)
{
	_Log(@"NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(BOOL, NewYearShakeMgr_shouldShowFamilyPhotoEntrance)
{
	_Log(@"NewYearShakeMgr_shouldShowFamilyPhotoEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoEntrance(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(BOOL, NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance)
{
	_Log(@"NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(BOOL, NewYearCtrlMgr_shouldShowRedDot)
{
	_Log(@"NewYearCtrlMgr_shouldShowRedDot:%d", _NewYearCtrlMgr_shouldShowRedDot(self, sel));
	return YES;
} ENDHOOK

//
MSGHOOK(id, NewYearCtrlMgr_getRedDotMsg)
{
	_Log(@"NewYearCtrlMgr_getRedDotMsg:%@", _NewYearCtrlMgr_getRedDotMsg(self, sel));
	return @"羊年春晚摇一摇";
} ENDHOOK

//
int type = 0;
MSGHOOK(int, NewYearShakeResponse_type)
{
	int ret = _NewYearShakeResponse_type(self, sel);
	_Log(@"NewYearShakeResponse_type:%d", ret);
	//_LogStack();
	return type++;
} ENDHOOK

//
MSGHOOK(int, NewYearShakeResponse_flag)
{
	int ret = _NewYearShakeResponse_flag(self, sel);
	_Log(@"NewYearShakeResponse_flag:%d", ret);
	//_LogStack();
	return ret;
} ENDHOOK

//
MSGHOOK(id, NewYearShakeResponse_parseFromData, id a3)
{
	id ret = _NewYearShakeResponse_parseFromData(self, sel, a3);
	_Log(@"NewYearShakeResponse_parseFromData:%@=>%@", ret, a3);
	_LogStack();
	return ret;
} ENDHOOK

//
MSGHOOK(unsigned int, NewYearShakeMgr_getRespType)
{
	unsigned int ret = _NewYearShakeMgr_getRespType(self, sel);
	_Log(@"NewYearShakeMgr_getRespType:%d", ret);
	_LogStack();
	return ret;
} ENDHOOK

//
MSGHOOK(void, NewYearShakeViewController_onNewYearShake_errCode, id a3, unsigned int a4)
{
	_Log(@"NewYearShakeViewController_onNewYearShake_errCode:%@->%d", a3, a4);
	_NewYearShakeViewController_onNewYearShake_errCode(self, sel, a3, a4);
	//[self showshowShakeFamilyPhoto]
} ENDHOOK
#endif

//
void WeChatFaker()
{
	_LogLine();
	_HOOKMSG(FindFriendEntryViewController_viewDidLoad, FindFriendEntryViewController, viewDidLoad);

	_HOOKMSG(NewYearShakeViewController_viewDidLoad, NewYearShakeViewController, viewDidLoad);

#ifdef TEST
	_HOOKMSG(NewYearSweetTimeViewController_bNeedMoreFun, NewYearSweetTimeViewController, bNeedMoreFun);
	_HOOKMSG(NewYearCtrlMgr_getRedDotMsg, NewYearCtrlMgr, getRedDotMsg);
	_HOOKMSG(NewYearCtrlMgr_shouldShowRedDot, NewYearCtrlMgr, shouldShowRedDot);
	_HOOKMSG(NewYearCtrlMgr_shouldShowHongBaoEntrance, NewYearCtrlMgr, shouldShowHongBaoEntrance);

	_HOOKMSG(NewYearShakeMgr_shouldShake, NewYearShakeMgr, shouldShake);
	_HOOKMSG(NewYearShakeResponse_parseFromData, NewYearShakeResponse, parseFromData:);
	_HOOKMSG(NewYearShakeViewController_onNewYearShake_errCode, NewYearShakeViewController, onNewYearShake:errCode:);
#endif
	
	_LogLine();
}

#endif
