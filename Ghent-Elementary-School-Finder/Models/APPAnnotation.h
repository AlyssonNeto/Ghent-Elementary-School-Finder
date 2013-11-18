//
//  APPAnnotation.h
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface APPAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic) float lat;
@property (nonatomic) float lon;

@property (nonatomic,readwrite, copy) NSString *title;
@property (nonatomic,readwrite, copy) NSString *subtitle;


@property (nonatomic) NSInteger tag;

@end
