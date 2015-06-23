//
//  LiveInternalConstants.m
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

NSString * const LIVE_ENDPOINT_API_HOST = @"apis.live.net";
NSString * const LIVE_ENDPOINT_LOGIN_HOST = @"login.live.com";

NSTimeInterval const HTTP_REQUEST_TIMEOUT_INTERVAL = 30;

NSTimeInterval const LIVE_AUTH_EXPIRE_VALUE_ADJUSTMENT = 3;
NSTimeInterval const LIVE_AUTH_REFRESH_TIME_BEFORE_EXPIRE = 30;

NSString * const LIVE_API_HEADER_AUTHORIZATION = @"Authorization";
NSString * const LIVE_API_HEADER_CONTENTTYPE = @"Content-Type";
NSString * const LIVE_API_HEADER_METHOD = @"method";
NSString * const LIVE_API_HEADER_CONTENTTYPE_JSON = @"application/json;charset=UTF-8";
NSString * const LIVE_API_HEADER_X_HTTP_LIVE_LIBRARY = @"X-HTTP-Live-Library";
NSString * const LIVE_API_PARAM_OVERWRITE = @"overwrite";
NSString * const LIVE_API_PARAM_SUPPRESS_REDIRECTS = @"suppress_redirects";
NSString * const LIVE_API_PARAM_SUPPRESS_RESPONSE_CODES = @"suppress_response_codes";

NSString * const LIVE_AUTH_ACCESS_TOKEN = @"access_token";
NSString * const LIVE_AUTH_AUTHENTICATION_TOKEN = @"authentication_token";
NSString * const LIVE_AUTH_CODE = @"code";
NSString * const LIVE_AUTH_CLIENTID = @"client_id";
NSString * const LIVE_AUTH_DISPLAY = @"display";
NSString * const LIVE_AUTH_DISPLAY_IOS_PHONE = @"ios_phone";
NSString * const LIVE_AUTH_DISPLAY_IOS_TABLET = @"ios_tablet";
NSString * const LIVE_AUTH_GRANT_TYPE = @"grant_type";
NSString * const LIVE_AUTH_GRANT_TYPE_AUTHCODE = @"authorization_code";
NSString * const LIVE_AUTH_LOCALE = @"locale";
NSString * const LIVE_AUTH_REDIRECT_URI = @"redirect_uri";
NSString * const LIVE_AUTH_REFRESH_TOKEN = @"refresh_token";
NSString * const LIVE_AUTH_RESPONSE_TYPE = @"response_type";
NSString * const LIVE_AUTH_SCOPE = @"scope";
NSString * const LIVE_AUTH_THEME = @"theme";
NSString * const LIVE_AUTH_THEME_IOS = @"ios";
NSString * const LIVE_AUTH_TOKEN = @"token";

NSString * const LIVE_AUTH_POST_CONTENT_TYPE = @"application/x-www-form-urlencoded;charset=UTF-8";
NSString * const LIVE_AUTH_EXPIRES_IN = @"expires_in";
