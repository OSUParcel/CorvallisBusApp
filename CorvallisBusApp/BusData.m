//
//  BusData.m
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "BusData.h"
#import "Stops.h"
#import "Routes.h"
#import "Arrivals.h"

@interface BusData()

@end

@implementation BusData

-(NSArray *)loadArrivalsForLatitude:(float)lat Longitude:(float)lon
{
    NSArray *stops = [Stops getStopsWithRadius:500 lat:lat lon:lon];
    NSDictionary *arrivals = [Arrivals getArrivalsForStops:stops];
    NSArray *routes = [Routes getRoutes];
    NSMutableArray *sortedStops = [[NSMutableArray alloc] init];
    
    // For each stop, add the lat & long for the corresponding ID key
    for (int i = 0; i < [stops count]; i++) {
        NSString *stopid = [NSString stringWithFormat:@"%@", [[stops objectAtIndex:i] objectForKey:@"ID"]];
        
        // Skip if there are no upcoming arrivals
        if ([[arrivals objectForKey:stopid] count] <= 0)
            continue;
        
        NSNumber *distance = [NSNumber numberWithFloat: [[[stops objectAtIndex:i] objectForKey:@"Distance"] floatValue]];
        NSNumber *latitude = [NSNumber numberWithFloat: [[[stops objectAtIndex:i] objectForKey:@"Lat"] floatValue]];
        NSNumber *longitude = [NSNumber numberWithFloat: [[[stops objectAtIndex:i] objectForKey:@"Long"] floatValue]];
        NSNumber *bearing = [NSNumber numberWithFloat: [[[stops objectAtIndex:i] objectForKey:@"Bearing"] floatValue]];
        NSString *name = [NSString stringWithFormat:@"%@", [[stops objectAtIndex:i] objectForKey:@"Name"]];;
        
        // Find out the route name and color
        NSString *route = [[[arrivals objectForKey:stopid] objectAtIndex:0] objectForKey:@"Route"];
        int j = 0;
        for (j = 0; j < [routes count]; j++) {
            NSString *route2 = [[routes objectAtIndex:j] objectForKey:@"Name"];
            if ([route isEqualToString:route2])
                break;
        }
        NSString *color = [[routes objectAtIndex:j] objectForKey:@"Color"];
        NSString *polyline = [[routes objectAtIndex:j] objectForKey:@"Polyline"];
        
        // Convert the string to an NSDate
        NSDateFormatter *dateFromServerFormatter;
        NSDate *dateOfLocation;
        NSString *dateString;
        
        dateFromServerFormatter = [[NSDateFormatter alloc] init];
        assert(dateFromServerFormatter != nil);
        
        // Format: "15 Apr 14 16:57 -0700"
        [dateFromServerFormatter setDateFormat:@"dd MMM yy HH:mm z"];
        [dateFromServerFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-(3600*7)]];
        
        dateString = [[[arrivals objectForKey:stopid] objectAtIndex:0] objectForKey:@"Expected"];
        dateOfLocation = [dateFromServerFormatter dateFromString:dateString];
        
        // Add this information to a new element in the list
        NSDictionary *stop = [NSDictionary dictionaryWithObjectsAndKeys:
                              stopid, @"ID",
                              name, @"Name",
                              distance, @"Distance",
                              dateOfLocation, @"Arrival",
                              route, @"Route",
                              color, @"Color",
                              bearing, @"Bearing",
                              polyline, @"Polyline",
                              latitude, @"Lat",
                              longitude, @"Long",
                              nil];
        
        [sortedStops addObject:stop];
    }
    self.data = [NSArray arrayWithArray:sortedStops];
    return self.data;
}

-(NSArray *)loadScheduleForStop:(NSString *)stop
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:stop, @"ID", nil];
    NSArray *stopArr = [NSArray arrayWithObjects:dict,nil];
    
    NSDictionary *arrivals = [Arrivals getArrivalsForStops:stopArr];
    
    //NSLog(@"Arrivals for stop: %@", [arrivals objectForKey:stop]);
    
    NSMutableArray *schedule = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [arrivals count]; i++) {
        
        // Convert the strings to NSDates
        NSDateFormatter *dateFromServerFormatter;
        
        dateFromServerFormatter = [[NSDateFormatter alloc] init];
        assert(dateFromServerFormatter != nil);
        
        // Format: "15 Apr 14 16:57 -0700"
        [dateFromServerFormatter setDateFormat:@"dd MMM yy HH:mm z"];
        [dateFromServerFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-(3600*7)]];
        
        NSString *expected = [[[arrivals objectForKey:stop] objectAtIndex:i] objectForKey:@"Expected"];
        NSDate *dateOfExpected = [dateFromServerFormatter dateFromString:expected];
        
        NSString *scheduled = [[[arrivals objectForKey:stop] objectAtIndex:i] objectForKey:@"Scheduled"];
        NSDate *dateOfScheduled = [dateFromServerFormatter dateFromString:scheduled];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              dateOfExpected, @"Expected",
                              dateOfScheduled, @"Scheduled",
                              nil];
        [schedule addObject:dict];
    }
    return [NSArray arrayWithArray:schedule];
}

@end
