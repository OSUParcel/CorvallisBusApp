//
//  Arrivals.m
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "Arrivals.h"

@implementation Arrivals

+(NSDictionary *)getArrivalsForStops:(NSArray *)stops
{
    // --- Request all arrivals for given array of stops ---
    if (stops == nil || [stops count] <= 0) {
        NSLog(@"ERROR: no stops in array.");
        return nil;
    }
    
    NSMutableString *requesturl = [NSMutableString stringWithFormat:@"http://www.corvallis-bus.appspot.com/arrivals?stops="];
    
    // Add stop ID for each stop in array
    for (int i = 0; i < [stops count]; i++) {
        NSString *stopid = [NSString stringWithFormat:@"%@,", [[stops objectAtIndex:i] objectForKey:@"ID"]];
        [requesturl appendString:stopid];
    }
    // Chop off the last comma
    [requesturl deleteCharactersInRange:NSMakeRange([requesturl length]-1, 1)];
    NSLog(@"Request URL: %@", requesturl);//debug
    NSDictionary *arrivals = nil;
    
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
    arrivals = [NSJSONSerialization JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments
                                                error:&jsonError];
    if (jsonError != nil) {
        NSLog(@"JSON error while parsing routes from server");
        return nil;
    }
    
    return arrivals;
}

@end
