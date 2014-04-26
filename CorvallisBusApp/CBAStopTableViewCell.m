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

@implementation MKPolyline (MKPolyline_EncodedString)

+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}

@end

@implementation CBAStopTableViewCell {
    CAGradientLayer *gradientLayer;
    BOOL isMapViewCacheLoaded;
}

@synthesize tapGestureRecognizer, fullScreenWindow, panelViewController, mapViewImage;

@synthesize isFullScreen, defaultViewFrame, defaultMapViewFrame, rowIndex;

- (void)awakeFromNib
{
    // dont clip
    self.clipsToBounds = NO;
    self.superview.clipsToBounds = NO;
    
    // map view setup
    self.isFullScreen = NO;
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = self;
    
    // shimmer setup
    self.arrivalTimeView.contentView = self.arrivalTimeLabel;
    self.arrivalTimeView.shimmering = YES;
    
    isMapViewCacheLoaded = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

# pragma mark - get map image

- (UIImage*)getMapImage
{
    // map view frame
    CGRect frame = self.mapView.frame;
    // begin image context
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0.0f);
    // get current context
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // draw  map view
    [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // clip context to map view frame
    CGContextClipToRect(currentContext, frame);
    // get resulting cropped screenshot
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    // end image context
    UIGraphicsEndImageContext();
    // return image
    return screenshot;
}

# pragma mark - map view delegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"finish");
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    CBAMapViewCacheManager *mapViewCacheManager = delegate.mapViewCacheManager;
    if (![mapViewCacheManager cachedImageExistsForStopID:[self.data objectForKey:@"ID"]]) {
        [mapViewCacheManager cacheImage:[self getMapImage] forStopID:[self.data objectForKey:@"ID"]];
        [self loadCachedImage];
    }
}

# pragma mark - load data

- (void)loadStaticViewWithMessage:(NSString*)message
{
    self.routeLabel.alpha = 0.0f;
    self.distanceLabel.alpha = 0.0f;
    self.arrivalTimeLabel.text = NSLocalizedString(message, nil);
    self.arrivalTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor grayColor];
//    self.backgroundColor = [UIColor clearColor];
//    gradientLayer = [UIColor getGradientForColor:[UIColor grayColor] andFrame:self.bounds];
//    [self.layer insertSublayer:gradientLayer atIndex:0];
    [self.mapView removeFromSuperview];
}

