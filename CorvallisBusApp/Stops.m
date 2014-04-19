//
//  Stops.m
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "Stops.h"

@implementation Stops

-(NSArray *)getStops
{
    return [self getStopsWithRadius:-1 withLimit:-1];
}

-(NSArray *)getStopsWithRadius:(int)radius
{
    return [self getStopsWithRadius:radius withLimit:-1];
}

-(NSArray *)getStopsWithRadius:(int)radius withLimit:(int)limit
{
    // --- Request bus stops from the server within this radius and limit ---
    // Default radius: 200m.  Default limit: none
    if (radius < 0)
        radius = 200;
    
    NSString *requesturl;
    if (limit < 0) {
        requesturl = [NSString stringWithFormat:@"http://www.corvallis-bus.appspot.com/stops?radius=%d", radius];
    } else {
        requesturl = [NSString stringWithFormat:@"http://www.corvallis-bus.appspot.com/stops?radius=%d&limit=%d", radius, limit];
    }
    
    NSArray *stops = nil;
    
    NSURL *url = [NSURL URLWithString:requesturl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"ERROR.  Response from server = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        return nil;
    }
    
    NSError *jsonError;
    stops = [[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&jsonError] objectForKey:@"stops"];
    if (jsonError != nil) {
        NSLog(@"JSON error while parsing stops from server");
        return nil;
    }
    
    // This is how to access stop data:
    //NSLog(@"First location - Lat: %f Long: %f",
    //      [[[stops objectAtIndex:0] objectForKey:@"Lat"] floatValue],
    //      [[[stops objectAtIndex:0] objectForKey:@"Long"] floatValue]);
    
    return stops;
}

@end
