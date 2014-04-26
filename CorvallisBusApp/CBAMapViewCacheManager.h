//
//  CBAMapViewCacheManager.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/26/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBAMapViewCacheManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *mapViewCache;

- (UIImage*)cachedImageForStopID:(NSString*)stopID andRoute:(NSString*)route;
- (BOOL)cachedImageExistsForStopID:(NSString*)stopID andRoute:(NSString*)route;
- (void)cacheImage:(UIImage*)mapViewImage forStopID:(NSString*)stopID andRoute:(NSString*)route;

- (void)loadSavedCache;
- (void)saveCache;

@end
