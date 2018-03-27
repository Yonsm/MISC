
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <CFNetwork/CFNetwork.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@class HTTPServer;

@interface HTTPResponseHandler : NSObject
{
	CFHTTPMessageRef request;
	NSString *requestMethod;
	NSDictionary *headerFields;
	NSFileHandle *fileHandle;
	HTTPServer *server;
	NSURL *url;
}

+ (NSUInteger)priority;
+ (void)registerHandler:(Class)handlerClass;

+ (HTTPResponseHandler *)handlerForRequest:(CFHTTPMessageRef)aRequest
	fileHandle:(NSFileHandle *)requestFileHandle
	server:(HTTPServer *)aServer;

- (id)initWithRequest:(CFHTTPMessageRef)aRequest
	method:(NSString *)method
	url:(NSURL *)requestURL
	headerFields:(NSDictionary *)requestHeaderFields
	fileHandle:(NSFileHandle *)requestFileHandle
	server:(HTTPServer *)aServer;
- (void)startResponse;
- (void)endResponse;

@end
