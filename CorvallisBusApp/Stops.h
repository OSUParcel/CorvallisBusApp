//
//  Stops.h
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stops : NSObject

// Radii are in meters
-(NSArray *)getStops;
-(NSArray *)getStopsWithRadius:(int)radius;
-(NSArray *)getStopsWithRadius:(int)radius withLimit:(int)limit;

@end

