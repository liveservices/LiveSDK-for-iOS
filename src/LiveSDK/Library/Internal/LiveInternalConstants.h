//
//  LiveInternalConstants.h
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

extern NSString * const LIVE_ENDPOINT_API_HOST;
extern NSString * const LIVE_ENDPOINT_LOGIN_HOST;

extern NSTimeInterval const HTTP_REQUEST_TIMEOUT_INTERVAL;

extern NSTimeInterval const LIVE_AUTH_EXPIRE_VALUE_ADJUSTMENT;
extern NSTimeInterval const LIVE_AUTH_REFRESH_TIME_BEFORE_EXPIRE;

extern NSString * const LIVE_API_HEADER_AUTHORIZATION;
extern NSString * const LIVE_API_HEADER_CONTENTTYPE;
extern NSString * const LIVE_API_HEADER_METHOD;
extern NSString * const LIVE_API_HEADER_CONTENTTYPE_JSON;
extern NSString * const LIVE_API_HEADER_X_HTTP_LIVE_LIBRARY;
extern NSString * const LIVE_API_PARAM_OVERWRITE;
extern NSString * const LIVE_API_PARAM_SUPPRESS_REDIRECTS;
extern NSString * const LIVE_API_PARAM_SUPPRESS_RESPONSE_CODES;

extern NSString * const LIVE_AUTH_ACCESS_TOKEN;
extern NSString * const LIVE_AUTH_AUTHENTICATION_TOKEN;
extern NSString * const LIVE_AUTH_CODE;
extern NSString * const LIVE_AUTH_CLIENTID;
extern NSString * const LIVE_AUTH_DISPLAY;
extern NSString * const LIVE_AUTH_DISPLAY_IOS_PHONE;
extern NSString * const LIVE_AUTH_DISPLAY_IOS_TABLET;
extern NSString * const LIVE_AUTH_GRANT_TYPE;
extern NSString * const LIVE_AUTH_GRANT_TYPE_AUTHCODE;
extern NSString * const LIVE_AUTH_LOCALE;
extern NSString * const LIVE_AUTH_REDIRECT_URI;
extern NSString * const LIVE_AUTH_REFRESH_TOKEN;
extern NSString * const LIVE_AUTH_RESPONSE_TYPE;
extern NSString * const LIVE_AUTH_SCOPE;
extern NSString * const LIVE_AUTH_THEME;
extern NSString * const LIVE_AUTH_THEME_IOS;
extern NSString * const LIVE_AUTH_TOKEN;

extern NSString * const LIVE_AUTH_POST_CONTENT_TYPE;
extern NSString * const LIVE_AUTH_EXPIRES_IN;
