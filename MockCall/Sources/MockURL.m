


//
HOOK_MESSAGE(void, ALPAssetsRootViewController, viewWillAppear_, BOOL animated)
{
    _Log(@"Mocks: %@", self);
    _ALPAssetsRootViewController_viewWillAppear_(self, sel, animated);
    [self navigationItem].leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AccountInfo.bundle/icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(setMockCallSetting)];
}

//
@implementation UIViewController (SetMockCallSetting)

- (void)setMockCallSetting
{
    [self setMockCallSetting2:self];
}

//
- (void)setMockCallSetting2:(id)delegate
{
    _Log(@"Mocks: %@", self);
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"MockConfigUrl"];
    url = (mockConfigUrl.length > 0) ? mockConfigUrl : url;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"MockCall 服务器"
                                                        message:nil
                                                       delegate:delegate
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeURL;
    [alertView textFieldAtIndex:0].text = url;
    [alertView show];
}

//
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        mockConfigUrl = [alertView textFieldAtIndex:0].text;
        if (mockConfigUrl.length > 0)
        {
            if (![mockConfigUrl hasPrefix:@"http"])
            {
                mockConfigUrl = [@"http://" stringByAppendingString:mockConfigUrl];
            }
            
            NSArray *components = [mockConfigUrl componentsSeparatedByString:@"://"];
            if (components.count != 2)
            {
                [self setMockCallSetting];
                return;
            }
            
            if ([components[1] rangeOfString:@"/"].location == NSNotFound)
                mockConfigUrl = [mockConfigUrl stringByAppendingString:@"/mock.txt"];
        }
        else
        {
            mockConfigUrl = @"";
        }
        
        _Log(@"Mocks: save mockconfigurl=%@", mockConfigUrl);
        [[NSUserDefaults standardUserDefaults] setObject:mockConfigUrl forKey:@"MockConfigUrl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        configDict = nil;
    }
    
    NSURL *url = [NSURL URLWithString:@"alipays://platformapi/startApp?appId=20000001"];
    [[UIApplication sharedApplication] openURL:url];
    return;
}

@end

//
BOOL processOpenUrl(NSURL *url)
{
    NSString *mockUrl = url.absoluteString;
    _Log(@"Mocks: scancode = %@", mockUrl);
    NSString *prefix = @"alipays://mockcall/";
    if ([mockUrl hasPrefix:prefix])
    {
        _Log(@"Mocks: match mockcall");
        mockConfigUrl = [mockUrl substringFromIndex:prefix.length];
        _Log(@"Mocks: %@", mockConfigUrl);
        if (!vc) vc = [[UIViewController alloc] init];
        [vc setMockCallSetting2:vc];
        return YES;
    }
    else
    {
        _Log(@"Mocks: not match mockcall");
        return NO;
    }
}

//
HOOK_MESSAGE(BOOL, DFClientDelegate, application_openURL_sourceApplication_annotation_, UIApplication *application, NSURL *url, NSString *sourceApplication, id annotation)
{
    _Log(@"Mocks: handleOpenURL=%@", url.description);
    if (!processOpenUrl(url))
        return _DFClientDelegate_application_openURL_sourceApplication_annotation_(self, sel, application, url, sourceApplication, annotation);
    else
        return YES;
}

HOOK_MESSAGE(BOOL, DFClientDelegate, application_didFinishLaunchingWithOptions_, UIApplication *application, NSDictionary *launchOptions)
{
    _Log(@"Mocks: launchOptions = %@", launchOptions.description);
    if (launchOptions) {
        NSURL *url = launchOptions[@"UIApplicationLaunchOptionsURLKey"];
        _Log(@"Mocks: UIApplicationLaunchOptionsURLKey=%@", url);
        if (url) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    processOpenUrl(url);
            });
        }
    }
    return _DFClientDelegate_application_didFinishLaunchingWithOptions_(self, sel, application, launchOptions);
}

HOOK_MESSAGE(void, UIAlertView, show)
{
    _Log(@"Mocks: UIAlertView:%@", self);
    UIAlertView *alertView = self;
    if ([alertView.title isEqualToString:@"提示"] && [alertView.message containsString:@"mockcall"])
    {
        NSRange range = [alertView.message rangeOfString:@"alipays://mockcall/"];
        if (range.location != NSNotFound) {
            NSString *url = [alertView.message substringFromIndex:range.location];
            processOpenUrl([NSURL URLWithString:url]);
        }
    }
    else
    {
        _UIAlertView_show(self, sel);
    }
}
