//
//  APPSecondarySearchFilterViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPSecondarySearchFilterViewController.h"


@interface APPSecondarySearchFilterViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *searchTermTextField;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *filteredData;


@property (strong, nonatomic) NSArray *searchOfferCriteria;
@property (strong, nonatomic) NSMutableArray *searchSelectedOfferCriteria;

@property (strong, nonatomic) MBProgressHUD *hud;

enum SearchPossibilitiesSecondary {
    kSearchTerm = 0
};

@end

@implementation APPSecondarySearchFilterViewController

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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), tableViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = appColorBackground;
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 70)];
    UIButton *searchBtn = [KHFlatButton buttonWithFrame:CGRectMake(10, 0, 300, 50) withTitle:@"Zoeken" backgroundColor:appColorGreen];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:searchBtn];
    self.tableView.tableFooterView = footerView;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard {
    [self.searchTermTextField resignFirstResponder];
}

- (void) search {
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self.hud.labelText = @"Scholen zoeken..";
    [self.hud show:YES];
    [self.navigationController.view addSubview:self.hud];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[APPApiClient sharedClient] getPath:@"Onderwijs&Opvoeding/SecundaireScholen.json" getParameters:nil getEndpointWithcompletion:^(NSArray *results, NSError *error) {
        self.hud.mode = MBProgressHUDModeCustomView;
        if (!error) {
            _data = [NSMutableArray array];
            
            for (id school in results) {
                NSMutableArray *schoolDict = [school mutableCopy];
                [schoolDict setValue:nil forKey:@"distance"];
                [_data addObject:schoolDict];
            }
            self.filteredData = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [_data count]; i++) {
                if ([self.searchTermTextField.text isEqualToString:@""]) {
                    [_filteredData addObject:[_data objectAtIndex:i]];
                }
                else if ([[[[_data objectAtIndex:i] valueForKey:@"naam"] lowercaseString] rangeOfString:[self.searchTermTextField.text lowercaseString]].location != NSNotFound) {
                    [_filteredData addObject:[_data objectAtIndex:i]];
                }
            }
            
            if ([self.filteredData count] > 0) {
                self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                if ([self.filteredData count] == 1) {
                    self.hud.labelText = @"1 school gevonden!";
                }
                else {
                    self.hud.labelText = [NSString stringWithFormat:@"%i scholen gevonden!", [_filteredData count]];
                }
                
                APPSearchResultsViewController *searchResultsVC = [[APPSearchResultsViewController alloc] initWithSchoolData:self.filteredData];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
                [self.navigationController pushViewController:searchResultsVC animated:YES];
            }
            else {
                [self.hud hide:YES];
                [[[UIAlertView alloc] initWithTitle:@"Geen scholen gevonden" message:@"Er konden geen scholen gevonden worden met dit zoekcriteria" delegate:self cancelButtonTitle:@"Oke" otherButtonTitles:nil] show];
            }
        }
        else {
            NSLog(@"Error: %@", error);
            self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exclamationmark"]];
            self.hud.labelText = @"Er ging iets mis..";
            self.hud.detailsLabelText = @"Is er een internetverbinding?";
        }
        [self.hud hide:YES afterDelay:1];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark TableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark TableView DataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == kSearchTerm) return @"IN DE BUURT";
    else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSearchTerm) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    
    if (indexPath.section == kSearchTerm) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.searchTermTextField = (UITextField *)[cell.contentView viewWithTag:1];
            
            if (!self.searchTermTextField) {
                self.searchTermTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CENTER_IN_PARENT_Y(cell.contentView, 35), 290, 35)];
            }
            self.searchTermTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.searchTermTextField.delegate = self;
            self.searchTermTextField.placeholder = @"Zoekterm";
            self.searchTermTextField.tag = 1;
            [cell.contentView addSubview:self.searchTermTextField];
        }
    }
    return cell;
}
@end
