//
//  CBARouteListViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBARouteListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *routeListView;

@property (strong, nonatomic) NSArray *routes;

@end
