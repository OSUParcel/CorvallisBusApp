//
//  CBAStopTableViewCell.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#define ANIMATION_TIME 0.5f
#define DEFAULT_ZOOM_LEVEL 15.0f
#define DEFAULT_VIEWING_ANGLE 90.0f
#define ZOOM_AMOUNT 3.0f
#define FULL_SCREEN_VIEWING_ANGLE 45.0f

#import "CBAStopTableViewCell.h"
#import "AppDelegate.h"

@implementation CBAStopTableViewCell

@synthesize tapGestureRecognizer, fullScreenWindow, panelViewController;

@synthesize isFullScreen, defaultViewFrame, defaultMapViewFrame, rowIndex;

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
    [self.mapView animateToZoom:DEFAULT_ZOOM_LEVEL];
    [self.mapView animateToViewingAngle:DEFAULT_VIEWING_ANGLE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

# pragma mark - setup methods

- (void)setupFullScreenWindow
{
    self.fullScreenWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.fullScreenWindow.backgroundColor = [UIColor clearColor];
    self.fullScreenWindow.userInteractionEnabled = YES;
    self.fullScreenWindow.windowLevel = UIWindowLevelStatusBar;
    self.fullScreenWindow.rootViewController = [UIViewController new];
    [self.fullScreenWindow.rootViewController.view addSubview:self];
    [self.fullScreenWindow makeKeyAndVisible];
}

- (void)setupPanelViewController
{
    self.panelViewController = [[CBAFullMapPanelViewController alloc] initWithNibName:@"CBAFullMapPanelViewController" bundle:nil];
    self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height,
                                                     self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    [self.panelViewController.dismissButton addTarget:self action:@selector(animateFromFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenWindow.rootViewController.view addSubview:self.panelViewController.view];
}

# pragma mark - animation methods

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender
{
    if (!self.isFullScreen) {
        self.isFullScreen = YES;
        
        // save previous frames
        self.defaultViewFrame = self.frame;
        self.defaultMapViewFrame = self.mapView.frame;

        // set up window
        [self setupFullScreenWindow];
        
        // set up panel
        [self setupPanelViewController];
        
        // animate map to full screen
        GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomBy:ZOOM_AMOUNT];
        [self.superview.superview bringSubviewToFront:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:ANIMATION_TIME animations:^{
                self.fullScreenWindow.frame = [[UIScreen mainScreen] bounds];
                self.frame = [[UIScreen mainScreen] bounds];
                self.mapView.frame = [[UIScreen mainScreen] bounds];
            } completion:^(BOOL finished) {
                // zoom in
                [self.mapView animateWithCameraUpdate:zoomIn];
                [self.mapView animateToViewingAngle:FULL_SCREEN_VIEWING_ANGLE];
                
                // animate panel in
                [self animatePanelIn];
                
                // enable user interaction
                self.mapView.settings.scrollGestures = YES;
                self.mapView.settings.zoomGestures = YES;
            }];
        });
    }
}

- (void)animateFromFullScreen
{
    // disable user interaction
    self.mapView.settings.scrollGestures = NO;
    self.mapView.settings.zoomGestures = NO;
    
    // reset zoom and viewing angle
    [self.mapView animateToZoom:DEFAULT_ZOOM_LEVEL];
    [self.mapView animateToViewingAngle:DEFAULT_VIEWING_ANGLE];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.fullScreenWindow.frame = [[UIScreen mainScreen] applicationFrame];
            self.frame = self.defaultViewFrame;
            self.mapView.frame = self.defaultMapViewFrame;
            self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height,
                                                             self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            self.fullScreenWindow = nil;
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:self.rowIndex inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [delegate.mainViewController.stopsTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        }];
    });
}

- (void)animatePanelIn
{
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - self.panelViewController.view.frame.size.height,
                                                         self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    }];
}

- (void)animatePanelOut
{
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height,
                                                         self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    }];
}

@end