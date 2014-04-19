//
//  BusData.h
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Usage:
 
 #include "BusData.h"
 BusData *bus = [[BusData alloc] init];
 NSLog(@"Arrivals: %@", [bus loadArrivalsForLatitude:44.57181000 Longitude:-123.2910000]);
 
 */

@interface BusData : NSObject

-(NSArray *)loadArrivalsForLatitude:(float)lat Longitude:(float)lon;

@end
