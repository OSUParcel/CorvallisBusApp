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
 NSArray *data = [bus loadArrivalsForLatitude:44.57181000 Longitude:-123.2910000];
 
 Returns an NSArray of NSDictionaries:
 (
     {
         Arrival = NSDate
         Color = NSString
         Distance = NSNumber
         ID = NSString
         Lat = NSNumber
         Long = NSNumber
         Polyline = NSString
         Route = NSString
     },
     {
         Arrival = "2014-04-19 23:04:00 +0000";
         Color = F26521;
         Distance = "203.4869";
         ID = 10251;
         Lat = "44.56837";
         Long = "-123.2774";
         Polyline = (long string);
         Route = 3;
     },
     ...
 )
 
 */

@interface BusData : NSObject

-(NSArray *)loadArrivalsForLatitude:(float)lat Longitude:(float)lon;

@property (nonatomic, strong) NSArray *data;

@end
