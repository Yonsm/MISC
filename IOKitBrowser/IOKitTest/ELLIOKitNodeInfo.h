//
//  ELLIOKitNodeInfo.h
//  IOKitTest
//
//  Created by Christopher Anderson on 28/12/2013.
//  Copyright (c) 2013 Electric Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOKitDefines.h"

@interface ELLIOKitNodeInfo : NSObject

@property(nonatomic, weak) ELLIOKitNodeInfo *parent;
@property(nonatomic, copy, readonly) NSMutableArray *children;


@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSArray *properties;
@property(nonatomic, assign) io_registry_entry_t service;


@property(nonatomic, assign) NSInteger searchCount;
@property(nonatomic, strong) NSArray *matchingProperties;
@property(nonatomic, strong) NSArray *matchedChildren;


- (id)initWithParent:(ELLIOKitNodeInfo *)parent service:(io_registry_entry_t)service nodeInfoWithInfo:(NSString *)info properties:(NSArray *)properties;

- (void)addChild:(ELLIOKitNodeInfo *)child;
- (void)replaceChild:(ELLIOKitNodeInfo *)child withChild:(ELLIOKitNodeInfo *)replacementChild;

- (void)searchForTerm:(NSString *)searchTerm;

@end
