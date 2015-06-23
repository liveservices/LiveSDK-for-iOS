//
//  LiveConstants.m
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

NSInteger const LIVE_ERROR_CODE_LOGIN_FAILED = 1;
NSInteger const LIVE_ERROR_CODE_LOGIN_CANCELED = 2;
NSInteger const LIVE_ERROR_CODE_RETRIEVE_TOKEN_FAILED = 3;
NSInteger const LIVE_ERROR_CODE_API_CANCELED = 4;
NSInteger const LIVE_ERROR_CODE_API_FAILED = 5;

NSString * const LIVE_ERROR_CODE_S_ACCESS_DENIED = @"access_denied";
NSString * const LIVE_ERROR_CODE_S_INVALID_GRANT = @"invalid_grant";
NSString * const LIVE_ERROR_CODE_S_REQUEST_CANCELED = @"request_canceled";
NSString * const LIVE_ERROR_CODE_S_REQUEST_FAILED = @"request_failed";
NSString * const LIVE_ERROR_CODE_S_RESPONSE_PARSING_FAILED = @"response_parse_failure";

NSString * const LIVE_ERROR_DESC_API_CANCELED = @"The request was canceled.";
NSString * const LIVE_ERROR_DESC_AUTH_CANCELED = @"The user has canceled the authorization request.";
NSString * const LIVE_ERROR_DESC_AUTH_FAILED = @"The authorization request failed to complete.";
NSString * const LIVE_ERROR_DESC_MISSING_PARAMETER = @"The parameter '%@' must be specified when calling '%@'.";
NSString * const LIVE_ERROR_DESC_MUST_INIT = @"The LiveConnectClient instance must be initialized before being used.";
NSString * const LIVE_ERROR_DESC_PENDING_LOGIN_EXIST = @"There is already a pending login request.";
NSString * const LIVE_ERROR_DESC_REQUIRE_RELATIVE_PATH = @"The 'path' parameter must be a relative path when calling '%@'.";
NSString * const LIVE_ERROR_DESC_UPLOAD_FAIL_QUERY = @"Failed to query upload location.";

NSString * const LIVE_ERROR_DOMAIN = @"LiveServicesErrorDomain";
NSString * const LIVE_ERROR_KEY_ERROR = @"error";
NSString * const LIVE_ERROR_KEY_DESCRIPTION = @"error_description";
NSString * const LIVE_ERROR_KEY_CODE = @"code";
NSString * const LIVE_ERROR_KEY_MESSAGE = @"message";
NSString * const LIVE_ERROR_KEY_INNER_ERROR = @"internal_error";

NSString * const LIVE_EXCEPTION = @"LiveException";

NSString * const LIVE_SDK_VERSION = @"5.6.2";
