//
//  CBAStopAnnotation.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/26/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CBAStopAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *stopID;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
