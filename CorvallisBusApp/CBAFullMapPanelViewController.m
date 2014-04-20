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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)routeTapped:(UITapGestureRecognizer*)sender
{
    self.scheduleViewController = [[CBAScheduleViewController alloc] initWithNibName:@"CBAScheduleViewController" bundle:nil];
    // TO BE TESTED ONCE THERE ARE BUS STOPS TO BE TESTED
    // self.scheduleViewController.view.transform = CGAffineTransformMakeScale(DEPTH_VIEW_SCALE, DEPTH_VIEW_SCALE);
    self.depthView = [CWDepthView new];
    [self.depthView presentView:self.scheduleViewController.view];
    [self.scheduleViewController scheduleForStop:self.stop name:self.routeName];
    [self.scheduleViewController.dismissButton addTarget:self action:@selector(dismissScheduleView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissScheduleView
{
    [self.depthView dismissDepthViewWithCompletion:nil];
}

@end
