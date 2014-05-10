//
//  CBAFullMapPanelViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAScheduleViewController.h"
#import "CWDepthView.h"

@interface CBAFullMapPanelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) CBAScheduleViewController *scheduleViewController;
@property (strong, nonatomic) CWDepthView *depthView;
@property (strong, nonatomic) NSString *stop;
@property (strong, nonatomic) NSString *routeName;

- (void)routeTapped:(UITapGestureRecognizer*)sender;
- (void)hacks;

@end
