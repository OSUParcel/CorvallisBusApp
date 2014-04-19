//
//  CBAStopTableViewCell.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <FBShimmeringView.h>

#import "CBAFullMapPanelViewController.h"

@interface CBAStopTableViewCell : UITableViewCell

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIWindow *fullScreenWindow;
@property (strong, nonatomic) CBAFullMapPanelViewController *panelViewController;

@property (nonatomic) CGRect defaultViewFrame;
@property (nonatomic) CGRect defaultMapViewFrame;
@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) NSInteger rowIndex;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *arrivalTimeView;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender;

@end
