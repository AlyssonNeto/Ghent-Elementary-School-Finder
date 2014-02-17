//
//  APPNavViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPNavViewController.h"

@interface APPNavViewController ()

@end

@implementation APPNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Schoollocator";
        [self.navigationBar setBarTintColor:NAVBARCOLOR];
        [self.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationBar setTranslucent:NO];
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:infoButton]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)showInfo {
    APPSearchResultsViewController *testVC = [[APPSearchResultsViewController alloc] initWithSchoolData:nil];
    [self.navigationController presentViewController:testVC animated:YES completion:nil];
}

@end
