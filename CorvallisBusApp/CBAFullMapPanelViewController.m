//
//  CBAFullMapPanelViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAFullMapPanelViewController.h"
#import "AppDelegate.h"

@interface CBAFullMapPanelViewController ()

@end

@implementation CBAFullMapPanelViewController

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
    // Do any additional setup after loading the view from its nib.
    self.dismissButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dismissButton.layer.shadowRadius = 4.0f;
    self.dismissButton.layer.shadowOpacity = 0.75f;
    self.dismissButton.layer.masksToBounds = NO;
    self.arrivalTimeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.arrivalTimeLabel.layer.shadowRadius = 4.0f;
    self.arrivalTimeLabel.layer.shadowOpacity = 0.75f;
    self.arrivalTimeLabel.layer.masksToBounds = NO;
    self.routeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.routeLabel.layer.shadowRadius = 4.0f;
    self.routeLabel.layer.shadowOpacity = 0.75f;
    self.routeLabel.layer.masksToBounds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
