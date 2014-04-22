//
//  CBAMainViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/17/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CBAMainViewController.h"
#import "CBAStopTableViewCell.h"
#import "CBAAboutViewController.h"
#import "CBAAboutNavigationViewController.h"
#import "AppDelegate.h"
#import "BusData.h"

@interface CBAMainViewController ()

@property (nonatomic) BOOL isRefreshing;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) CBAAboutViewController *aboutViewController;
@property (strong, nonatomic) CWDepthView *depthView;
@property (strong, nonatomic) CBAAboutNavigationViewController *aboutNavigationController;

@end

@implementation CBAMainViewController

@synthesize arrivals;

@synthesize stopsTableView, aboutViewController, aboutNavigationController;

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
    
    // set up data source and delegate
    self.stopsTableView.dataSource = self;
    self.stopsTableView.delegate = self;
    
    // set top inset
    [self.stopsTableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    
    // status bar
    [self setNeedsStatusBarAppearanceUpdate];
    
    // location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    // refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.stopsTableView addSubview:self.refreshControl];
    [self.stopsTableView sendSubviewToBack:self.refreshControl];
    self.isRefreshing = NO;
    
    // setup depth view
    self.depthView = [CWDepthView new];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.depthView.windowForScreenshot = delegate.window;
    
    // load data
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

# pragma mark - abous us view methods

- (void)showAboutView
{
    self.aboutViewController = [[CBAAboutViewController alloc] initWithNibName:@"CBAAboutViewController" bundle:nil];
    CGFloat width = DEPTH_VIEW_SCALE * [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = DEPTH_VIEW_SCALE * [[UIScreen mainScreen] bounds].size.height;
    self.aboutNavigationController = [[CBAAboutNavigationViewController alloc] initWithRootViewController:self.aboutViewController];
    self.aboutNavigationController.view.frame = CGRectMake(0, 0, width, height);
    [self.depthView presentView:self.aboutNavigationController.view];
}

- (void)dismissAboutView
{
    [self.depthView dismissDepthViewWithCompletion:^{
        self.aboutViewController = nil;
        self.aboutNavigationController = nil;
    }];
}

# pragma mark - load data methods

- (void)loadData
{
    if (!self.isRefreshing) {
        self.isRefreshing = YES;
        BusData *busData = [BusData new];
//        self.arrivals = (NSMutableArray*)[busData loadArrivalsForLatitude:locationManager.location.coordinate.latitude
//                                                                Longitude:locationManager.location.coordinate.longitude];
        self.arrivals = (NSMutableArray*)[busData loadArrivalsForLatitude:44.5675577
                                                                Longitude:-123.2797895];
        [UIView transitionWithView:self.stopsTableView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self.stopsTableView reloadData];
        } completion:nil];
        [self.stopsTableView reloadData];
        self.isRefreshing = NO;
        [self.refreshControl endRefreshing];
        [self checkForEmptyData];
    }
}

- (void)checkForEmptyData
{
    if ([self.arrivals count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!"
                                                            message:@"It looks like no bus routes near you were found."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

# pragma mark - table view delegate methods

# pragma mark - table view data source methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CBAStopTableViewCellIdentifier";
    
    CBAStopTableViewCell *cell = (CBAStopTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CBAStopTableViewCell" owner:self options:nil];
        cell = (CBAStopTableViewCell *)[nib objectAtIndex:0];
        if ([self.arrivals count] == 0 && indexPath.row == 0) {
            // no data recieved
            [cell loadStaticViewWithMessage:@"No routes found."];
        } else if (indexPath.row >= [self.arrivals count]) {
            // about cell
            [cell loadStaticViewWithMessage:@"About this App"];
            cell.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAboutView)];
            cell.tapGestureRecognizer.numberOfTapsRequired = 1;
            [cell addGestureRecognizer:cell.tapGestureRecognizer];
        } else {
            // data was fetched
            cell.rowIndex = indexPath.row;
            [cell loadData:[self.arrivals objectAtIndex:indexPath.row]];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrivals count] == 0 ? 2 : [self.arrivals count] + 1;
}

@end
