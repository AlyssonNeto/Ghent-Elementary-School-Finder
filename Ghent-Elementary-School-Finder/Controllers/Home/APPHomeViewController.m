//
//  APPHomeViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPHomeViewController.h"
#import "APPPrimarySearchFilterViewController.h"
#import "APPSecondarySearchFilterViewController.h"

#import "APPSchoolCategoryButton.h"

#define MARGIN_LEFT 20
#define MARGIN_FIRST_ITEM_TOP 70
#define MARGIN_BOTTOM 20

#define MARGIN_LEFT_BUTTON 70

#define LINE_HEIGHT 10

#define CUSTOM_HEIGHT_BUTTON 50
#define CUSTOM_WIDTH_BUTTON WIDTH(self.view) - MARGIN_LEFT_BUTTON

@interface APPHomeViewController ()

@end

@implementation APPHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Schoollocator";
    
    UIImageView *imageView;
    
    if (HEIGHT(self.view) > 480) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_FIRST_ITEM_TOP, 280, 57)];
    }
    else {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_FIRST_ITEM_TOP, 280, 57)];
    }
    
    imageView.image = [UIImage imageNamed:@"schoollocator_logo"];
    [self.view addSubview:imageView];
    
    APPSchoolCategoryButton *kleuter_btn = [[APPSchoolCategoryButton alloc] initWithFrame:CGRectMake(MARGIN_LEFT_BUTTON/2, BOTTOM(imageView) + MARGIN_BOTTOM * 2, CUSTOM_WIDTH_BUTTON, CUSTOM_HEIGHT_BUTTON) andTitle:@"kleuter- en basisscholen" andImage:[UIImage imageNamed:@"basis_lager_icon"]];
    kleuter_btn.tag = 1;
    [kleuter_btn addTarget:self action:@selector(openSchoolCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kleuter_btn];
    
//    APPSchoolCategoryButton *lager_btn = [[APPSchoolCategoryButton alloc] initWithFrame:CGRectMake(MARGIN_LEFT_BUTTON, BOTTOM(kleuter_btn) + MARGIN_BOTTOM, CUSTOM_WIDTH_BUTTON, CUSTOM_HEIGHT_BUTTON) andTitle:@"basisscholen" andImage:[UIImage imageNamed:@"lager_icon"]];
//    lager_btn.tag = 2;
//    [lager_btn addTarget:self action:@selector(openSchoolCategory:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:lager_btn];
    
    APPSchoolCategoryButton *middelbaar_btn = [[APPSchoolCategoryButton alloc] initWithFrame:CGRectMake(MARGIN_LEFT_BUTTON/2, BOTTOM(kleuter_btn) + MARGIN_BOTTOM * 2, CUSTOM_WIDTH_BUTTON, CUSTOM_HEIGHT_BUTTON) andTitle:@"secundaire scholen" andImage:[UIImage imageNamed:@"middelbaar_icon"]];
    middelbaar_btn.tag = 3;
    [middelbaar_btn addTarget:self action:@selector(openSchoolCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:middelbaar_btn];
    
//    APPSchoolCategoryButton *univ_btn = [[APPSchoolCategoryButton alloc] initWithFrame:CGRectMake(MARGIN_LEFT_BUTTON, BOTTOM(middelbaar_btn) + MARGIN_BOTTOM, CUSTOM_WIDTH_BUTTON, CUSTOM_HEIGHT_BUTTON) andTitle:@"hogescholen en universiteiten" andImage:[UIImage imageNamed:@"univ_icon"]];
//    univ_btn.tag = 4;
//    [univ_btn addTarget:self action:@selector(openSchoolCategory:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:univ_btn];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(self.view) - LINE_HEIGHT - NAVBAR_HEIGHT, WIDTH(self.view), LINE_HEIGHT)];
    view.backgroundColor = GREEN;
    [self.view addSubview:view];
}

-(void)openSchoolCategory:(APPSchoolCategoryButton *)sender {
    UIViewController *viewController = nil;
    
    switch (sender.tag) {
        case 1:
            viewController = [[APPPrimarySearchFilterViewController alloc] initWithTag:sender.tag];
            break;
        case 2:
            viewController = [[APPPrimarySearchFilterViewController alloc] initWithTag:sender.tag];
            break;
        case 3:
            viewController = [[APPSecondarySearchFilterViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 4:
            NSLog(@"univ");
            break;
        default:
            break;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
