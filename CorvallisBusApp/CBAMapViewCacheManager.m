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

- (UIImage*)cachedImageForStopID:(NSString*)stopID
{
    NSLog(@"loading cached image for stop id %@", stopID);
    NSData *imageData = [self.mapViewCache objectForKey:stopID];
    return [UIImage imageWithData:imageData];
}

- (BOOL)cachedImageExistsForStopID:(NSString*)stopID
{
    return [self.mapViewCache objectForKey:stopID] != nil;
}

- (void)cacheImage:(UIImage*)mapViewImage forStopID:(NSString*)stopID
{
    NSLog(@"caching image for stop id %@", stopID);
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(mapViewImage)];
    [self.mapViewCache setObject:imageData forKey:stopID];
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
