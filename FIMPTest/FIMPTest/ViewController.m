//
//  ViewController.m
//  FIMPTest
//
//  Created by 郭春杨 on 15/2/9.
//  Copyright (c) 2015年 Yonsm.NET. All rights reserved.
//

#import "ViewController.h"


#define TEST
#define _WECHAT
#define _PORTAL
#define kWeChatShareMakeThumb(image, size) image

#import <mach/mach_host.h>
#import <objc/runtime.h>
#import <sys/stat.h>
#import <dlfcn.h>

//
#define _DLSYM(lib, func)				dlsym(dlopen(#lib, RTLD_LAZY), #func)

#define FUNPTR(ret, func, ...)			ret (*_##func)(__VA_ARGS__)
#define PTRSET(func, val)				*((void **)&_##func) = val
#define _PTRFUN(lib, func)				PTRSET(func, _DLSYM(lib, func))

//
#define EXPHOOK(ret, func, ...)			static ret (*_##func)(__VA_ARGS__); __attribute__((visibility("default"))) ret func(__VA_ARGS__) {{
#define FUNHOOK(ret, func, ...)			static ret (*_##func)(__VA_ARGS__); static ret $##func(__VA_ARGS__) {{
#define MSGHOOK(ret, hook, ...)			static ret (*_##hook)(id self, SEL sel, ##__VA_ARGS__); static ret $##hook(id self, SEL sel, ##__VA_ARGS__) {{
#define ENDHOOK							}}

//
#define _HOOKFUN(lib, func)				_MSHookFunction(_DLSYM(lib, func), (void *)$##func, (void **)&_##func)
#define _HOOKMSG(hook, cls, sel)		_MSHookMessageEx(NSClassFromString(@#cls), @selector(sel), (IMP)$##hook, (IMP *)&_##hook)
#define _HOOKCLS(hook, cls, sel)		_MSHookMessageEx(objc_getMetaClass(#cls), @selector(sel), (IMP)$##hook, (IMP *)&_##hook)



FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result);
FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result);


@class NSString;

@interface AASigningSession : NSObject  {
	NSString *_certURL;
	NSString *_sessionURL;
	int _error;
}

@property(readonly) int error;


- (id)signatureForData:(id)arg1;
- (void)establishSession;
- (id)initWithCertURL:(id)arg1 sessionURL:(id)arg2;
- (int)error;
- (void)dealloc;
//- (void).cxx_destruct;

@end


FUNHOOK(void, AALog, NSString *str, int level)
{
	NSLog(str, level);
} ENDHOOK

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//[self performSelector:@selector(test) withObject:nil afterDelay:0.4];


	CFTypeRef result = NULL;
	NSDictionary *dict = @{
	  (__bridge id)kSecAttrService:@"AppleIDClientIdentifier",
	  (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
	  (__bridge id)kSecReturnData:(__bridge id)kCFBooleanTrue
	  };
	SecItemCopyMatching((__bridge CFDictionaryRef)dict, &result);
	NSLog(@"%@", result);
}

//
- (void)test
{
	_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookFunction);
	_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookMessageEx);


	_HOOKFUN(/System/Library/PrivateFrameworks/AppleAccount.framework/AppleAccount, AALog);

	NSDictionary *settingDict;
	{
		NSHTTPURLResponse* response = nil;
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://setup.icloud.com/configurations/init?context=settings"]];
		[request setValue:@"CN" forHTTPHeaderField:@"X-MMe-Country"];
		[request setValue:@"<iPhone5,3> <iPhone OS;8.1.2;12B440> <com.apple.AppleAccount/1.0 (com.apple.Preferences/1.0)>" forHTTPHeaderField:@"X-MMe-Client-Info"];
		[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];
		[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];

		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		settingDict = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
	}

	NSString *certUrl = settingDict[@"urls"][@"qualifyCert"];
	NSString *sessionUrl = settingDict[@"urls"][@"qualifySession"];
	AASigningSession *session = [[AASigningSession alloc] initWithCertURL:certUrl sessionURL:sessionUrl];
	printf("%d", 0x12345678);
	[session establishSession];
	printf("%u", 0x9999999);
	id sign = [session signatureForData:@"XX"];
}

@end
