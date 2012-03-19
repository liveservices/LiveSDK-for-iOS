//
//  PSAppDelegate.h
//  PhotoSky
//
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSMainViewController;

@interface PSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PSMainViewController *viewController;

@end
