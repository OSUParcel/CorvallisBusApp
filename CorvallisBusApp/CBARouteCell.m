//
//  CBARouteCell.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/4/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBARouteCell.h"
#import "UIColor+Hex.h"

@implementation CBARouteCell

@synthesize data;

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
    }
    return self;
}


- (void)setRoute:(NSDictionary *)route
{
    self.data = route;

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
    if (brightness > 0.70f) {
        brightness = 0.70f;
    }
    routeColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    
    // set color
    self.backgroundColor = routeColor;

}


@end
