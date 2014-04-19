//
//  BusData.h
//  CorvallisBusApp
//
//  Created by Russell Barnes on 4/19/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusData : NSObject

+(NSDictionary *)getArrivalsForLatitude:(float)lat Longitude:(float)lon;

@end
