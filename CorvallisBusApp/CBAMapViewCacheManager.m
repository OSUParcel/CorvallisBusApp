//
//  CBAMapViewCacheManager.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/26/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBAMapViewCacheManager.h"

@implementation CBAMapViewCacheManager

@synthesize mapViewCache;

- (CBAMapViewCacheManager*)init
{
    self = [super init];
    if (self) {
        self.mapViewCache = [NSMutableDictionary new];
    }
    return self;
}

- (UIImage*)cachedImageForStopID:(NSString*)stopID andRoute:(NSString*)route
{
    NSLog(@"loading cached image for stop id %@ and route %@", stopID, route);
    NSString *key = [NSString stringWithFormat:@"%@-%@", stopID, route];
    NSData *imageData = [self.mapViewCache objectForKey:key];
    return [UIImage imageWithData:imageData];
}

- (BOOL)cachedImageExistsForStopID:(NSString*)stopID andRoute:(NSString*)route
{
    NSString *key = [NSString stringWithFormat:@"%@-%@", stopID, route];
    return [self.mapViewCache objectForKey:key] != nil;
}

- (void)cacheImage:(UIImage*)mapViewImage forStopID:(NSString*)stopID andRoute:(NSString*)route
{
    NSLog(@"caching image for stop id %@ and route %@", stopID, route);
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(mapViewImage)];
    NSString *key = [NSString stringWithFormat:@"%@-%@", stopID, route];
    [self.mapViewCache setObject:imageData forKey:key];
}

# pragma mark - core data functions

- (void)loadSavedCache
{
    // TODO
}

- (void)saveCache
{
   // TODO
}

@end
