//
//  LiveSDKTests.h
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface MockUrlConnection : NSObject

+ (id) connection;

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) id delegate;
- (void)cancel;
@end
