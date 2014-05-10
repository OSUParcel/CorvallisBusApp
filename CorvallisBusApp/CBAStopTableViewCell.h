//
//  CBAStopTableViewCell.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBShimmeringView.h>
#import <MapKit/MapKit.h>

#import "CBAFullMapPanelViewController.h"

@interface CBAStopTableViewCell : UITableViewCell <MKMapViewDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIWindow *fullScreenWindow;
@property (strong, nonatomic) CBAFullMapPanelViewController *panelViewController;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) UIImageView *mapViewImage;

@property (nonatomic) CGRect defaultViewFrame;
@property (nonatomic) CGRect defaultMapViewFrame;
@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) NSInteger rowIndex;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *arrivalTimeView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender;
- (void)loadStaticViewWithMessage:(NSString*)message;
- (void)loadData:(NSDictionary*)data;

@end
