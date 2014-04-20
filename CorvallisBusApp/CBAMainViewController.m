//
//  CBAMainViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/17/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAMainViewController.h"
#import "CBAStopTableViewCell.h"
#import "BusData.h"

@interface CBAMainViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL isRefreshing;

@end

@implementation CBAMainViewController

@synthesize arrivals;

@synthesize stopsTableView;

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
    self.isRefreshing = NO;
    
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

# pragma mark - load data methods

- (void)loadData
{
    if (!self.isRefreshing) {
        self.isRefreshing = YES;
        BusData *busData = [BusData new];
        self.arrivals = (NSMutableArray*)[busData loadArrivalsForLatitude:locationManager.location.coordinate.latitude
                                                                Longitude:locationManager.location.coordinate.longitude];
        [self.stopsTableView reloadData];
        self.isRefreshing = NO;
        [self.refreshControl endRefreshing];
        [self checkForEmptyData];
    }
}

- (void)checkForEmptyData
{
    if ([self.arrivals count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"It looks like no bus routes near you were found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        if ([self.arrivals count] == 0) {
            // no data recieved
            cell.routeLabel.alpha = 0.0f;
            cell.distanceLabel.alpha = 0.0f;
            cell.arrivalTimeLabel.text = NSLocalizedString(@"No routes found.", @"bus routes");
            cell.arrivalTimeLabel.frame = cell.frame;
            cell.backgroundColor = [UIColor grayColor];
            cell.userInteractionEnabled = NO;
            [cell.mapView removeFromSuperview];
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
    return [self.arrivals count] == 0 ? 1 : [self.arrivals count];
}

@end
