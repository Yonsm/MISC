
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


MSGHOOK(BOOL, MicroMessengerAppDelegate_handleOpenURL_bundleID, id a3, id a4)
{
	_Log(@"MicroMessengerAppDelegate_handleOpenURL_bundleID:%@->%@", a3, a4);
	return _MicroMessengerAppDelegate_handleOpenURL_bundleID(self, sel, a3, a4);
} ENDHOOK
MSGHOOK(BOOL, MicroMessengerAppDelegate_application_openURL_sourceApplication_annotation, id a1, id a2, id a3, id a4)
{
	_Log(@"MicroMessengerAppDelegate_handleOpenURL_bundleID:%@->%@->%@", a2, a3, a4);
	return _MicroMessengerAppDelegate_application_openURL_sourceApplication_annotation(self, sel, a1, a2, a3, a4);
} ENDHOOK
MSGHOOK(BOOL, MicroMessengerAppDelegate_application_didFinishLaunchingWithOptions, id a3, id a4)
{
	_Log(@"MicroMessengerAppDelegate_application_didFinishLaunchingWithOptions:%@->%@", a3, a4);
	return _MicroMessengerAppDelegate_application_didFinishLaunchingWithOptions(self, sel, a3, a4);
} ENDHOOK
MSGHOOK(void, UIViewController_presentViewController_animated_completion, id a1, BOOL a2, id a3)
{
	_Log(@"UIViewController_presentViewController_animated_completion:%d->%@->%@", a2, a3, [a1 viewControllers]);

	return _UIViewController_presentViewController_animated_completion(self, sel, a1, a2, a3);
} ENDHOOK
MSGHOOK(id, WCNewCommitViewController_initWithImages_contacts, id a1, id a3)
{
	_Log(@"WCNewCommitViewController_initWithImages_contacts:%@->%@", a3, [a1[0] dataPath]);
	_LogStack();
	return _WCNewCommitViewController_initWithImages_contacts(self, sel, a1, a3);
} ENDHOOK

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

MSGHOOK(void, OpenApiMgr_doApi_bundleId, id a1, id a2, id a3)
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
	return _OpenApiMgr_doApi_bundleId(self, sel, a1, a2, a3);
} ENDHOOK
FUNHOOK(int, open, const char *path, int flag, mode_t mode)
{
	_Log(@"HOOK open %s, flag: %x, mode: %o", path, flag, mode);
	return _open(path, flag, mode);
} ENDHOOK

MSGHOOK(id, OpenApiMgrHelper_makeFileInternalMessage)
{
	_LogStack();
	id ret = _OpenApiMgrHelper_makeFileInternalMessage(self, sel);
	_Log(@"OpenApiMgrHelper_makeFileInternalMessage:%@", ret[@"wxfe8929c7097f09cc"][@"urls"]);
	_LogObj(ret[@"wxfe8929c7097f09cc"][@"command"]);
	return ret;
} ENDHOOK

//
MSGHOOK(BOOL, UIApplication_openURL, NSURL *URL)
{
	_Log(@"UIApplication_openURL: %@", URL);
	return _UIApplication_openURL(self, sel, URL);

} ENDHOOK

MSGHOOK(id, UIPasteboard_dataForPasteboardType, id type)
{
	NSData *ret = _UIPasteboard_dataForPasteboardType(self, sel, type);
	//if ([ret length] > 10000)
	{
		static int index = 0;
		BOOL r = [ret writeToFile:NSDocumentSubPath([NSString stringWithFormat:@"PBGet_%@_%d.plist", type, ++index]) atomically:YES];
		_Log(@"UIPasteboard_dataForPasteboardType:%@,%d,%d", type, r, (int)[ret length]);
	}
	return ret;
} ENDHOOK
MSGHOOK(void, UIPasteboard_setData_forPasteboardType, id data, id type)
{
	_UIPasteboard_setData_forPasteboardType(self, sel, data, type);
	//if ([ret length] > 10000)
	{
		static int index = 0;
		BOOL r = [data writeToFile:NSDocumentSubPath([NSString stringWithFormat:@"PBSet_%@_%d.plist", type, ++index]) atomically:YES];
		_Log(@"UIPasteboard_setData_forPasteboardType:%@,%d", type, r);
	}
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
	_HOOKCLS(NewYearShakeResponse_parseFromData, NewYearShakeResponse, parseFromData:);
	_HOOKMSG(NewYearShakeViewController_onNewYearShake_errCode, NewYearShakeViewController, onNewYearShake:errCode:);

	//_HOOKCLS(OpenApiMgrHelper_makeFileInternalMessage, AppCommunicate, propertyListForAllAppForiOS7Plus);
	//_HOOKMSG(OpenApiMgr_doApi_bundleId, SendAppMsgToWCHandler, sendAppMsgToWC:bundleId:withData:);

	//_HOOKMSG(WCNewCommitViewController_initWithImages_contacts, WCNewCommitViewController, initWithImages:contacts:);
	//_HOOKMSG(UIViewController_presentViewController_animated_completion, UIViewController, presentViewController:animated:completion:);

	//_HOOKMSG(MicroMessengerAppDelegate_application_didFinishLaunchingWithOptions, MicroMessengerAppDelegate, application:didFinishLaunchingWithOptions:);
	_HOOKMSG(MicroMessengerAppDelegate_handleOpenURL_bundleID, MicroMessengerAppDelegate, handleOpenURL:bundleID:);
	//_HOOKMSG(MicroMessengerAppDelegate_application_openURL_sourceApplication_annotation, MicroMessengerAppDelegate, application:openURL:sourceApplication:annotation:);

	_HOOKMSG(UIApplication_openURL, UIApplication, openURL:);

	_HOOKMSG(UIPasteboard_dataForPasteboardType, UIPasteboard, dataForPasteboardType:);
	_HOOKMSG(UIPasteboard_setData_forPasteboardType, UIPasteboard, setData:forPasteboardType:);
#endif
	
	_LogLine();
}

#endif
