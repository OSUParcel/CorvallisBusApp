//
//  CBARouteListViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CBARouteListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *routeListView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CBARouteListViewController *routeListViewController;
@property (strong, nonatomic) NSArray *routes;

@end
