//
//  CBARouteListViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBARouteListViewController.h"
#import "CBARouteCell.h"
#import "Routes.h"
#import "Stops.h"
#import "UIImage+UIImage_Replace.h"
#import "UIColor+Hex.h"
#import "CBAStopAnnotation.h"
#import "AppDelegate.h"

#include <Mixpanel.h>

#include <stdlib.h>

#define ANIMATION_TIME 0.5f
#define FULLSCREEN_DELTA 0.001f
#define CAMERA_PITCH 65.0f
#define CAMERA_HEADING 0.0f
#define CAMERA_ALTITUDE 25000.0f

@interface StopInfoButton : UIButton

@property (strong, nonatomic) NSString *stopID;
@property (strong, nonatomic) NSString *name;

@end

@implementation StopInfoButton

@synthesize stopID, name;

@end

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

@interface CBARouteListViewController ()

@end

@implementation CBARouteListViewController

@synthesize routes, panelViewController, currentRoute, movedCells, movedCellFrames, statusBarView, stopsForRoute, scheduleViewController, depthView;

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
    
    self.routeListView.delegate = self;
    self.routeListView.dataSource = self;
    
    [self.routeListView registerClass:[CBARouteCell class] forCellWithReuseIdentifier:@"CBARouteCell"];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    [flowLayout setItemSize:CGSizeMake(160, 165)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.routeListView setCollectionViewLayout:flowLayout];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.routeListView.frame = [[UIScreen mainScreen] applicationFrame];
    self.routeListView.backgroundColor = [UIColor blackColor];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame.size.height -= 50;
    self.mapView.frame = frame;
    self.statusBarView = [UIView new];
    self.statusBarView.frame = CGRectMake(0, -500, [[UIScreen mainScreen] bounds].size.width, 20);
    [self.view addSubview:self.statusBarView];
    
    // hacks
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        self.routeListView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 460 + 128);
        self.mapView.frame = CGRectMake(0, 128, [[UIScreen mainScreen] bounds].size.width, 460 - 50);
    }
    
    self.depthView = [CWDepthView new];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.depthView.windowForScreenshot = delegate.window;
    
    [self setupPanelViewController];
    self.stopsForRoute = [NSMutableDictionary new];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    self.routes = [Routes getRoutes];
    [self.routeListView reloadData];
}

- (void)loadStopsForRoute:(NSString *)route
{
    if (self.stopsForRoute == nil) {
        self.stopsForRoute = [NSMutableDictionary new];
    }
    if ([self.stopsForRoute objectForKey:route] == nil) {
        NSArray *stops = [Stops getStopsForRoute:route];
        [self.stopsForRoute setObject:stops forKey:route];
    }
    
    // add annotation
    for (NSDictionary *stop in [self.stopsForRoute objectForKey:route]) {
        CBAStopAnnotation *marker = [CBAStopAnnotation new];
        marker.title = [stop objectForKey:@"Name"];
        marker.subtitle = [NSString stringWithFormat:@"Route %@, Stop ID %@", route, [stop objectForKey:@"ID"]];
        marker.stopID = [stop objectForKey:@"ID"];
        CLLocationDegrees latitude = [[stop objectForKey:@"Lat"] doubleValue];
        CLLocationDegrees longitude = [[stop objectForKey:@"Long"] doubleValue];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.coordinate = position;
        [self.mapView addAnnotation:marker];
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotation.pinColor = MKPinAnnotationColorRed;
    newAnnotation.animatesDrop = YES;
    newAnnotation.canShowCallout = YES;
    StopInfoButton *infoButton = [StopInfoButton buttonWithType:UIButtonTypeDetailDisclosure];
    infoButton.stopID = ((CBAStopAnnotation *)annotation).stopID;
    infoButton.name = ((CBAStopAnnotation *)annotation).title;
    [infoButton addTarget:self action:@selector(infoForStop:)
         forControlEvents:UIControlEventTouchUpInside];
    newAnnotation.rightCalloutAccessoryView = infoButton;
    [newAnnotation setSelected:YES animated:YES];
    return newAnnotation;
}

- (void)infoForStop:(StopInfoButton*)sender
{
    NSString *stop = sender.stopID;
    NSString *name = sender.name;
    self.scheduleViewController = [[CBAScheduleViewController alloc] initWithNibName:@"CBAScheduleViewController" bundle:nil];
    CGFloat width = DEPTH_VIEW_SCALE * [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = DEPTH_VIEW_SCALE * [[UIScreen mainScreen] bounds].size.height;
    self.scheduleViewController.view.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - width)/2,
                                                        ([[UIScreen mainScreen] bounds].size.height - height)/2,
                                                        width, height);
    self.scheduleViewController.view.backgroundColor = [UIColor clearColor];
    [self.depthView presentView:self.scheduleViewController.view];
    [self.scheduleViewController scheduleForStop:stop name:name];
    [self.scheduleViewController.dismissButton addTarget:self action:@selector(dismissScheduleView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissScheduleView
{
    [self.depthView dismissDepthViewWithCompletion:nil];
}

# pragma mark - collection view data source

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup cell identifier
    static NSString *cellIdentifier = @"CBARouteCell";
    
    CBARouteCell *cell = (CBARouteCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == [self.routes count]) {
        [cell loadDefault];
    } else {
        [cell setRoute:[self.routes objectAtIndex:indexPath.row]];
    }
    
    // Return the cell
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.routes count] % 2 == 0) {
        return [self.routes count];
    }
    return [self.routes count] + 1;
}

# pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.routes count]) {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        self.currentRoute = [self.routes objectAtIndex:indexPath.row];
        NSDictionary *routeDict = [NSDictionary dictionaryWithObject:[self.currentRoute objectForKey:@"Name"] forKey:@"Route Name"];
        [mixpanel track:@"Route List View Route Selected" properties:routeDict];
        [self setupMapView];
        [self animateCellsOut];
    }
}

# pragma mark - animation

- (void)setupPanelViewController
{
    self.panelViewController = [[CBAFullMapPanelViewController alloc] initWithNibName:@"CBAFullMapPanelViewController" bundle:nil];
    self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height + 500,
                                                     self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    [self.panelViewController.dismissButton addTarget:self action:@selector(animateCellsIn) forControlEvents:UIControlEventTouchUpInside];
    self.panelViewController.arrivalTimeLabel.text = @"";
    self.panelViewController.routeLabel.text = @"";
    self.panelViewController.routeLabel.userInteractionEnabled = NO;
    [self.view addSubview:self.panelViewController.view];
}

- (void)animateCellsOut
{
    self.mapView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    self.mapView.alpha = 0.0f;
    
    // clear annotations
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (userLocation != nil) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    [self.mapView removeAnnotations:pins];
    pins = nil;
    
    [self.view bringSubviewToFront:self.panelViewController.view];
    
    NSString *hexColor = [self.currentRoute objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    
    self.mapView.tintColor = routeColor;

    self.panelViewController.view.backgroundColor = routeColor;
    self.panelViewController.arrivalTimeLabel.text = [NSString stringWithFormat:@"Route %@", [self.currentRoute objectForKey:@"Name"]];
    self.panelViewController.stop = [self.currentRoute objectForKey:@"ID"];
    self.panelViewController.routeName = [self.currentRoute objectForKey:@"Name"];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        [self.panelViewController hacks];
    }
    
    self.routeListView.backgroundColor = [UIColor clearColor];
    
    self.statusBarView.backgroundColor = routeColor;
    [self.view bringSubviewToFront:self.statusBarView];
    
    self.statusBarView.frame = CGRectMake(0, -100, [[UIScreen mainScreen] bounds].size.width, 20);
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        // hacks - avert eyes
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self.statusBarView.frame = CGRectMake(0, -19, [[UIScreen mainScreen] bounds].size.width, 20);
            self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 50 - 19,
                                                             self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
        } else {
            self.statusBarView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20);
            self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 50,
                                                             self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
        }
        self.mapView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.mapView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        CGRect frame = self.routeListView.frame;
        frame.origin.x  = -1000.0f;
        self.routeListView.frame = frame;
        [self loadStopsForRoute:[self.currentRoute objectForKey:@"Name"]];
    }];
    movedCells = [NSMutableArray new];
    movedCellFrames = [NSMutableArray new];
    for (CBARouteCell *cell in self.routeListView.visibleCells) {
        cell.layer.shadowRadius = 0.0f;
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            [movedCells addObject:cell];
            [movedCellFrames addObject:[NSValue valueWithCGRect:cell.frame]];
            cell.layer.shadowColor = [[UIColor blackColor] CGColor];
            cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            cell.layer.shadowOpacity = 0.5f;
            cell.layer.shadowRadius = 10.0f;
            CGFloat x = (arc4random() % (NSInteger) ([[UIScreen mainScreen] bounds].size.width)) + cell.frame.size.width;
            if (arc4random() % 2 == 1) {
                x *= -1;
            } else {
                x += [[UIScreen mainScreen] bounds].size.width;
            }
            cell.frame = CGRectMake(x, arc4random() % (NSInteger) [[UIScreen mainScreen] bounds].size.height, cell.frame.size.width, cell.frame.size.height);
        }];
    }
}

- (void)animateCellsIn
{
    CGRect frame = self.routeListView.frame;
    frame.origin.x  = 0.0f;
    self.routeListView.frame = frame;

    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height + 500,
                                                         self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
        self.mapView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        self.statusBarView.frame = CGRectMake(0, -500, [[UIScreen mainScreen] bounds].size.width, 20);
    } completion:^(BOOL finished) {
        self.routeListView.backgroundColor = [UIColor blackColor];
    }];
    
    NSUInteger count = 0;
    for (CBARouteCell *cell in self.movedCells) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            cell.frame = [[self.movedCellFrames objectAtIndex:count] CGRectValue];
            cell.layer.shadowRadius = 0.0f;
        } completion:^(BOOL finished) {
        
        }];
        count++;
    }
}

- (void)setupMapView
{
    // route line
    [self.mapView removeOverlays:self.mapView.overlays];
    MKPolyline *route = [MKPolyline polylineWithEncodedString:[self.currentRoute objectForKey:@"Polyline"]];
    [self.mapView addOverlay:route];
    
    // region
    MKPolygon* polygon = [MKPolygon polygonWithPoints:route.points count:route.pointCount];
    [self.mapView setRegion:MKCoordinateRegionForMapRect([polygon boundingMapRect]) animated:NO];
    
    // zoom out a bit
    MKMapCamera *camera = [MKMapCamera new];
    camera = self.mapView.camera;
    camera.altitude = self.mapView.camera.altitude + 1000;
    [self.mapView setCamera:camera animated:NO];
}

# pragma mark - map view delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        NSString *hexColor = [self.currentRoute objectForKey:@"Color"];
        UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
        routeRenderer.strokeColor = routeColor;
        routeRenderer.lineWidth = 5.0f;
        return routeRenderer;
    }
    else {
        return nil;
    }
}

@end
