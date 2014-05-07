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
#import "UIColor+Hex.h"

#include <stdlib.h>

#define ANIMATION_TIME 0.5f

@interface CBARouteListViewController ()

@end

@implementation CBARouteListViewController

@synthesize panelViewController, movedCellFrames, movedCells;

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
    
    [self setupPanelViewController];
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
    if (indexPath.row == [self.routes count]) {
        [cell loadDefault];
    } else {
        [cell setRoute:[self.routes objectAtIndex:indexPath.row]];
    }
    
    // Return the cell
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.routes count] % 2 == 0) {
        return [self.routes count];
    }
    return [self.routes count] + 1;
}

# pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentRoute = [self.routes objectAtIndex:indexPath.row];
    [self animateCellsOut];
}

# pragma mark - animation

- (void)setupPanelViewController
{
    self.panelViewController = [[CBAFullMapPanelViewController alloc] initWithNibName:@"CBAFullMapPanelViewController" bundle:nil];
    self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height + 500,
                                                     self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    [self.panelViewController.dismissButton addTarget:self action:@selector(animateCellsIn) forControlEvents:UIControlEventTouchUpInside];
    self.panelViewController.arrivalTimeLabel.text = @"";
    self.panelViewController.routeLabel.text = @"";
    self.panelViewController.routeLabel.userInteractionEnabled = NO;
    [self.view addSubview:self.panelViewController.view];
}

- (void)animateCellsOut
{
    self.mapView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    self.mapView.alpha = 0.0f;
    
    [self.view bringSubviewToFront:self.panelViewController.view];
    NSString *hexColor = [self.currentRoute objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    self.panelViewController.view.backgroundColor = routeColor;
    self.panelViewController.stop = [self.currentRoute objectForKey:@"ID"];
    self.panelViewController.routeName = [self.currentRoute objectForKey:@"Name"];
    
    self.routeListView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.mapView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.mapView.alpha = 1.0f;
        self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 50,
                                                         self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        CGRect frame = self.routeListView.frame;
        frame.origin.x  = -1000.0f;
        self.routeListView.frame = frame;
    }];
    movedCells = [NSMutableArray new];
    movedCellFrames = [NSMutableArray new];
    for (CBARouteCell *cell in self.routeListView.visibleCells) {
        cell.layer.shadowRadius = 0.0f;
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            [movedCells addObject:cell];
            [movedCellFrames addObject:[NSValue valueWithCGRect:cell.frame]];
            cell.layer.shadowColor = [[UIColor blackColor] CGColor];
            cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            cell.layer.shadowOpacity = 0.5f;
            cell.layer.shadowRadius = 10.0f;
            CGFloat x = (arc4random() % (NSInteger) ([[UIScreen mainScreen] bounds].size.width)) + cell.frame.size.width;
            if (arc4random() % 2 == 1) {
                x *= -1;
            } else {
                x += [[UIScreen mainScreen] bounds].size.width;
            }
            cell.frame = CGRectMake(x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        }];
    }
}

- (void)animateCellsIn
{
    CGRect frame = self.routeListView.frame;
    frame.origin.x  = 0.0f;
    self.routeListView.frame = frame;

    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.panelViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height + 500,
                                                         self.panelViewController.view.frame.size.width, self.panelViewController.view.frame.size.height);
        self.mapView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.routeListView.backgroundColor = [UIColor whiteColor];
    }];
    
    NSUInteger count = 0;
    for (CBARouteCell *cell in self.movedCells) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            cell.frame = [[self.movedCellFrames objectAtIndex:count] CGRectValue];
            cell.layer.shadowRadius = 0.0f;
        } completion:^(BOOL finished) {
        
        }];
        count++;
    }
}

@end
