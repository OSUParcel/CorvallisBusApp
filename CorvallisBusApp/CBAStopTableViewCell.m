//
//  CBAStopTableViewCell.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#define ANIMATION_TIME 0.5f

#import "CBAStopTableViewCell.h"

@implementation CBAStopTableViewCell

@synthesize tapGestureRecognizer, fullScreenWindow;

@synthesize isFullScreen;

- (void)awakeFromNib
{
    // dont clip
    self.clipsToBounds = NO;
    self.superview.clipsToBounds = NO;
    
    // init gesture recognizer
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateToFullScreen:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    // map view setup
    self.isFullScreen = NO;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.scrollGestures = NO;
    self.mapView.settings.zoomGestures = NO;
    [self.mapView animateToZoom:15.0f];
    [self.mapView animateToViewingAngle:25.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender
{
    if (!self.isFullScreen) {
        self.isFullScreen = YES;

        // set up window
        self.fullScreenWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.fullScreenWindow.backgroundColor = [UIColor clearColor];
        self.fullScreenWindow.userInteractionEnabled = YES;
        self.fullScreenWindow.windowLevel = UIWindowLevelStatusBar;
        self.fullScreenWindow.rootViewController = [UIViewController new];
        [self.fullScreenWindow.rootViewController.view addSubview:self];
        [self.fullScreenWindow makeKeyAndVisible];
        
        // animate map to full screen
        GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomBy:3.0f];
        [self.superview.superview bringSubviewToFront:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:ANIMATION_TIME animations:^{
                self.frame = [[UIScreen mainScreen] bounds];
                self.mapView.frame = [[UIScreen mainScreen] bounds];
            } completion:^(BOOL finished) {
                [self.mapView animateWithCameraUpdate:zoomIn];
                // enable user interaction
                self.mapView.settings.scrollGestures = YES;
                self.mapView.settings.zoomGestures = YES;
            }];
        });
    }
}

@end
