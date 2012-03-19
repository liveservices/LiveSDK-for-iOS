//
//  MockFactory.h
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveConnectionCreatorDelegate.h"
#import "MockUrlConnection.h"

@interface MockFactory : NSObject<LiveConnectionCreatorDelegate>

+ (id) factory;

@property (nonatomic, retain) NSMutableArray *connectionQueue;

- (MockUrlConnection *)fetchRequestConnection;

@end
