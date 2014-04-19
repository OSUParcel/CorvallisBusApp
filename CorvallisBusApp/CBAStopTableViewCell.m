//
//  CBAStopTableViewCell.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAStopTableViewCell.h"

@implementation CBAStopTableViewCell

@synthesize tapGestureRecognizer;

@synthesize isFullScreen;

- (void)awakeFromNib
{
    // dont clip
    self.clipsToBounds = NO;
    self.superview.clipsToBounds = NO;
    
    // init gesture recognizer
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateToFullScreen:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    // map view setup
    self.isFullScreen = NO;
    [self.mapView setMyLocationEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)animateToFullScreen:(UITapGestureRecognizer*)sender
{
    if (!self.isFullScreen) {
        self.isFullScreen = YES;
        // animate map to full screen
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0f animations:^{
                self.mapView.frame = [[UIScreen mainScreen] applicationFrame];
                self.mapView.bounds = [[UIScreen mainScreen] bounds];
            }];
        });
    }
}

@end
