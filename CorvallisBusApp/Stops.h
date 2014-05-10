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
+(NSArray *)getStops;
+(NSArray *)getStopsWithRadius:(int)radius lat:(float)lat lon:(float)lon;
+(NSArray *)getStopsWithRadius:(int)radius lat:(float)lat lon:(float)lon withLimit:(int)limit;

/*
 Example:
 NSArray *routes = [Routes getRoutes];
 NSArray *stops = [Stops getStopsForRoute:[[routes objectAtIndex:i] objectForKey:@"Name"]];
 
 NSLog(@"Route latitude: %@", [[stops objectAtIndex:0] objectForKey:@"Lat"]);
 */
+(NSArray *)getStopsForRoute:(NSString *)route;

@end

