
#ifdef _WECHAT

//
_HOOK_MESSAGE(void, FindFriendEntryViewController, viewDidLoad)
{
	_Log(@"FindFriendEntryViewController_viewDidLoad:%@", self);
	_FindFriendEntryViewController_viewDidLoad(self, sel);

	[self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"春摇" style:UIBarButtonItemStylePlain target:self action:@selector(openNewYearShake)];
}

//
_HOOK_MESSAGE(void, NewYearShakeViewController, viewDidLoad)
{
	_Log(@"NewYearShakeViewController_viewDidLoad:%@", self);
	_NewYearShakeViewController_viewDidLoad(self, sel);

	[self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"功能" style:UIBarButtonItemStylePlain target:self action:@selector(NewYearShakeViewController_more:)];
}

//
@protocol NewYearShakeViewController
-(id)initWithSponsorResID:(unsigned int)a1 countDown:(int)a2;
-(void)showShakeFamilyPhoto:(BOOL)flag;
-(void)showShakeFriend:(id)a1 Fee:(unsigned int)a2;
-(void)showShowList:(id)a1 CurShowID:(unsigned int)a2;
-(void)ShowWebWithResUrl:(id)a1 Type:(unsigned int)a2;
-(void)showPostCard;
-(void)showNoHongBao:(unsigned int)a;
-(void)showNoSvr:(BOOL)flag;
-(void)showErr;
-(void)ShowSight;
-(void)Report;
-(id)dataPath;
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
_HOOK_MESSAGE(BOOL, NewYearSweetTimeViewController, bNeedMoreFun)
{
	_Log(@"NewYearSweetTimeViewController_bNeedMoreFun:%d", _NewYearSweetTimeViewController_bNeedMoreFun(self, sel));
	return YES;
}

//
_HOOK_MESSAGE(BOOL, NewYearCtrlMgr, shouldShowHongBaoEntrance)
{
	_Log(@"NewYearCtrlMgr_shouldShowHongBaoEntrance:%d", _NewYearCtrlMgr_shouldShowHongBaoEntrance(self, sel));
	return YES;
}

//
_HOOK_MESSAGE(BOOL, NewYearShakeMgr, shouldShake)
{
	_Log(@"NewYearShakeMgr_shouldShake:%d", _NewYearShakeMgr_shouldShake(self, sel));
	return YES;
}

