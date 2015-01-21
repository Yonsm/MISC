
#import "MDServiceResponse.h"
#import "HTTPServer.h"
#import "FakeCode.h"

//
struct MDObject {NSString *md; NSString *mdm; void *nouse; void *callback;};
typedef int (*PMDGenerate)(NSNumber *dsid, MDObject *mdo);

//
void MDCallBack(MDObject *mdo, NSString *md, NSString *mdm)
{
	mdo->md = md;
	mdo->mdm = mdm;
	//NSLog(@"No Crash Check CallBack.");
	//NSLog(@"MD:<%@> MDM:<%@>.", md, mdm);
}


//
NS_INLINE NSString *MDGenerate(unsigned long long dsid)
{
	if (dsid == 0)
	{
		return @"Welcome to <a href='https://github.com/Yonsm/MDService'>MDService</a>!<br><br>Usage: <a href='/529730368'>/529730368</a>";
	}
	
	static PMDGenerate _MDGenerate = nil;
	if (_MDGenerate == nil)
	{
		uint8_t *base = ModuleBase(@"/System/Library/PrivateFrameworks/iTunesStore.framework/Support/itunesstored", @"_mh_execute_header", (UIDevice.currentDevice.systemVersion.floatValue < 8.0) ? 0x1000 : 0x4000);
		//_MDGenerate = (PMDGenerate)(base + offset + 1);
		
		const char magic[] = "\x00\xF0\x02\xF8\x06\xB0\x80\xBD\xF0\xB5\x03\xAF\x4D\xF8\x04\x8D\x86\xB0\x88\x46";

		_LogLine();
		@try
		{
			_LogLine();
			for (uint8_t *p = base + 0xC0000; p < base + 0x100000; p += 2)
			{
				if (memcmp(p, magic, sizeof(magic) - 1) == 0)
				{
					p += 8;
					NSLog(@"_MDGenerate: %#08X", p - base);
					_MDGenerate = (PMDGenerate)(p + 1);
					break;
				}
			}
			_LogLine();
		}
		@finally
		{
		}
	
		_LogLine();
		if (_MDGenerate == nil)
		{
			return @"Could not lookup function address. <br><br>Tested on 32-bit iPhone 7.0.4/7.1.1/8.1.1 only!";
		}
	}
	
	MDObject _mdo =
	{
		nil,
		nil,
		nil,
		(void *)MDCallBack,
	};
	
	_MDGenerate([NSNumber numberWithUnsignedLongLong:dsid], &_mdo);
	
	return [NSString stringWithFormat:@"%@|%@", _mdo.md, _mdo.mdm];
}


@implementation MDServiceResponse

//
// load
//
// Implementing the load method and invoking
// [HTTPResponseHandler registerHandler:self] causes HTTPResponseHandler
// to register this class in the list of registered HTTP response handlers.
//
+ (void)load
{
	[HTTPResponseHandler registerHandler:self];
}

//
// canHandleRequest:method:url:headerFields:
//
// Class method to determine if the response handler class can handle
// a given request.
//
// Parameters:
//    aRequest - the request
//    requestMethod - the request method
//    requestURL - the request URL
//    requestHeaderFields - the request headers
//
// returns YES (if the handler can handle the request), NO (otherwise)
//
+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
				  method:(NSString *)requestMethod
					 url:(NSURL *)requestURL
			headerFields:(NSDictionary *)requestHeaderFields
{
	return YES;
//	if (requestURL.path.length > 1)
//	{
//		NSString *string = [requestURL.path substringFromIndex:1];
//		NSScanner* scan = [NSScanner scannerWithString:string];
//		int val;
//		return [scan scanInt:&val] && [scan isAtEnd];
//	}
//	
//	return NO;
}

//
// startResponse
//
// Since this is a simple response, we handle it synchronously by sending
// everything at once.
//
- (void)startResponse
{
	NSLog(@"MDService: %@", url);

	unsigned long long dsid = 0;
	if (url.path.length > 1)
	{
		NSString *string = [url.path substringFromIndex:1];
		NSArray *strings = [string componentsSeparatedByString:@"@"];
		NSLog(@"strings=%@", strings);

		NSScanner* scan = [NSScanner scannerWithString:strings[0]];
		int val;
		if ([scan scanInt:&val] && [scan isAtEnd])
		{
			dsid = [[url.path substringFromIndex:1] longLongValue];
		}

		_enableHook = (strings.count >= 2) ? strings[1] : nil;
	}
	
	NSString *content = MDGenerate(dsid);

	_enableHook = nil;

	NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
	
	CFHTTPMessageRef response =
	CFHTTPMessageCreateResponse(
								kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(
									 response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/html");
	CFHTTPMessageSetHeaderFieldValue(
									 response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	CFHTTPMessageSetHeaderFieldValue(
									 response,
									 (CFStringRef)@"Content-Length",
									 (CFStringRef)[NSString stringWithFormat:@"%d", (int)[data length]]);
	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
	
	@try
	{
		[fileHandle writeData:(NSData *)headerData];
		[fileHandle writeData:data];
	}
	@catch (NSException *exception)
	{
		// Ignore the exception, it normally just means the client
		// closed the connection from the other end.
	}
	@finally
	{
		CFRelease(headerData);
		[server closeHandler:self];
	}
}

@end
