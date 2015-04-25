
#import "MDServiceResponse.h"
#import "HTTPServer.h"

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
	}
	
	NSString *content = @"Hello";

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
									 (__bridge CFStringRef)[NSString stringWithFormat:@"%d", (int)[data length]]);
	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
	
	@try
	{
		[fileHandle writeData:(__bridge NSData *)headerData];
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
