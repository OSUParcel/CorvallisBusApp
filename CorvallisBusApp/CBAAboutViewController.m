//
//  CBAAboutViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/20/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAAboutViewController.h"
#import "CBALegalViewController.h"
#import "CWDepthView.h"
#import "AppDelegate.h"

@interface CBAAboutViewController ()

@property (strong, nonatomic) CBALegalViewController *legalViewController;
@property (nonatomic) CGRect defaultFrame;

@end

@implementation CBAAboutViewController

@synthesize legalViewController, defaultFrame;

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
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"About this App";
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss"
                                                          style:UIBarButtonItemStylePlain
                                                         target:delegate.mainViewController
                                                         action:@selector(dismissAboutView)];
    [self.navigationItem setLeftBarButtonItem:dismissButton animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cezaryWojcikButtonPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"http://cezarywojcik.com"]];
}

- (IBAction)russelBarnesButtonPressed:(UIButton *)sender
{
}

- (IBAction)legalButtonPressed:(UIButton *)sender
{
    self.defaultFrame = self.view.frame;
    self.legalViewController = [[CBALegalViewController alloc] initWithNibName:@"CBALegalViewController" bundle:nil];
    [self.navigationController pushViewController:self.legalViewController animated:YES];
}

@end
