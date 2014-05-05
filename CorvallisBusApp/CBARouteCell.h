//
//  CBARouteCell.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBARouteCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;

@property (strong, nonatomic) NSDictionary *data;

- (void)setRoute:(NSDictionary *)route;

@end