- (void)loadData:(NSDictionary*)data
{
    self.data = data;
    
    // init gesture recognizer
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateToFullScreen:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    NSString *stopID = [data objectForKey:@"ID"];
    
    // background color
    NSString *hexColor = [self.data objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    
    // correct color if it is too bright
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [routeColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (brightness < 0.50f) {
        brightness = 0.50f;
    }
    routeColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    
    // set color
    self.backgroundColor = routeColor;
    
    // gradient
    //    self.backgroundColor = [UIColor clearColor];
    //    gradientLayer = [UIColor getGradientForColor:routeColor andFrame:self.frame];
    //    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    // distance
    CGFloat distance = [[self.data objectForKey:@"Distance"] doubleValue] * 0.000621371;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles away", distance];
    
    // time
    NSDate *date = [self.data objectForKey:@"Arrival"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.arrivalTimeLabel.text = [dateFormatter stringFromDate:date];
    
    // route
    self.routeLabel.text = [self.data objectForKey:@"Name"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    CBAMapViewCacheManager *mapViewCacheManager = delegate.mapViewCacheManager;
    if ([mapViewCacheManager cachedImageExistsForStopID:stopID]) {
        [self loadCachedImage];
    } else {
        [self loadMap];
    }
}

- (void)loadCachedImage
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    CBAMapViewCacheManager *mapViewCacheManager = delegate.mapViewCacheManager;
    self.mapViewImage = [[UIImageView alloc] initWithImage:
                         [mapViewCacheManager cachedImageForStopID:[self.data objectForKey:@"ID"]]];
    self.mapViewImage.frame = self.mapView.frame;
    self.mapViewImage.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mapViewImage];
    [self.mapView removeFromSuperview];
    self.mapView = nil;
    isMapViewCacheLoaded = YES;
}

- (void)loadMap
{
    // get position
    CLLocationDegrees latitude = [[self.data objectForKey:@"Lat"] doubleValue];
    CLLocationDegrees longitude = [[self.data objectForKey:@"Long"] doubleValue];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView setCenterCoordinate:position];
    
    // background color
    NSString *hexColor = [self.data objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    
    // marker
//    GMSMarker *marker = [GMSMarker markerWithPosition:position];
//    marker.title = [self.data objectForKey:@"Name"];
//    marker.snippet = [NSString stringWithFormat:@"Route %@, Stop ID %@", self.data, [self.data objectForKey:@"ID"]];
//    marker.map = self.mapView;
//    marker.icon = [GMSMarker markerImageWithColor:routeColor];
    
    // polyline
    MKPolyline *route = [MKPolyline polylineWithEncodedString:[self.data objectForKey:@"Polyline"]];
    [self.mapView addOverlay:route];
//    GMSPolyline *route = [GMSPolyline polylineWithPath:[GMSPath pathFromEncodedPath:[self.data objectForKey:@"Polyline"]]];
//    route.strokeColor = routeColor;
//    route.strokeWidth = 5.0f;
//    route.map = self.mapView;
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
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.mapWindow = self.fullScreenWindow;
}

- (void)setupPanelViewController
{
    self.panelViewController = [[CBAFullMapPanelViewController alloc] initWithNibName:@"CBAFullMapPanelViewController" bundle:nil];
    self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height,
                                                     self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    [self.panelViewController.dismissButton addTarget:self action:@selector(animateFromFullScreen) forControlEvents:UIControlEventTouchUpInside];
    self.panelViewController.arrivalTimeLabel.text = self.arrivalTimeLabel.text;
    self.panelViewController.routeLabel.text = @"Route Details";
    NSString *hexColor = [self.data objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    self.panelViewController.view.backgroundColor = routeColor;
    self.panelViewController.stop = [self.data objectForKey:@"ID"];
    self.panelViewController.routeName = [self.data objectForKey:@"Name"];
    [self.fullScreenWindow.rootViewController.view addSubview:self.panelViewController.view];
}

# pragma mark - animation methods

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender
{
    if (!self.isFullScreen) {
        self.isFullScreen = YES;
        
        // replace screenshot with mapview
        if (isMapViewCacheLoaded) {
            self.mapView = [MKMapView new];
            self.mapView.frame = self.mapViewImage.frame;
            [self addSubview:self.mapView];
            [self.mapViewImage removeFromSuperview];
            self.mapViewImage = nil;
            [self loadMap];
        }
        self.mapView.showsUserLocation = YES;
        
        // save previous frames
        self.defaultViewFrame = [self convertRect:self.bounds toView:nil];
        self.defaultMapViewFrame = self.mapView.frame;

        // set up window
        [self setupFullScreenWindow];
        
        self.frame = CGRectMake(self.defaultViewFrame.origin.x, self.defaultViewFrame.origin.y - 20,
                                self.defaultViewFrame.size.width, self.defaultViewFrame.size.height);
        self.mapView.frame = CGRectMake(self.defaultMapViewFrame.origin.x, self.defaultMapViewFrame.origin.y,
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
//                GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomBy:ZOOM_AMOUNT];
//                [self.mapView animateWithCameraUpdate:zoomIn];
//                [self.mapView animateToViewingAngle:FULL_SCREEN_VIEWING_ANGLE];
                // [self.mapView animateToBearing:[[self.data objectForKey:@"Bearing"] doubleValue]];
                
                // set up panel
                [self setupPanelViewController];
                
                // animate panel in
                [self animatePanelIn];
                
                // enable user interaction
//                self.mapView.settings.scrollGestures = YES;
//                self.mapView.settings.zoomGestures = YES;
            }];
        });
    }
}

- (void)animateFromFullScreen
{
    // disable user interaction
//    self.mapView.settings.scrollGestures = NO;
//    self.mapView.settings.zoomGestures = NO;
    
    // reset zoom and viewing angle
    CLLocationDegrees latitude = [[self.data objectForKey:@"Lat"] doubleValue];
    CLLocationDegrees longitude = [[self.data objectForKey:@"Long"] doubleValue];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
//    [self.mapView animateToZoom:DEFAULT_ZOOM_LEVEL];
//    [self.mapView animateToViewingAngle:DEFAULT_VIEWING_ANGLE];
//    [self.mapView animateToLocation:position];
    //    [self.mapView animateToBearing:0.0f];
    self.mapView.showsUserLocation = NO;
    
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
