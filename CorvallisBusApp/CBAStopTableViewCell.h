//
//  CBAStopTableViewCell.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import "CBAFullMapPanelViewController.h"

@interface CBAStopTableViewCell : UITableViewCell

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIWindow *fullScreenWindow;
@property (strong, nonatomic) CBAFullMapPanelViewController *panelViewController;

@property (nonatomic) BOOL isFullScreen;

@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender;

@end
