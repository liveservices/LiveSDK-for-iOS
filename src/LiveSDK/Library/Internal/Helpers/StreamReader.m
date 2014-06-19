//
//  StreamReader.m
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
            len = (unsigned int)[_stream read:buf maxLength:BUFFERSIZE];
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
