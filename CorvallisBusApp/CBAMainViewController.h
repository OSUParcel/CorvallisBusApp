//
//  CBAMainViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/17/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CBAMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) NSMutableArray *arrivals;

@property (strong, nonatomic) IBOutlet UITableView *stopsTableView;
@property (weak, nonatomic) IBOutlet UIView *statusBarBackgroundView;

- (void)loadData;
- (void)dismissAboutView;

@end
