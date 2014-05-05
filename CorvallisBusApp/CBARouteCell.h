//
//  CBARouteCell.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBShimmeringView.h>

@interface CBARouteCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) NSDictionary *data;

- (void)setRoute:(NSDictionary *)route;
- (void)loadDefault;

@end
