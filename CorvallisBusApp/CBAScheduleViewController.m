//
//  CBAScheduleViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAScheduleViewController.h"
#import "BusData.h"
#import <Mixpanel.h>

@interface CBAScheduleViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *schedule;

@end

@implementation CBAScheduleViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ScheduleTableCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [UITableViewCell new];
        cell.backgroundColor = [UIColor clearColor];
        // time
        NSDate *date = [[self.schedule objectAtIndex:indexPath.row] objectForKey:@"Expected"];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *expected = [dateFormatter stringFromDate:date];
        NSDate *date2 = [[self.schedule objectAtIndex:indexPath.row] objectForKey:@"Scheduled"];
        NSString *scheduled = [dateFormatter stringFromDate:date2];
        
        if ([scheduled isEqualToString:expected]) {
            cell.textLabel.text = [NSString stringWithFormat:@"Scheduled: %@", scheduled];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"Scheduled: %@, Expected: %@", scheduled, expected];
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.schedule count];
}

- (void)scheduleForStop:(NSString *)stop name:(NSString *)name
{
    BusData *bus = [BusData new];
    NSDictionary *stopDict = [NSDictionary dictionaryWithObject:stop forKey:@"StopID"];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Stop ID Schedule View Opened" properties:stopDict];
    NSArray *schedule = [bus loadScheduleForStop:stop];
    self.schedule = schedule;
    self.routeNameLabel.text = name;
    [self.tableView reloadData];
    if ([self.schedule count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"These aren't the stops you're looking for."
                                                            message:@"Sadly, this stop doesn't have any scheduled stops anytime soon."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
