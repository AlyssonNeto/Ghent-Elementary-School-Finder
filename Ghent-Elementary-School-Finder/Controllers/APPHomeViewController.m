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
    self.navigationItem.title = @"Schoolzoeker Gent";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 290, 400)];
    infoLabel.text = @"Mauris in faucibus lorem. Etiam ac tellus interdum, scelerisque odio nec, facilisis mi. Praesent porttitor massa at quam convallis interdum. Etiam tempus accumsan tincidunt. Pellentesque dictum mi a sollicitudin venenatis. Donec pulvinar urna in lobortis dapibus. Nulla consequat ipsum vel dolor lacinia, eu pulvinar ante luctus. Nulla et magna fringilla, facilisis risus adipiscing, hendrerit ligula.";
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [infoLabel sizeToFit];
    [self.view addSubview:infoLabel];
    
    UIButton *primaryBtn = [KHFlatButton buttonWithFrame:CGRectMake(CENTER_IN_PARENT_X(self.view, 300), BOTTOM(infoLabel) + 20, 300, 50) withTitle:@"Basisscholen" backgroundColor:appColorGreen];
    [primaryBtn addTarget:self action:@selector(openPrimarySearchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:primaryBtn];
    
    UIButton *secondaryBtn = [KHFlatButton buttonWithFrame:CGRectMake(CENTER_IN_PARENT_X(self.view, 300), BOTTOM(primaryBtn) + 20, 300, 50) withTitle:@"Secundaire scholen" backgroundColor:appColorGreen];
    [secondaryBtn addTarget:self action:@selector(openSecondarySearchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondaryBtn];
}

-(void)openPrimarySearchView {
    APPPrimarySearchFilterViewController *searchFilterVC = [[APPPrimarySearchFilterViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:searchFilterVC animated:YES];
}

-(void)openSecondarySearchView {
    APPSecondarySearchFilterViewController *searchFilterVC = [[APPSecondarySearchFilterViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:searchFilterVC animated:YES];
}

@end
