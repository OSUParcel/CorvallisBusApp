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

@interface CBAAboutViewController () {
    UIImageView *navBarHairlineImageView;
    UIView *blackView;
}

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
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
    blackView = [UIView new];
    blackView.frame = CGRectMake(0,
                                 0,
                                 self.navigationController.navigationBar.frame.size.width,
                                 self.navigationController.navigationBar.frame.size.height);
    blackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:blackView];
    [self.navigationController.navigationBar sendSubviewToBack:blackView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (IBAction)cezaryWojcikButtonPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"http://cezarywojcik.com"]];
}

- (IBAction)russellBarnesButtonPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"http://www.linkedin.com/in/russellbarnes1/"]];
}

- (IBAction)legalButtonPressed:(UIButton *)sender
{
    self.defaultFrame = self.view.frame;
    self.legalViewController = [[CBALegalViewController alloc] initWithNibName:@"CBALegalViewController" bundle:nil];
    [blackView removeFromSuperview];
    blackView = nil;
    [self.navigationController pushViewController:self.legalViewController animated:YES];
}

@end
