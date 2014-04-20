//
//  CBAAboutNavigationViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/20/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAAboutNavigationViewController.h"
#import "AppDelegate.h"

@implementation CBAAboutNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.navigationBar.tintColor = delegate.window.tintColor;
    self.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNavigationBarHidden:NO animated:YES];
}

@end
