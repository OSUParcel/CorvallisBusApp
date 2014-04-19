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

@implementation BusData

+(NSDictionary *)getArrivalsForLatitude:(float)lat Longitude:(float)lon
{
    //corvallis-bus.appspot.com/stops?lat=44.57181000&lng=-123.2910000&radius=200&limit=1
    return [Arrivals getArrivalsForStops:[Stops getStopsWithRadius:500 lat:lat lon:lon]];
}

@end
