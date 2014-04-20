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

@synthesize scheduleViewController, tapGestureRecognizer, depthView;

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
    self.depthView = [CWDepthView new];
    [self.depthView presentView:self.scheduleViewController.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissScheduleView];
    });
}

- (void)dismissScheduleView
{
    [self.depthView dismissDepthViewWithCompletion:nil];
}

@end
