//
//  CBARouteCell.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBARouteCell.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"

@implementation CBARouteCell
{
    NSArray *defaultSublayers;
}

@synthesize data, gradientLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CBARouteCell" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        defaultSublayers = [self.layer.sublayers copy];
    }
    return self;
}

- (void)awakeFromNib
{
    self.shimmeringView.contentView = self.routeNameLabel;
    self.shimmeringView.shimmering = NO;
}

- (void)setRoute:(NSDictionary *)route
{
    self.data = route;
    
    self.imageView.alpha = 0.0f;
    
    self.routeNameLabel.text = [self.data objectForKey:@"Name"];
    
    // background color
    NSString *hexColor = [self.data objectForKey:@"Color"];
    UIColor *routeColor = [UIColor colorWithHexValue:hexColor];
    
    // correct color if it is too bright
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [routeColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (brightness > 0.80f) {
        brightness = 0.80f;
    }
    routeColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    
    // set color
    // self.backgroundColor = routeColor;
    
    // gradient
    self.backgroundColor = [UIColor clearColor];
    self.gradientLayer = [UIColor getGradientForColor:routeColor andFrame:self.bounds];
    self.layer.sublayers = defaultSublayers;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)loadDefault
{
    self.backgroundColor = [UIColor clearColor];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIColor *myTintColor = delegate.window.tintColor;
    self.gradientLayer = [UIColor getGradientForColor:myTintColor andFrame:self.bounds];
    self.layer.sublayers = defaultSublayers;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    self.routeNameLabel.text = @"";
    self.imageView.image = [UIImage imageNamed:@"route.png"];
    self.imageView.alpha = 1.0f;
}


@end
