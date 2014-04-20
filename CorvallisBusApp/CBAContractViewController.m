//
//  CBAContractViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/20/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAContractViewController.h"

@interface CBAContractViewController ()

@end

@implementation CBAContractViewController

@synthesize contractTextView;

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
    self.contractTextView.text = self.contract;
    self.contractTextView.userInteractionEnabled = YES;
    self.contractTextView.scrollEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.contractTextView scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
