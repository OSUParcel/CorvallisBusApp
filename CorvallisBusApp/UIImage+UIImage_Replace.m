//
//  UIImage+UIImage_Replace.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 5/7/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "UIImage+UIImage_Replace.h"
#import "UIColor+Hex.h"

@implementation UIImage (UIImage_Replace)

- (UIImage *)imageTintedWithColor:(UIColor *)color
{
	// This method is designed for use with template images, i.e. solid-coloured mask-like images.
	return [self imageTintedWithColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}


- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction
{
    UIImage *image;
    
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f);
    
    CGRect rect = CGRectZero;
    rect.size = [self size];
    
    [color set];
    UIRectFill(rect);
    
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];

    if (fraction > 0.0) {
        [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
    }
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




@end