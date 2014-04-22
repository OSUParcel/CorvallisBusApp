//
//  CBAFullMapPanelViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAFullMapPanelViewController.h"
#import "CBAScheduleViewController.h"
#import "AppDelegate.h"

@interface CBAFullMapPanelViewController ()

@end

@implementation CBAFullMapPanelViewController

@synthesize scheduleViewController, tapGestureRecognizer, depthView, stop, routeName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(routeTapped:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    self.routeLabel.userInteractionEnabled = YES;
    [self.routeLabel addGestureRecognizer:self.tapGestureRecognizer];
    self.view.clipsToBounds = NO;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowOpacity = 0.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)routeTapped:(UITapGestureRecognizer*)sender
{
    self.scheduleViewController = [[CBAScheduleViewController alloc] initWithNibName:@"CBAScheduleViewController" bundle:nil];
    CGFloat width = DEPTH_VIEW_SCALE * [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = DEPTH_VIEW_SCALE * [[UIScreen mainScreen] bounds].size.height;
    self.scheduleViewController.view.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - width)/2,
                                                ([[UIScreen mainScreen] bounds].size.height - height)/2,
                                                width, height);
    self.depthView = [CWDepthView new];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.depthView.windowForScreenshot = delegate.mapWindow;
    [self.depthView presentView:self.scheduleViewController.view];
    [self.scheduleViewController scheduleForStop:self.stop name:self.routeName];
    [self.scheduleViewController.dismissButton addTarget:self action:@selector(dismissScheduleView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissScheduleView
{
    [self.depthView dismissDepthViewWithCompletion:nil];
}

@end
