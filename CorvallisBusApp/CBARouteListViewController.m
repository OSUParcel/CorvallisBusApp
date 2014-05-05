//
//  CBARouteListViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBARouteListViewController.h"
#import "CBARouteCell.h"
#import "Routes.h"

@interface CBARouteListViewController ()

@end

@implementation CBARouteListViewController

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
    
    self.routeListView.delegate = self;
    self.routeListView.dataSource = self;
    
    [self.routeListView registerClass:[CBARouteCell class] forCellWithReuseIdentifier:@"CBARouteCell"];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    [flowLayout setItemSize:CGSizeMake(160, 165)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.routeListView setCollectionViewLayout:flowLayout];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    self.routes = [Routes getRoutes];
    [self.routeListView reloadData];
}

# pragma mark - collection view data source

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup cell identifier
    static NSString *cellIdentifier = @"CBARouteCell";
    
    CBARouteCell *cell = (CBARouteCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setRoute:[self.routes objectAtIndex:indexPath.row]];
    
    // Return the cell
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.routes count];
}

@end
