//
//  UIColor+Hex.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHexValue:(NSString*)hexValue
{
    UIColor *defaultResult = [UIColor blackColor];
    
    // Strip leading # if there is one
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
        componentLength = 1;
    else if ([hexValue length] == 6)
        componentLength = 2;
    else
        return defaultResult;
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 256.0;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    UIColor *routeColor = [UIColor colorWithRed:components[0]
                                          green:components[1]
                                           blue:components[2]
                                          alpha:1.0];
    // correct color if it is too bright
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [routeColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (brightness > 0.75f) {
        brightness = 0.75f;
    }
    routeColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
   
    return routeColor;
}

+(UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}


+ (CAGradientLayer *)getGradientForColor:(UIColor*)color andFrame:(CGRect)frame
{
    NSArray *colors = [NSArray arrayWithObjects:(id)color.CGColor,
                       [UIColor darkerColorForColor:color].CGColor, nil];
    
    NSNumber *one = [NSNumber numberWithFloat:0.0f];
    NSNumber *two = [NSNumber numberWithFloat:0.9f];
    
    NSArray *locations = [NSArray arrayWithObjects:(id)one, two, nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    
    return gradientLayer;
}

@end
