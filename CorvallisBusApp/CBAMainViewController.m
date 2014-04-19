//
//  CBAMainViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/17/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAMainViewController.h"
#import "CBAStopTableViewCell.h"

@interface CBAMainViewController ()

@end

@implementation CBAMainViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.rowIndex = indexPath.row;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

@end
