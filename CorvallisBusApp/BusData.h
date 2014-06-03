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
 // Array is also saved to bus.data
 
 Returns an NSArray of NSDictionaries:
 (
     {
         Arrival = NSDate
         Bearing = NSNumber
         Color = NSString
         Distance = NSNumber
         ID = NSString
         Lat = NSNumber
         Long = NSNumber
         Name = NSString
         Polyline = NSString
         Route = NSString
     },
     {
         Arrival = "2014-04-19 23:04:00 +0000";
         Bearing = 181.3342;
         Color = F26521;
         Distance = "203.4869";
         ID = 10251;
         Lat = "44.56837";
         Long = "-123.2774";
         Name = "Harrison & 23rd";
         Polyline = (long string);
         Route = 3;
     },
     ...
 )
 
 */

@interface BusData : NSObject

-(NSArray *)loadArrivalsForLatitude:(CGFloat)lat Longitude:(CGFloat)lon;
-(NSArray *)loadScheduleForStop:(NSString *)stop;

@property (nonatomic, strong) NSArray *data;

@end
