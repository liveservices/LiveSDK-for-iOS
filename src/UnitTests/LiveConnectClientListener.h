//
//  LiveConnectClientListener.h
//  Live SDK for iOS
//
//  Copyright 2015 Microsoft Corporation
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