//
_HOOK_MESSAGE(BOOL, NewYearShakeMgr, shouldShowFamilyPhotoShareTimeLineEntrance)
{
	_Log(@"NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoShareTimeLineEntrance(self, sel));
	return YES;
}

//
_HOOK_MESSAGE(BOOL, NewYearShakeMgr, shouldShowFamilyPhotoEntrance)
{
	_Log(@"NewYearShakeMgr_shouldShowFamilyPhotoEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoEntrance(self, sel));
	return YES;
}

//
_HOOK_MESSAGE(BOOL, NewYearShakeMgr, shouldShowFamilyPhotoShareEntrance)
{
	_Log(@"NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance:%d", _NewYearShakeMgr_shouldShowFamilyPhotoShareEntrance(self, sel));
	return YES;
}

//
_HOOK_MESSAGE(BOOL, NewYearCtrlMgr, shouldShowRedDot)
{
	_Log(@"NewYearCtrlMgr_shouldShowRedDot:%d", _NewYearCtrlMgr_shouldShowRedDot(self, sel));
	return YES;
}

//
_HOOK_MESSAGE(id, NewYearCtrlMgr, getRedDotMsg)
{
	_Log(@"NewYearCtrlMgr_getRedDotMsg:%@", _NewYearCtrlMgr_getRedDotMsg(self, sel));
	return @"羊年春晚摇一摇";
}

//
int type = 0;
_HOOK_MESSAGE(int, NewYearShakeResponse, type)
{
	int ret = _NewYearShakeResponse_type(self, sel);
	_Log(@"NewYearShakeResponse_type:%d", ret);
	//_LogStack();
	return type++;
}

//
_HOOK_MESSAGE(int, NewYearShakeResponse, flag)
{
	int ret = _NewYearShakeResponse_flag(self, sel);
	_Log(@"NewYearShakeResponse_flag:%d", ret);
	//_LogStack();
	return ret;
}

//
_HOOK_MESSAGE(id, NewYearShakeResponse, parseFromData_, id a3)
{
	id ret = _NewYearShakeResponse_parseFromData_(self, sel, a3);
	_Log(@"NewYearShakeResponse_parseFromData:%@=>%@", ret, a3);
	_LogStack();
	return ret;
}

//
_HOOK_MESSAGE(unsigned int, NewYearShakeMgr, getRespType)
{
	unsigned int ret = _NewYearShakeMgr_getRespType(self, sel);
	_Log(@"NewYearShakeMgr_getRespType:%d", ret);
	_LogStack();
	return ret;
}

//
_HOOK_MESSAGE(void, NewYearShakeViewController, onNewYearShake_errCode_, id a3, unsigned int a4)
{
	_Log(@"NewYearShakeViewController_onNewYearShake_errCode:%@->%d", a3, a4);
	_NewYearShakeViewController_onNewYearShake_errCode_(self, sel, a3, a4);
	//[self showshowShakeFamilyPhoto]
}


_HOOK_MESSAGE(BOOL, MicroMessengerAppDelegate, handleOpenURL_bundleID_, id a3, id a4)
{
	_Log(@"MicroMessengerAppDelegate_handleOpenURL_bundleID:%@->%@", a3, a4);
	return _MicroMessengerAppDelegate_handleOpenURL_bundleID_(self, sel, a3, a4);
}
_HOOK_MESSAGE(BOOL, MicroMessengerAppDelegate, application_openURL_sourceApplication_annotation_, id a1, id a2, id a3, id a4)
{
	_Log(@"MicroMessengerAppDelegate_handleOpenURL_bundleID:%@->%@->%@", a2, a3, a4);
	return _MicroMessengerAppDelegate_application_openURL_sourceApplication_annotation_(self, sel, a1, a2, a3, a4);
}
_HOOK_MESSAGE(BOOL, MicroMessengerAppDelegate, application_didFinishLaunchingWithOptions_, id a3, id a4)
{
	_Log(@"MicroMessengerAppDelegate_application_didFinishLaunchingWithOptions:%@->%@", a3, a4);
	return _MicroMessengerAppDelegate_application_didFinishLaunchingWithOptions_(self, sel, a3, a4);
}
_HOOK_MESSAGE(void, UIViewController, presentViewController_animated_completion_, id a1, BOOL a2, id a3)
{
	_Log(@"UIViewController_presentViewController_animated_completion:%d->%@->%@", a2, a3, [a1 viewControllers]);

	return _UIViewController_presentViewController_animated_completion_(self, sel, a1, a2, a3);
}
_HOOK_MESSAGE(id, WCNewCommitViewController, initWithImages_contacts_, id a1, id a3)
{
	_Log(@"WCNewCommitViewController_initWithImages_contacts:%@->%@", a3, [a1[0] dataPath]);
	_LogStack();
	return _WCNewCommitViewController_initWithImages_contacts_(self, sel, a1, a3);
}

@protocol XXX <NSObject>
-(id)DataToReq;
-(id)DataToResp;
-(id)authRequest;
-(id)authResp;
-(int)command;
-(id)conversationAccount;
-(id)country;
-(id)fileData;
-(id)fileDatas;
-(id)lang;
-(id)mediaInternalMessage;
-(id)mediaMessage;
-(id)openID;
-(id)propertList;
-(int)result;
-(BOOL)returnFromApp;
-(int)scene;
-(id)sdkVer;
-(id)textMessage;
@end

_HOOK_MESSAGE(void, OpenApiMgr, doApi_bundleId_, id a1, id a2, id a3)
{
	_Log(@"OpenApiMgr_doApi_bundleId:%@, %@, %@", a1, a2, a3);

	NSLog(@"%@:%@", @"DataToReq", [a3 DataToReq]);
	NSLog(@"%@:%@", @"DataToResp", [a3 DataToResp]);
	NSLog(@"%@:%@", @"authRequest", [a3 authRequest]);
	NSLog(@"%@:%@", @"authResp", [a3 authResp]);
	NSLog(@"%@:%d", @"command", [a3 command]);
	NSLog(@"%@:%@", @"conversationAccount", [a3 conversationAccount]);
	NSLog(@"%@:%@", @"country", [a3 country]);
	NSLog(@"%@:%@", @"fileData", [a3 fileData]);
	//NSLog(@"%@:%@", @"fileDatas", [a3 fileDatas]);
	NSLog(@"%@:%@", @"lang", [a3 lang]);
	NSLog(@"%@:%@", @"mediaInternalMessage", [a3 mediaInternalMessage]);
	NSLog(@"%@:%@", @"mediaMessage", [a3 mediaMessage]);
	NSLog(@"%@:%@", @"openID", [a3 openID]);
	//NSLog(@"%@:%@", @"propertList", [a3 propertList]);
	NSLog(@"%@:%d", @"returnFromApp", [a3 returnFromApp]);
	NSLog(@"%@:%d", @"scene", [a3 scene]);
	NSLog(@"%@:%@", @"sdkVer", [a3 sdkVer]);
	NSLog(@"%@:%@", @"textMessage", [a3 textMessage]);
	NSLog(@"%@:%d", @"result", [(id<XXX>)a3 result]);

	//_LogStack();
	return _OpenApiMgr_doApi_bundleId_(self, sel, a1, a2, a3);
}

_HOOK_MESSAGE(id, OpenApiMgrHelper, makeFileInternalMessage)
{
	_LogStack();
	id ret = _OpenApiMgrHelper_makeFileInternalMessage(self, sel);
	_Log(@"OpenApiMgrHelper_makeFileInternalMessage:%@", ret[@"wxfe8929c7097f09cc"][@"urls"]);
	_LogObj(ret[@"wxfe8929c7097f09cc"][@"command"]);
	return ret;
}

//
_HOOK_MESSAGE(BOOL, UIApplication, openURL_, NSURL *URL)
{
	_Log(@"UIApplication_openURL: %@", URL);
	return _UIApplication_openURL_(self, sel, URL);

}
#endif

//
void WeChatFaker()
{
	_LogLine();

	_Init_FindFriendEntryViewController_viewDidLoad();
	_Init_NewYearShakeViewController_viewDidLoad();
}

#endif
