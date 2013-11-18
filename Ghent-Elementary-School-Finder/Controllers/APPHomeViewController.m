//
//  APPHomeViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPHomeViewController.h"
#import <KHFlatButton/KHFlatButton.h>
#import "APPSearchFilterViewController.h"

@interface APPHomeViewController ()

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation APPHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Schoolzoeker Gent";
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
     self.hud.labelText = @"De data wordt geüpdatet...";
     [self.hud show:YES];
     [self.navigationController.view addSubview:self.hud];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     
     NSString *documentsDirectory = nil;
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     documentsDirectory = [paths objectAtIndex:0];
     NSString *filename = @"data-schools.plist";
     NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
     
     
     [[APPApiClient sharedClient] getPath:@"Onderwijs&Opvoeding/Basisscholen.json" getParameters:nil getEndpointWithcompletion:^(NSArray *results, NSError *error) {
     self.hud.mode = MBProgressHUDModeCustomView;
     if (!error) {
     self.data = [NSMutableArray arrayWithArray:results];
     self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
     self.hud.labelText = @"De data is geupdate!";
     
     [self.data writeToFile:path atomically:YES];
     }
     else {
     NSLog(@"Error: %@", error);
     self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exclamationmark"]];
     self.hud.labelText = @"De data is niet geupdate";
     }
     [self.hud hide:YES afterDelay:1];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     }];*/
    
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 290, 400)];
    infoLabel.text = @"Mauris in faucibus lorem. Etiam ac tellus interdum, scelerisque odio nec, facilisis mi. Praesent porttitor massa at quam convallis interdum. Etiam tempus accumsan tincidunt. Pellentesque dictum mi a sollicitudin venenatis. Donec pulvinar urna in lobortis dapibus. Nulla consequat ipsum vel dolor lacinia, eu pulvinar ante luctus. Nulla et magna fringilla, facilisis risus adipiscing, hendrerit ligula.";
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [infoLabel sizeToFit];
    [self.view addSubview:infoLabel];
    
    UIButton *startBtn = [KHFlatButton buttonWithFrame:CGRectMake(CENTER_IN_PARENT_X(self.view, 300), BOTTOM(infoLabel) + 20, 300, 50) withTitle:@"Start" backgroundColor:appColorGreen];
    [startBtn addTarget:self action:@selector(openSearchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

-(void)openSearchView {
    APPSearchFilterViewController *searchFilterVC = [[APPSearchFilterViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:searchFilterVC animated:YES];
}

@end
