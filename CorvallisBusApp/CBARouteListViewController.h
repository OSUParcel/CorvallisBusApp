//
//  CBARouteListViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CBAFullMapPanelViewController.h"

@interface CBARouteListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *routeListView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) CBAFullMapPanelViewController *panelViewController;
@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) NSDictionary *currentRoute;
@property (strong, nonatomic) NSMutableArray *movedCells;
@property (strong, nonatomic) NSMutableArray *movedCellFrames;
@property (strong, nonatomic) NSMutableDictionary *stopsForRoute;

@end
