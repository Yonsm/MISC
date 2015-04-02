
//
#import <vector>
#import <algorithm>

//
void LogData(const void *data, size_t dataLength, void *returnAddress)
{
	if (data == nil || dataLength == 0) return;

	static int s_index = 0;
	static NSString *_logDir = nil;
	static std::vector<NSURLRequest *> _requests;

	if (_logDir == nil)
	{
		_logDir = [[NSString alloc] initWithFormat:@"/tmp/%@.req", NSProcessInfo.processInfo.processName];
		[[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
	}

	Dl_info info = {0};
	dladdr(returnAddress, &info);

	BOOL txt = !memcmp(data, "GET ", 4) || !memcmp(data, "POST ", 5);
	NSString *str = [NSString stringWithFormat:@"FROM %s(%p)-%s(%p=>%#08lx)\n<%@>\n\n", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, [NSThread callStackSymbols]];
	NSLog(@"HTTPEEK DATA: %@", str);

	NSMutableData *dat = [NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
	[dat appendBytes:data length:dataLength];
	if (txt) NSLog(@"%@", [[NSString alloc] initWithBytesNoCopy:(void *)data length:dataLength encoding:NSUTF8StringEncoding freeWhenDone:NO]);

	NSString *file = [NSString stringWithFormat:@"%@/DATA.%03d.%@", _logDir, s_index++, txt ? @"txt" : @"dat"];
	[dat writeToFile:file atomically:NO];
}

//
void LogRequest(NSURLRequest *request, void *returnAddress)
{
	static int s_index = 0;
	static NSString *_logDir = nil;
	static std::vector<NSURLRequest *> _requests;

	if (_logDir == nil)
	{
		_logDir = [[NSString alloc] initWithFormat:@"/tmp/%@.req", NSProcessInfo.processInfo.processName];
		[[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
	}

	if ([request respondsToSelector:@selector(HTTPMethod)])
	{
		if (std::find(_requests.begin(), _requests.end(), request) == _requests.end())
		{
			_requests.push_back(request);
			if (_requests.size() > 1024)
			{
				_requests.erase(_requests.begin(), _requests.begin() + 512);
			}

			Dl_info info = {0};
			dladdr(returnAddress, &info);

			NSString *str = [NSString stringWithFormat:@"FROM %s(%p)-%s(%p=>%#08lx)\n<%@>\n%@: %@\n%@\n\n", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, [NSThread callStackSymbols], request.HTTPMethod, request.URL.absoluteString, request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @""];
			NSLog(@"HTTPEEK REQUEST: %@", str);

			NSString *file = [NSString stringWithFormat:@"%@/%03d=%@.txt", _logDir, s_index++, NSUrlPath([request.URL.host stringByAppendingString:request.URL.path])];
			if (request.HTTPBody.length && request.HTTPBody.length < 10240)
			{
				NSString *str2 = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
				if (str2)
				{
					[[str stringByAppendingString:str2] writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:nil];
					return;
				}
			}

			[str writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:nil];
			[request.HTTPBody writeToFile:[file stringByAppendingString:@".dat"] atomically:NO];
		}
	}
}

//
void SSLPeekInit(NSString *processName);
void WebViewPeekInit(NSString *processName);
void ConnectionPeekInit(NSString *processName);
void ReadStreamPeekInit(NSString *processName);
void ApplicationPeekInit(NSString *processName);
void NotificationPeekInit(NSString *processName);

MSGHOOK(id, AASigningSession_initWithCertURL_sessionURL, id cert, id session)
{
	_LogStack();
	id ret = _AASigningSession_initWithCertURL_sessionURL(self, sel, cert, session);
	_Log(@"AASigningSession_initWithCertURL_sessionURL:%@,%@,ret=%@", cert, session, ret);

	return ret;
} ENDHOOK

MSGHOOK(id, AASigningSession_signatureForData, id data)
{
	_LogStack();
	id ret = _AASigningSession_signatureForData(self, sel, data);
	_Log(@"AASigningSession_signatureForData:%@\n\nret=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [ret base64EncodedStringWithOptions:0]);

	//[data writeToFile:@"/tmp/data.dat" atomically:YES];
	//[ret writeToFile:@"/tmp/sign.dat" atomically:YES];


	return ret;
} ENDHOOK

//
FUNHOOK(OSStatus, SecItemCopyMatching, CFDictionaryRef query, CFTypeRef *result)
{
	_LogLine();
	NSDictionary *dict = (__bridge NSDictionary *)query;
	_LogObj(dict);
	_LogObj(dict[@"svce"]);
	CFStringRef svce = (CFStringRef)CFDictionaryGetValue(query, kSecAttrService);
	if (CFStringCompare(svce, CFSTR("AppleIDClientIdentifier"), 0) == 0)
	{
		_LogLine();
		static BOOL _deleted;
		if (!_deleted)
		{
			SecItemDelete(query);
			_deleted = YES;
		}
		_LogLine();
	}
	//_LogLine();
	OSStatus ret = _SecItemCopyMatching(query, result);
	//_LogLine();
	//_Log(@"SecItemCopyMatching:%@->%d", query, (int)ret);
	//_LogLine();
	return ret;

} ENDHOOK


FUNHOOK(void, AALog, NSString *str, int level)
{
	//_AALog(str, level);
} ENDHOOK


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

//
MSGHOOK(void, AboutController_viewDidLoad)
{
	_Log(@"AboutController_viewDidLoad: %@", self);
	_AboutController_viewDidLoad(self, sel);
	[self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"锁定" style:UIBarButtonItemStylePlain target:self action:@selector(testCloudLock)];
} ENDHOOK

@implementation UIViewController (testCloudLock)
- (void)testCloudLock
{

	CFTypeRef result = NULL;
	NSDictionary *dict = @{
						   (__bridge id)kSecAttrService:@"AppleIDClientIdentifier",
						   (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
						   (__bridge id)kSecReturnData:(__bridge id)kCFBooleanTrue
						   };
	SecItemCopyMatching((__bridge CFDictionaryRef)dict, &result);
	NSLog(@"AppleIDClientIdentifier: %@", [[NSString alloc] initWithData:(__bridge id)result encoding:NSUTF8StringEncoding]);

	SecItemDelete((__bridge CFDictionaryRef)dict);
	SecItemCopyMatching((__bridge CFDictionaryRef)dict, &result);
	NSLog(@"AppleIDClientIdentifier after removed: %@", result? [[NSString alloc] initWithData:(__bridge id)result encoding:NSUTF8StringEncoding] : @"");

	return;

	UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
		[self testCloudLockThread3];
		dispatch_async(dispatch_get_main_queue(), ^{UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;});
	});
}

- (NSString *)fimpStamp
{
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	formater.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	formater.dateFormat = @"yyyy-MM-dd";
	NSDate *date = NSDate.date;
	NSString *day = [formater stringFromDate:date];
	formater.dateFormat = @"hh:mm:ss:SSS";
	NSString *time = [formater stringFromDate:date];
	return [NSString stringWithFormat:@"%@T%@Z", day,time];
}


- (void)testCloudLockThread
{
	NSDictionary *settingDict;
	{
		NSHTTPURLResponse* response = nil;
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://setup.icloud.com/configurations/init?context=settings"]];
		[request setValue:@"CN" forHTTPHeaderField:@"X-MMe-Country"];
		[request setValue:@"<iPhone5,3> <iPhone OS;8.1.2;12B440> <com.apple.AppleAccount/1.0 (com.apple.Preferences/1.0)>" forHTTPHeaderField:@"X-MMe-Client-Info"];
		//[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];

		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		settingDict = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
	}

	NSData *post;
	{
		NSDictionary *dict =@
		{
			@"protocolVersion":@"1.0",
			@"userInfo":@
			{
				@"client-id":@"E0C5DAEE-8E4A-4D10-9F53-BCBA00986E30",
				@"language":@"zh-Hans",
				@"timezone":@"Asia/Shanghai",
			}
		};
		post = [NSPropertyListSerialization dataWithPropertyList:dict format:kCFPropertyListXMLFormat_v1_0 options:0 error:nil];
	}

	NSString *qualify;
	{
		NSString *certUrl = settingDict[@"urls"][@"qualifyCert"];
		NSString *sessionUrl = settingDict[@"urls"][@"qualifySession"];
		AASigningSession *session = [[NSClassFromString(@"AASigningSession") alloc] initWithCertURL:certUrl sessionURL:sessionUrl];
		[session establishSession];
		NSData *signature = [session signatureForData:post];
		qualify = [signature base64EncodedStringWithOptions:0];
	}

	NSString *fimpToken;
	{
		NSHTTPURLResponse* response = nil;
		NSString *url = settingDict[@"urls"][@"loginOrCreateAccount"];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
		[request setValue:@"CN" forHTTPHeaderField:@"X-MMe-Country"];
		[request setValue:@"<iPhone5,3> <iPhone OS;8.1.2;12B440> <com.apple.AppleAccount/1.0 (com.apple.Preferences/1.0)>" forHTTPHeaderField:@"X-MMe-Client-Info"];
		[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];
		[request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
		[request setValue:@"Basic Z2N5QGh6LmNuOmFzZGZxd2Vy" forHTTPHeaderField:@"Authorization"];
		[request setValue:qualify forHTTPHeaderField:@"X-Mme-Nas-Qualify"];

		request.HTTPMethod = @"POST";
		request.HTTPBody = post;

		_LogLine();
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		NSDictionary *ret = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
		_LogObj(ret);
		fimpToken = ret[@"tokens"][@"mmeFMIPToken"];
		if (fimpToken.length == 0) return;
	}

	{

		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@
									 {
										 @"deviceContext": [NSMutableDictionary dictionaryWithDictionary:@{
																										   @"deviceTS": self.fimpStamp,
																										   @"cause": @"locationServiceAuthorizationChanged"}],
										 @"deviceInfo": @{
														  @"timezone": @"Asia/Shanghai",
														  @"findMyiPhone": @YES,
														  @"passcodeIsSet": @NO,
														  @"buildVersion": @"12B440",
														  @"mid": @"GY26Lgr7D+mg1LEHi4noovi71qaI+ogbVekoX3UrSSNEv/A7l9Lr1UAebW76nGb+9nN22B7Epwkoqwer",
														  @"isInternal": @NO,
														  @"udid": @"ffc87dc996ef524b908a394a43458ba6a6145779",
														  @"batteryStatus": @"Charging",
														  @"batteryLevel": @1,
														  @"aps-token": @"537caa6097e2dd8e6332928e9e24d4ff2d02a7c1a91f415f4a367f7175b66c72",
														  @"lowBatteryLocate": @NO,
														  @"locale": @"zh_CN",
														  @"productVersion": @"8.1.2",
														  @"serialNumber": @"F78M91PAFFHH",
														  @"locationServicesEnabled": @YES,
														  @"deviceColor": @"#3b3b3c",
														  @"smlLS": @YES,
														  @"trackingStatus": @400,
														  @"activationLock": @YES,
														  @"deviceName": @"tPhone",
														  @"passcodeConstraint": @"simple",
														  @"isChargerConnected": @YES,
														  @"productType": @"iPhone5,3",
														  @"appleId": @"gcy@hz.cn",
														  @"hasCellularCapability": @YES,
														  @"platform": @"iphoneos",
														  @"deviceClass": @"iPhone",
														  @"fmipLS": @YES,
														  @"fmipEnableReason": @3,
														  @"enclosureColor": @"#f5f4f7",
														  @"lostModeEnabled": @NO
														  }
									 }];

		NSHTTPURLResponse* response = nil;
		NSString *url = @"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/register";
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		NSString *auth = [NSString stringWithFormat:@"%@:%@", @"1373286703", fimpToken];
		[request setValue:[NSString stringWithFormat:@"Basic %@", [[auth dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
		[request setValue:@"FMDClient/6.0 iPhone5,3/12B440" forHTTPHeaderField:@"User-Agent"];
		[request setValue:@"1373286703" forHTTPHeaderField:@"X-Apple-PrsId"];
		[request setValue:@"6.0" forHTTPHeaderField:@"X-Apple-Find-API-Ver"];
		[request setValue:@"1.0" forHTTPHeaderField:@"X-Apple-Realm-Support"];

		request.HTTPMethod = @"POST";
		request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

		_LogLine();
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		{
			request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/qc"];
			dict[@"deviceContext"][@"deviceTS"] = self.fimpStamp;
			[dict[@"deviceContext"] removeObjectForKey:@"cause"];
			request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

			_LogLine();
			NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

			NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			if (ret == nil) return;
			_LogObj(ret);

			{
				dict[@"statusCode"] = @200;
				dict[@"cmdContext"] = ret;

				request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/ackIdentity"];
				request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
				
				_LogLine();
				NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
				if (response.statusCode != 200) return;
				
				NSDictionary *ret = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
				_LogObj(ret);
				
			}
		}
	}
}

- (void)testCloudLockThread2
{
	NSDictionary *settingDict;
	{
		NSHTTPURLResponse* response = nil;
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://setup.icloud.com/configurations/init?context=settings"]];
		[request setValue:@"CN" forHTTPHeaderField:@"X-MMe-Country"];
		[request setValue:@"<iPhone5,3> <iPhone OS;8.1.2;12B440> <com.apple.AppleAccount/1.0 (com.apple.Preferences/1.0)>" forHTTPHeaderField:@"X-MMe-Client-Info"];
		//[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];

		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		settingDict = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
	}

	NSData *post;
	{
		NSDictionary *dict =@
		{
			@"protocolVersion":@"1.0",
			@"userInfo":@
			{
				@"client-id":@"E0C5DAEE-8E4A-4D10-9F53-BCBA00986E30",
				@"language":@"zh-Hans",
				@"timezone":@"Asia/Shanghai",
			}
		};
		post = [NSPropertyListSerialization dataWithPropertyList:dict format:kCFPropertyListXMLFormat_v1_0 options:0 error:nil];
	}

	NSString *qualify;
	NSString *certUrl = settingDict[@"urls"][@"qualifyCert"];
	NSString *sessionUrl = settingDict[@"urls"][@"qualifySession"];
	AASigningSession *session = [[NSClassFromString(@"AASigningSession") alloc] initWithCertURL:certUrl sessionURL:sessionUrl];
	[session establishSession];
	{
		NSData *signature = [session signatureForData:post];
		qualify = [signature base64EncodedStringWithOptions:0];
	}

	NSString *fimpToken;
	{
		NSHTTPURLResponse* response = nil;
		NSString *url = settingDict[@"urls"][@"getAccountSettings"];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
		[request setValue:@"CN" forHTTPHeaderField:@"X-MMe-Country"];
		[request setValue:@"<iPhone5,3> <iPhone OS;8.1.2;12B440> <com.apple.AppleAccount/1.0 (com.apple.Preferences/1.0)>" forHTTPHeaderField:@"X-MMe-Client-Info"];
		[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];
		[request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
		[request setValue:@"Basic MTM3MzI4NjcwMzpBUUFBQUFCVTJNWkpxZmFHMGJ0Y2FLUFpXSFVXSVdyWFc5Z0RqZFU9" forHTTPHeaderField:@"Authorization"];
		[request setValue:qualify forHTTPHeaderField:@"X-Mme-Nas-Qualify"];
		[request setValue:@"001740-05-66020caf-575e-42d8-bacc-5484d46c8a8b" forHTTPHeaderField:@"X-Apple-ADSID"];

		request.HTTPMethod = @"POST";
		request.HTTPBody = post;

		_LogLine();
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		NSDictionary *ret = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
		_LogObj(ret);
		fimpToken = ret[@"tokens"][@"mmeFMIPToken"];
		if (fimpToken.length == 0) return;
	}

	{

		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@
									 {
										 @"deviceContext": [NSMutableDictionary dictionaryWithDictionary:@{
																										   @"deviceTS": self.fimpStamp,
																										   @"cause": @"AccountChange"}],
										 @"deviceInfo": @{
														  @"timezone": @"Asia/Shanghai",
														  @"findMyiPhone": @YES,
														  @"passcodeIsSet": @NO,
														  @"buildVersion": @"12B440",
														  @"mid": @"GY26Lgr7D+mg1LEHi4noovi71qaI+ogbVekoX3UrSSNEv/A7l9Lr1UAebW76nGb+9nN22B7Epwkoqwer",
														  @"isInternal": @NO,
														  @"udid": @"ffc87dc996ef524b908a394a43458ba6a6145779",
														  @"batteryStatus": @"Charging",
														  @"batteryLevel": @1,
														  @"aps-token": @"537caa6097e2dd8e6332928e9e24d4ff2d02a7c1a91f415f4a367f7175b66c72",
														  @"lowBatteryLocate": @NO,
														  @"locale": @"zh_CN",
														  @"productVersion": @"8.1.2",
														  @"serialNumber": @"F78M91PAFFHH",
														  @"locationServicesEnabled": @YES,
														  @"deviceColor": @"#3b3b3c",
														  @"smlLS": @YES,
														  @"trackingStatus": @400,
														  @"activationLock": @YES,
														  @"deviceName": @"tPhone",
														  @"passcodeConstraint": @"simple",
														  @"isChargerConnected": @YES,
														  @"productType": @"iPhone5,3",
														  @"appleId": @"gcy@hz.cn",
														  @"hasCellularCapability": @YES,
														  @"platform": @"iphoneos",
														  @"deviceClass": @"iPhone",
														  @"fmipLS": @YES,
														  @"fmipEnableReason": @3,
														  @"enclosureColor": @"#f5f4f7",
														  @"lostModeEnabled": @NO
														  }
									 }];

		NSHTTPURLResponse* response = nil;
		NSString *url = @"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/register";
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		NSString *auth = [NSString stringWithFormat:@"%@:%@", @"1373286703", fimpToken];
		[request setValue:[NSString stringWithFormat:@"Basic %@", [[auth dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
		[request setValue:@"FMDClient/6.0 iPhone5,3/12B440" forHTTPHeaderField:@"User-Agent"];
		[request setValue:@"1373286703" forHTTPHeaderField:@"X-Apple-PrsId"];
		[request setValue:@"6.0" forHTTPHeaderField:@"X-Apple-Find-API-Ver"];
		[request setValue:@"1.0" forHTTPHeaderField:@"X-Apple-Realm-Support"];

		request.HTTPMethod = @"POST";
		request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

		_LogLine();
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		{
			request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/qc"];
			dict[@"deviceContext"][@"deviceTS"] = self.fimpStamp;
			[dict[@"deviceContext"] removeObjectForKey:@"cause"];
			request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

			_LogLine();
			NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

			NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			if (ret == nil) return;
			_LogObj(ret);

			{
				dict[@"statusCode"] = @200;
				dict[@"cmdContext"] = ret;

				request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/ackIdentity"];
				request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

				_LogLine();
				[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
				if (response.statusCode != 200) return;

				{
					NSDictionary *dict = @
					{
						@"deviceContext": @{
											@"deviceTS": self.fimpStamp
											},
						@"serialNumber": @"F78M91PAFFHH",
						@"meid": @"35853905872735",
						@"imei": @"358539058727350",
						@"deviceInfo": @{
										 @"udid": @"ffc87dc996ef524b908a394a43458ba6a6145779"
										 }
					};


					NSData *post = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
					request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/identity"];
					request.HTTPBody = post;
					NSData *signature = [session signatureForData:post];
					NSString *qualify = [signature base64EncodedStringWithOptions:0];
					[request setValue:qualify forHTTPHeaderField:@"X-Mme-Nas-Qualify"];
					
					_LogLine();
					[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
					if (response.statusCode != 200) return;
				}
				
			}
		}
	}
}

- (void)testCloudLockThread3
{
	NSDictionary *settingDict;
	{
		NSHTTPURLResponse* response = nil;
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://setup.icloud.com/configurations/init?context=settings"]];
		[request setValue:@"CN" forHTTPHeaderField:@"X-MMe-Country"];
		[request setValue:@"<iPhone5,3> <iPhone OS;8.1.2;12B440> <com.apple.AppleAccount/1.0 (com.apple.Preferences/1.0)>" forHTTPHeaderField:@"X-MMe-Client-Info"];
		//[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];

		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		settingDict = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
	}

	NSData *post;
	{
		NSDictionary *dict =@
		{
			@"protocolVersion":@"1.0",
			@"userInfo":@
			{
				@"client-id":@"E0C5DAEE-8E4A-4D10-9F53-BCBA00986E30",
				@"language":@"zh-Hans",
				@"timezone":@"Asia/Shanghai",
			}
		};
		post = [NSPropertyListSerialization dataWithPropertyList:dict format:kCFPropertyListXMLFormat_v1_0 options:0 error:nil];
	}

	NSString *qualify;
	NSString *certUrl = settingDict[@"urls"][@"qualifyCert"];
	NSString *sessionUrl = settingDict[@"urls"][@"qualifySession"];
	AASigningSession *session = [[NSClassFromString(@"AASigningSession") alloc] initWithCertURL:certUrl sessionURL:sessionUrl];
	[session establishSession];
	{
		NSData *signature = [session signatureForData:post];
		qualify = [signature base64EncodedStringWithOptions:0];
	}

	NSString *fimpToken;
	{
		NSHTTPURLResponse* response = nil;
		NSString *url = settingDict[@"urls"][@"getAccountSettings"];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
		[request setValue:@"CN" forHTTPHeaderField:@"X-MMe-Country"];
		[request setValue:@"<iPhone5,3> <iPhone OS;8.1.2;12B440> <com.apple.AppleAccount/1.0 (com.apple.Preferences/1.0)>" forHTTPHeaderField:@"X-MMe-Client-Info"];
		[request setValue:@"%E8%AE%BE%E7%BD%AE/1.0 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];
		[request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
		[request setValue:@"Basic MTM3MzI4NjcwMzpBUUFBQUFCVTJNWkpxZmFHMGJ0Y2FLUFpXSFVXSVdyWFc5Z0RqZFU9" forHTTPHeaderField:@"Authorization"];
		[request setValue:qualify forHTTPHeaderField:@"X-Mme-Nas-Qualify"];
		[request setValue:@"001740-05-66020caf-575e-42d8-bacc-5484d46c8a8b" forHTTPHeaderField:@"X-Apple-ADSID"];

		request.HTTPMethod = @"POST";
		request.HTTPBody = post;

		_LogLine();
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		if (response.statusCode != 200) return;

		NSDictionary *ret = [NSPropertyListSerialization propertyListWithData:data options:0 format:nil error:nil];
		_LogObj(ret);
		fimpToken = ret[@"tokens"][@"mmeFMIPToken"];
		if (fimpToken.length == 0) return;
	}

	{

		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@
		{
			@"deviceContext": [NSMutableDictionary dictionaryWithDictionary:@{
				@"deviceTS": self.fimpStamp,
				@"cause": @"AccountChange"}],
			@"deviceInfo": @{
				@"timezone": @"Asia/Shanghai",
				@"findMyiPhone": @YES,
				@"passcodeIsSet": @NO,
				@"buildVersion": @"12B440",
				@"mid": @"GY26Lgr7D+mg1LEHi4noovi71qaI+ogbVekoX3UrSSNEv/A7l9Lr1UAebW76nGb+9nN22B7Epwkoqwer",
				@"isInternal": @NO,
				@"udid": @"ffc87dc996ef524b908a394a43458ba6a6145779",
				@"batteryStatus": @"Charging",
				@"batteryLevel": @1,
				@"aps-token": @"537caa6097e2dd8e6332928e9e24d4ff2d02a7c1a91f415f4a367f7175b66c72",
				@"lowBatteryLocate": @NO,
				@"locale": @"zh_CN",
				@"productVersion": @"8.1.2",
				@"serialNumber": @"F78M91PAFFHH",
				@"locationServicesEnabled": @YES,
				@"deviceColor": @"#3b3b3c",
				@"smlLS": @YES,
				@"trackingStatus": @400,
				@"activationLock": @YES,
				@"deviceName": @"tPhone",
				@"passcodeConstraint": @"simple",
				@"isChargerConnected": @YES,
				@"productType": @"iPhone5,3",
				@"appleId": @"gcy@hz.cn",
				@"hasCellularCapability": @YES,
				@"platform": @"iphoneos",
				@"deviceClass": @"iPhone",
				@"fmipLS": @YES,
				@"fmipEnableReason": @3,
				@"enclosureColor": @"#f5f4f7",
				@"lostModeEnabled": @NO
			}
		}];

		NSHTTPURLResponse* response = nil;
		NSString *url = @"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/register";
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
		[request setValue:@"keep-alive" forHTTPHeaderField:@"Proxy-Connection"];
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		NSString *auth = [NSString stringWithFormat:@"%@:%@", @"1373286703", fimpToken];
		[request setValue:[NSString stringWithFormat:@"Basic %@", [[auth dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
		[request setValue:@"FMDClient/6.0 iPhone5,3/12B440" forHTTPHeaderField:@"User-Agent"];
		[request setValue:@"1373286703" forHTTPHeaderField:@"X-Apple-PrsId"];
		[request setValue:@"6.0" forHTTPHeaderField:@"X-Apple-Find-API-Ver"];
		[request setValue:@"1.0" forHTTPHeaderField:@"X-Apple-Realm-Support"];

		request.HTTPMethod = @"POST";
		request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

		_LogLine();
//		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//		if (response.statusCode != 200) return;

		{
			request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/qc"];
			dict[@"deviceContext"][@"deviceTS"] = self.fimpStamp;
			[dict[@"deviceContext"] removeObjectForKey:@"cause"];
			request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

			_LogLine();
//			NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//
//			NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//			if (ret == nil) return;
//			_LogObj(ret);

			{
//				dict[@"statusCode"] = @200;
//				dict[@"cmdContext"] = ret;

				request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/ackIdentity"];
				request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

				_LogLine();
//				[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//				if (response.statusCode != 200) return;

				{
					NSDictionary *dict = @
					{
						@"deviceContext": @{
							@"deviceTS": self.fimpStamp
						},
						@"serialNumber": @"F78M91PAFFHH",
						@"meid": @"35853905872735",
						@"imei": @"358539058727350",
						@"deviceInfo": @{
							@"udid": @"ffc87dc996ef524b908a394a43458ba6a6145779"
						}
					};


					NSData *post = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
					request.URL = [NSURL URLWithString:@"https://p01-fmip.icloud.com/fmipservice/findme/1373286703/ffc87dc996ef524b908a394a43458ba6a6145779/identity"];
					request.HTTPBody = post;
					NSData *signature = [session signatureForData:post];
					NSString *qualify = [signature base64EncodedStringWithOptions:0];
					[request setValue:qualify forHTTPHeaderField:@"X-Mme-Nas-Qualify"];

					_LogLine();
					[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
					if (response.statusCode != 200) return;
				}
				
			}
		}
	}
}
@end


//
extern "C" int main()
{
	@autoreleasepool
	{
		NSString *processName = NSProcessInfo.processInfo.processName;
		_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookFunction);
		_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookMessageEx);

		if (![processName isEqualToString:@"Preferences"]) return 0;

		NSLog(@"HTTPEEK new process %@ MSHookFunction=%p, MSHookMessageEx=%p", processName, _MSHookFunction, _MSHookMessageEx);

		//SSLPeekInit(processName);
		//WebViewPeekInit(processName);
		//ConnectionPeekInit(processName);
		//ReadStreamPeekInit(processName);
		//ApplicationPeekInit(processName);
		NotificationPeekInit(processName);

		//_HOOKFUN(/System/Library/PrivateFrameworks/AppleAccount.framework/AppleAccount, AALog);

		//_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SecItemCopyMatching);
		//_HOOKMSG(AASigningSession_signatureForData, AASigningSession, signatureForData:);

		//_HOOKMSG(AASigningSession_initWithCertURL_sessionURL, AASigningSession, initWithCertURL:sessionURL:);

		//_HOOKMSG(AboutController_viewDidLoad, AboutController, viewDidLoad);

		return 0;
	}
}
