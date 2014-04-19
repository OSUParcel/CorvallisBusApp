//
//  Stops.m
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "Stops.h"

@implementation Stops

-(NSArray *)getStops:(int) radius
{
    // Request all bus stops from the server
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *request = [NSString stringWithFormat:@"http://www.corvallis-bus.appspot.com/stops?radius=%d", radius];
    
    [[session dataTaskWithURL:[NSURL URLWithString:request]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                // Parse JSON result and store in dictionary (self.stops)
                
                NSError *jsonError;
                self.stops = [[NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingAllowFragments
                                                                error:&jsonError] objectForKey:@"stops"];
                if (jsonError != nil) {
                    NSLog(@"JSON error while requesting stops from server");
                    return;
                }
                
                // This is how to access stop data:
                NSLog(@"First location - Lat: %f Long: %f",
                      [[[self.stops objectAtIndex:0] objectForKey:@"Lat"] floatValue],
                      [[[self.stops objectAtIndex:0] objectForKey:@"Long"] floatValue]);
                
                // Now, display all known points on the map:
                [self showStops];
            }
      ] resume];
}

@end
