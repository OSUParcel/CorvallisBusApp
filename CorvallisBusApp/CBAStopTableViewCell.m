//
//  CBAStopTableViewCell.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#define ANIMATION_TIME 0.5f
#define DEFAULT_ZOOM_LEVEL 16.0f
#define DEFAULT_VIEWING_ANGLE 90.0f
#define ZOOM_AMOUNT 3.0f
#define FULL_SCREEN_VIEWING_ANGLE 45.0f

#import "CBAStopTableViewCell.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"

@implementation CBAStopTableViewCell

@synthesize tapGestureRecognizer, fullScreenWindow, panelViewController;

@synthesize isFullScreen, defaultViewFrame, defaultMapViewFrame, rowIndex;

- (void)awakeFromNib
{
    // dont clip
    self.clipsToBounds = NO;
    self.superview.clipsToBounds = NO;
    
    // init gesture recognizer
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateToFullScreen:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    // map view setup
    self.isFullScreen = NO;
    self.mapView.indoorEnabled = NO;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.scrollGestures = NO;
    self.mapView.settings.zoomGestures = NO;
    [self.mapView animateToZoom:DEFAULT_ZOOM_LEVEL];
    [self.mapView animateToViewingAngle:DEFAULT_VIEWING_ANGLE];
    
    // shimmer setup
    self.arrivalTimeView.contentView = self.arrivalTimeLabel;
    self.arrivalTimeView.shimmering = YES;
    
    // shadow
    self.arrivalTimeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.arrivalTimeLabel.layer.shadowRadius = 4.0f;
    self.arrivalTimeLabel.layer.shadowOpacity = 1.0f;
    self.arrivalTimeLabel.layer.masksToBounds = NO;
    self.routeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.routeLabel.layer.shadowRadius = 4.0f;
    self.routeLabel.layer.shadowOpacity = 1.0f;
    self.routeLabel.layer.masksToBounds = NO;
    self.distanceLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.distanceLabel.layer.shadowRadius = 4.0f;
    self.distanceLabel.layer.shadowOpacity = 1.0f;
    self.distanceLabel.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

# pragma mark - load data


- (void)loadData:(NSDictionary*)data
{
    self.data = data;
    
    // get position
    CLLocationDegrees latitude = [[data objectForKey:@"Lat"] doubleValue];
    CLLocationDegrees longitude = [[data objectForKey:@"Long"] doubleValue];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView animateToLocation:position];
    
    // background color
    NSString *hexColor = [data objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    self.backgroundColor = routeColor;
    self.panelViewController.view.backgroundColor = routeColor;

    // marker
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = @"Bus Stop";
    marker.map = self.mapView;
    marker.icon = [GMSMarker markerImageWithColor:routeColor];
    
    // distance
    CGFloat distance = [[data objectForKey:@"Distance"] doubleValue] * 0.000621371;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles away", distance];
    
    // time
    NSDate *date = [data objectForKey:@"Arrival"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.arrivalTimeLabel.text = [dateFormatter stringFromDate:date];
    
    // route
    self.routeLabel.text = [NSString stringWithFormat:@"Route %@", [data objectForKey:@"Route"]];
}

# pragma mark - setup methods

- (void)setupFullScreenWindow
{
    self.fullScreenWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.fullScreenWindow.backgroundColor = [UIColor clearColor];
    self.fullScreenWindow.userInteractionEnabled = YES;
    self.fullScreenWindow.windowLevel = UIWindowLevelNormal;
    self.fullScreenWindow.rootViewController = [UIViewController new];
    [self.fullScreenWindow.rootViewController.view addSubview:self];
    [self.fullScreenWindow makeKeyAndVisible];
}

- (void)setupPanelViewController
{
    self.panelViewController = [[CBAFullMapPanelViewController alloc] initWithNibName:@"CBAFullMapPanelViewController" bundle:nil];
    self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height,
                                                     self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    [self.panelViewController.dismissButton addTarget:self action:@selector(animateFromFullScreen) forControlEvents:UIControlEventTouchUpInside];
    self.panelViewController.arrivalTimeLabel.text = self.arrivalTimeLabel.text;
    NSString *hexColor = [self.data objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    self.panelViewController.view.backgroundColor = routeColor;
    [self.fullScreenWindow.rootViewController.view addSubview:self.panelViewController.view];
}

# pragma mark - animation methods

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender
{
    if (!self.isFullScreen) {
        self.isFullScreen = YES;
        
        // save previous frames
        self.defaultViewFrame = [self convertRect:self.bounds toView:nil];
        self.defaultMapViewFrame = self.mapView.frame;

        // set up window
        [self setupFullScreenWindow];
        
        self.frame = CGRectMake(self.defaultViewFrame.origin.x, self.defaultViewFrame.origin.y - 20,
                                self.defaultViewFrame.size.width, self.defaultViewFrame.size.height);
        self.mapView.frame = CGRectMake(self.defaultMapViewFrame.origin.x, self.defaultMapViewFrame.origin.y - 20,
                                        self.defaultMapViewFrame.size.width, self.defaultMapViewFrame.size.height);
        
        // animate map to full screen
        [self.superview.superview bringSubviewToFront:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:ANIMATION_TIME animations:^{
                self.fullScreenWindow.frame = [[UIScreen mainScreen] bounds];
                self.frame = [[UIScreen mainScreen] bounds];
                self.mapView.frame = [[UIScreen mainScreen] bounds];
            } completion:^(BOOL finished) {
                // zoom in
                GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomBy:ZOOM_AMOUNT];
                [self.mapView animateWithCameraUpdate:zoomIn];
                [self.mapView animateToViewingAngle:FULL_SCREEN_VIEWING_ANGLE];
                CLLocationDegrees latitude = [[self.data objectForKey:@"Lat"] doubleValue];
                CLLocationDegrees longitude = [[self.data objectForKey:@"Long"] doubleValue];
                CGFloat x = latitude - self.mapView.myLocation.coordinate.latitude;
                CGFloat y = longitude - self.mapView.myLocation.coordinate.longitude;
                [self.mapView animateToBearing:(atan2(x, y) * 180.0/M_PI)];
                
                // set up panel
                [self setupPanelViewController];
                // animate panel in
                [self animatePanelIn];
                
                // enable user interaction
                self.mapView.settings.scrollGestures = YES;
                self.mapView.settings.zoomGestures = YES;
            }];
        });
    }
}

- (void)animateFromFullScreen
{
    // disable user interaction
    self.mapView.settings.scrollGestures = NO;
    self.mapView.settings.zoomGestures = NO;
    
    // reset zoom and viewing angle
    CLLocationDegrees latitude = [[self.data objectForKey:@"Lat"] doubleValue];
    CLLocationDegrees longitude = [[self.data objectForKey:@"Long"] doubleValue];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView animateToZoom:DEFAULT_ZOOM_LEVEL];
    [self.mapView animateToViewingAngle:DEFAULT_VIEWING_ANGLE];
    [self.mapView animateToLocation:position];
    [self.mapView animateToBearing:0.0f];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.fullScreenWindow.frame = [[UIScreen mainScreen] bounds];
            self.frame = self.defaultViewFrame;
            self.mapView.frame = self.defaultMapViewFrame;
            self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height + 100,
                                                             self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
            self.panelViewController.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.fullScreenWindow = nil;
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:self.rowIndex inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [delegate.mainViewController.stopsTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        }];
    });
}

- (void)animatePanelIn
{
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - self.panelViewController.view.frame.size.height,
                                                         self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    }];
}
@end
