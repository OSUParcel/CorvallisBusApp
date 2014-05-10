//
//  AppDelegate.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/17/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAMainViewController.h"
#import "CBAMapViewCacheManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CBAMapViewCacheManager *mapViewCacheManager;
@property (weak, nonatomic) UIWindow *mapWindow;
@property (weak, nonatomic) UIWindow *depthViewWindow;

@property (strong, nonatomic) CBAMainViewController *mainViewController;

@end
