//
//  CBAScheduleViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAScheduleViewController.h"
#import "BusData.h"

@interface CBAScheduleViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *schedule;
@property (nonatomic, strong) NSString *name;

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
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CBAStopTableViewCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        // time
        NSDate *date = [[self.schedule objectAtIndex:indexPath.row] objectForKey:@"Expected"];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"hh:mm a"];
        cell.textLabel.text = [dateFormatter stringFromDate:date];
        
        NSDate *date2 = [[self.schedule objectAtIndex:indexPath.row] objectForKey:@"Scheduled"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:date2];
        
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.schedule count];
}

- (void)scheduleForStop:(NSString *)stop name:(NSString *)name
{
    BusData *bus = [[BusData alloc] init];
    NSArray *schedule = [bus loadScheduleForStop:stop];
    self.schedule = schedule;
    self.name = name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
