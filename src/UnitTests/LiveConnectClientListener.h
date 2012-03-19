//
//  LiveConnectClientListener.h
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveConnectClient.h"

static NSString * const LIVE_UNIT_EVENT = @"event";
static NSString * const LIVE_UNIT_AUTHCOMPLETED = @"auth_completed";
static NSString * const LIVE_UNIT_AUTHFAILED = @"auth_failed";
static NSString * const LIVE_UNIT_OPCOMPLETED = @"op_completed";
static NSString * const LIVE_UNIT_OPFAILED = @"op_failed";
static NSString * const LIVE_UNIT_OPPROGRESSED = @"op_progressed";
static NSString * const LIVE_UNIT_ERROR = @"error";
static NSString * const LIVE_UNIT_STATUS = @"status";
static NSString * const LIVE_UNIT_SESSION = @"session";
static NSString * const LIVE_UNIT_USERSTATE = @"userstate";
static NSString * const LIVE_UNIT_OPERATION = @"operation";

@interface LiveConnectClientListener : NSObject<LiveAuthDelegate, LiveOperationDelegate>

@property (nonatomic, retain) NSMutableArray *events;

- (NSDictionary *)fetchEvent;
@end
