//
//  APPSearchFilterViewController.h
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <KHFlatButton/KHFlatButton.h>
#import <AFNetworking/AFNetworking.h>
#import "APPSearchNetworkViewController.h"
#import "APPSearchResultsViewController.h"

@interface APPSearchFilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MBProgressHUDDelegate>

enum SearchPossibilities {
    kSearchTerm = 0,
    kSearchOffer,
    kSearchNetwork
};

@end
