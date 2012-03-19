//
//  LiveConnectionHelper.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveConnectionHelper.h"

static id<LiveConnectionCreatorDelegate> overrideCreator = nil;

@implementation LiveConnectionHelper

+ (void) setLiveConnectCreator:(id<LiveConnectionCreatorDelegate>)creator
{
    overrideCreator = [creator retain];
}

+ (id) createConnectionWithRequest:(NSURLRequest *)request
                          delegate:(id)delegate
{   
    if (overrideCreator) 
    {
        return [overrideCreator createConnectionWithRequest:request delegate:delegate];
    }
    else
    {
        return [NSURLConnection connectionWithRequest:request delegate:delegate];
    }
}
@end
