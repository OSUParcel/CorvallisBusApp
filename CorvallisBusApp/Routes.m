//
//  Routes.m
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "Routes.h"

@implementation Routes

+(NSArray *)getRoutes
{
    // --- Request all routes from the server ---

    NSString *requesturl = [NSString stringWithFormat:@"http://www.corvallis-bus.appspot.com/routes"];

    NSArray *routes = nil;

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
    routes = [[NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:&jsonError] objectForKey:@"routes"];
    if (jsonError != nil) {
        NSLog(@"JSON error while parsing routes from server");
        return nil;
    }

    // This is how to access route data:
    //NSLog(@"First route - Name: %@ - Description: %@",
    //      [[self.routes objectAtIndex:0] objectForKey:@"AdditionalName"],
    //      [[self.routes objectAtIndex:0] objectForKey:@"Description"]);

    return routes;
}

@end
