//
//  LiveConstants.h
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

extern NSInteger const LIVE_ERROR_CODE_LOGIN_FAILED;
extern NSInteger const LIVE_ERROR_CODE_LOGIN_CANCELED;
extern NSInteger const LIVE_ERROR_CODE_RETRIEVE_TOKEN_FAILED;
extern NSInteger const LIVE_ERROR_CODE_API_CANCELED;
extern NSInteger const LIVE_ERROR_CODE_API_FAILED;

extern NSString * const LIVE_ERROR_CODE_S_ACCESS_DENIED;
extern NSString * const LIVE_ERROR_CODE_S_INVALID_GRANT;
extern NSString * const LIVE_ERROR_CODE_S_REQUEST_CANCELED;
extern NSString * const LIVE_ERROR_CODE_S_REQUEST_FAILED;
extern NSString * const LIVE_ERROR_CODE_S_RESPONSE_PARSING_FAILED;

extern NSString * const LIVE_ERROR_DESC_API_CANCELED;
extern NSString * const LIVE_ERROR_DESC_AUTH_CANCELED;
extern NSString * const LIVE_ERROR_DESC_AUTH_FAILED;
extern NSString * const LIVE_ERROR_DESC_MISSING_PARAMETER;
extern NSString * const LIVE_ERROR_DESC_MUST_INIT;
extern NSString * const LIVE_ERROR_DESC_PENDING_LOGIN_EXIST;
extern NSString * const LIVE_ERROR_DESC_REQUIRE_RELATIVE_PATH;
extern NSString * const LIVE_ERROR_DESC_UPLOAD_FAIL_QUERY;

extern NSString * const LIVE_ERROR_DOMAIN;
extern NSString * const LIVE_ERROR_KEY_ERROR;
extern NSString * const LIVE_ERROR_KEY_DESCRIPTION;
extern NSString * const LIVE_ERROR_KEY_CODE;
extern NSString * const LIVE_ERROR_KEY_MESSAGE;
extern NSString * const LIVE_ERROR_KEY_INNER_ERROR;

extern NSString * const LIVE_EXCEPTION;

extern NSString * const LIVE_SDK_VERSION;
