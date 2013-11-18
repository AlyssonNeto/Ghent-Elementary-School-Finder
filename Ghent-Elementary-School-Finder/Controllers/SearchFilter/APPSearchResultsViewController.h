//
//  APPSearchResultsViewController.h
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <PHFRefreshControl/PHFRefreshControl.h>
#import <MapKit/MapKit.h>
#import "APPSchoolCell.h"
#import "APPSchoolDetailViewController.h"
#import "APPAnnotation.h"


@interface APPSearchResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate>

-(id)initWithSchoolData:(NSMutableArray *)data;

@end
