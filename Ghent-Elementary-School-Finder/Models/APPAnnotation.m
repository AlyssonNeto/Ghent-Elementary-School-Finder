//
//  APPAnnotation.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPAnnotation.h"

@implementation APPAnnotation

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_lat, _lon);
}



@end



