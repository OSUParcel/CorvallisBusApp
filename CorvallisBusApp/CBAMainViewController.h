//
//  CBAMainViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/17/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CBAMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *stopsTableView;

@end
