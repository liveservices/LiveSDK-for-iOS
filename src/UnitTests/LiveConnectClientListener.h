//
//  LiveConnectClientListener.h
//  Live SDK for iOS
//
//  Copyright 2014 Microsoft Corporation
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
