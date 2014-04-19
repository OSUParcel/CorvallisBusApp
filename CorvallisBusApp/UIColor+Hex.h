//
//  UIColor+Hex.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor*)colorWithHexValue:(NSString*)hexValue;
+(UIColor *)darkerColorForColor:(UIColor *)c;

@end
