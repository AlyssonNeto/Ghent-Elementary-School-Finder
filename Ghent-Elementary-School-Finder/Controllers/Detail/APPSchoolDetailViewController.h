//
//  APPSchoolDetailViewController.h
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <KHFlatButton/KHFlatButton.h>
#import "APPAnnotation.h"

@interface APPSchoolDetailViewController : UIViewController <UIScrollViewDelegate, MKMapViewDelegate>

-(id)initWithDetailInformation:(NSArray *)detailInfo;

@end
