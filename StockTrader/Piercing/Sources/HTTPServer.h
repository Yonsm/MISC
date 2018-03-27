
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

typedef enum
{
	SERVER_STATE_IDLE,
	SERVER_STATE_STARTING,
	SERVER_STATE_RUNNING,
	SERVER_STATE_STOPPING
} HTTPServerState;

@class HTTPResponseHandler;

@interface HTTPServer : NSObject
{
	NSFileHandle *listeningHandle;
	CFSocketRef socket;
	CFMutableDictionaryRef incomingRequests;
	NSMutableSet *responseHandlers;
}

@property (nonatomic, readonly, retain) NSError *lastError;
@property (readonly, assign) HTTPServerState state;

- (void)start:(unsigned short)port;
- (void)stop;

- (void)closeHandler:(HTTPResponseHandler *)aHandler;

@end

extern NSString * const HTTPServerNotificationStateChanged;
