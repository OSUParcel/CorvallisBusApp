//
//  CBAAboutViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/20/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAAboutViewController.h"
#import "FBShimmeringView.h"

@interface CBAAboutViewController ()

@end

@implementation CBAAboutViewController

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
}
@end
