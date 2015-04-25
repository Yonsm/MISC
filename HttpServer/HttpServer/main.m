//
//  main.m
//  HttpServer
//
//  Created by 郭春杨 on 15/4/25.
//  Copyright (c) 2015年 Yonsm.NET. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPServer.h"

extern unsigned short HTTP_SERVER_PORT;
int main(int argc, const char * argv[]) {
	@autoreleasepool {
	    // insert code here...
	    NSLog(@"Hello, World!");
		HTTP_SERVER_PORT = 8080;
		[[HTTPServer sharedHTTPServer] start];

		CFRunLoopRun();
	}
    return 0;
}
