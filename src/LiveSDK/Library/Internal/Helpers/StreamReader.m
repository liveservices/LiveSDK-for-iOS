//
//  StreamReader.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import "StreamReader.h"

const NSUInteger BUFFERSIZE = 4096;

@implementation StreamReader

@synthesize data, 
            delegate = _delegate,
            stream = _stream;

- (id)initWithStream:(NSInputStream *)stream
            delegate:(id<StreamReaderDelegate>)delegate
{
    self = [super init];
    if (self) 
    {
        _stream = [stream retain];
        _delegate = delegate;
    }
    
    return self;
}

- (void)dealloc
{
    [_stream release];
    [data release];
    
    [super dealloc];
}

- (void)start
{
    _stream.delegate = self;
    [_stream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    [_stream open];
}

- (void)cleanup
{
    [self.stream close];
    [self.stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    self.stream.delegate = nil;
    self.stream = nil;
    self.data = nil;
    self.delegate = nil;    
}

- (void)stream:(NSStream *)aStream 
   handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) 
    {
        case NSStreamEventHasBytesAvailable:
        {
            if(!data) 
            {
                self.data = [NSMutableData data];
            }
            
            uint8_t buf[BUFFERSIZE];
            unsigned int len = 0;
            len = [_stream read:buf maxLength:BUFFERSIZE];
            if(len) 
            {
                [data appendBytes:(const void *)buf length:len];
            } 
            else 
            {
                NSLog(@"no buffer!");
            }
            
            break;
        }
        case NSStreamEventEndEncountered:
        {
            [_delegate streamReadingCompleted:data];
            [self cleanup];
            
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            NSError *theError = [_stream streamError];            
            [_delegate streamReadingFailed:theError];
            [self cleanup];
            
            break;
        }          
        default:
        {
            break;
        }
    }
}

@end
