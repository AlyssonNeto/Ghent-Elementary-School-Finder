//
//  APPPrimarySearchFilterViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPPrimarySearchFilterViewController.h"

@interface APPPrimarySearchFilterViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *searchTermTextField;

@property (strong, nonatomic) NSMutableArray *filteredData;
@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) NSArray *searchOfferCriteria;
@property (strong, nonatomic) NSMutableArray *searchSelectedOfferCriteria;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic) NSInteger tag;

enum SearchPossibilitiesPrimary {
    kSearchTerm = 0,
    kSearchOffer
};

//enum Search

@end

@implementation APPPrimarySearchFilterViewController

-(id)initWithTag:(NSInteger)tag {
    self = [super init];
    if (self) {
        _tag = tag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Schoollocator";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchOfferCriteria = @[@"Kleuterschool", @"Lagere school", @"Basisschool (Kleuter + Lager)", @"Buitengewoon onderwijs"];
    self.searchSelectedOfferCriteria = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), tableViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 70)];
    
    UIButton *searchBtn = [KHFlatButton buttonWithFrame:CGRectMake(10, 10, 300, 50) withTitle:@"ZOEKEN" backgroundColor:GREEN];
    searchBtn.titleLabel.font = [UIFont fontWithName:AVENIR_BLACK size:20];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:searchBtn];
    
    self.tableView.tableFooterView = footerView;
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 40;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}
- (void) hideKeyboard {
    [self.searchTermTextField resignFirstResponder];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, CENTER_IN_PARENT_Y(view, 36), tableView.frame.size.width, 36)];
    [label setFont:[UIFont fontWithName:AVENIR_BLACK size:20]];
    if (section == 0) {
        [label setText:@"IN DE BUURT"];
    }
    else {
        [label setText:@"AANBOD"];
        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, TOP(view), WIDTH(self.view), 1)];
        lineTop.backgroundColor = GREEN;
        [view addSubview:lineTop];
    }
    
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOM(view), WIDTH(self.view), 1)];
    lineBottom.backgroundColor = GREEN;
    [view addSubview:lineBottom];
    
    label.textColor = GREEN;
    
    [view addSubview:label];
    return view;
}

- (void) search {
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self.hud.labelText = @"Scholen zoeken..";
    [self.hud show:YES];
    [self.navigationController.view addSubview:self.hud];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[APPApiClient sharedClient] getPath:@"Onderwijs&Opvoeding/Basisscholen.json" getParameters:nil getEndpointWithcompletion:^(NSArray *results, NSError *error) {
        self.hud.mode = MBProgressHUDModeCustomView;
        if (!error) {
            _data = [NSMutableArray array];
            
            for (id school in results) {
                NSMutableArray *schoolDict = [school mutableCopy];
                [schoolDict setValue:nil forKey:@"distance"];
                [_data addObject:schoolDict];
            }
            
            self.filteredData = [[NSMutableArray alloc] init];
            NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchNetwork"];
            
            for (int i = 0; i < [_data count]; i++) {
                NSRange range = [[[[_data objectAtIndex:i] valueForKey:@"roepnaam"] lowercaseString] rangeOfString:[self.searchTermTextField.text lowercaseString]];
                if ([self.searchTermTextField.text isEqualToString:@""]) {
                    [_filteredData addObject:[_data objectAtIndex:i]];
                }
                else if (range.location != NSNotFound) {
                    [_filteredData addObject:[_data objectAtIndex:i]];
                }
            }
            
            NSMutableArray *step2 = [[NSMutableArray alloc] initWithArray:_filteredData];
            
            for (NSDictionary *school in _filteredData) {
                if (![network isEqualToString:@"Alles"]) {
                    if (![[school valueForKey:@"net"] isEqualToString:network]) {
                        [step2 removeObject:school];
                    }
                }
            }
            
            NSMutableArray *step3 = [[NSMutableArray alloc] initWithArray:step2];
            
            for (NSDictionary *school in step2) {
                if ([self.searchSelectedOfferCriteria count] != 0) {
                    if (![self.searchSelectedOfferCriteria containsObject:[school valueForKey:@"aanbod"]]) {
                        [step3 removeObject:school];
                    }
                }
            }
            
            if ([step3 count] > 0) {
                self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                if ([step3 count] == 1) {
                    self.hud.labelText = @"1 school gevonden!";
                }
                else {
                    self.hud.labelText = [NSString stringWithFormat:@"%i scholen gevonden!", [step3 count]];
                }
                
                APPSearchResultsViewController *searchResultsVC = [[APPSearchResultsViewController alloc] initWithSchoolData:step3];
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

-(void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}

#pragma mark TableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSearchTerm) {
        if (indexPath.row == 1) {
            APPSearchNetworkViewController *searchNetworkVC = [[APPSearchNetworkViewController alloc] initWithNibName:nil bundle:nil];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:searchNetworkVC animated:YES];
        }
    }
    else if (indexPath.section == kSearchOffer) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([_searchSelectedOfferCriteria containsObject:cell.textLabel.text]) {
            [_searchSelectedOfferCriteria removeObject:cell.textLabel.text];
        }
        else {
            [_searchSelectedOfferCriteria addObject:[_searchOfferCriteria objectAtIndex:indexPath.row]];
        }
    }
    [_tableView reloadData];
}

#pragma mark TableView DataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == kSearchTerm) return @"IN DE BUURT";
//    else if (section == kSearchOffer) return @"AANBOD";
//    else return @"";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kSearchTerm) {
        return 2;
    }
    else if (section == kSearchOffer) {
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        cell.textLabel.font = [UIFont fontWithName:AVENIR_ROMAN size:16];
        cell.detailTextLabel.font = [UIFont fontWithName:AVENIR_ROMAN size:16];
        cell.detailTextLabel.textColor = CELL_DETAIL_TEXTCOLOR;
    }
    
    if (indexPath.section == kSearchTerm) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.searchTermTextField = (UITextField *)[cell.contentView viewWithTag:1];
            
            if (!self.searchTermTextField) {
                self.searchTermTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CENTER_IN_PARENT_Y(cell, 35) + 2, 290, 35)];
            }
            self.searchTermTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.searchTermTextField.delegate = self;
            self.searchTermTextField.placeholder = @"Zoekterm";
            self.searchTermTextField.tag = 1;
            self.searchTermTextField.font = [UIFont fontWithName:AVENIR_ROMAN size:16];
            self.searchTermTextField.textColor = CELL_DETAIL_TEXTCOLOR;
            [cell.contentView addSubview:self.searchTermTextField];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Net";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchNetwork"];
        }
    }
    else if(indexPath.section == kSearchOffer) {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"red"];
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"blue"];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"green"];
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"brown"];
                break;
            default:
                cell.imageView.image = nil;
                break;
        }
        
        cell.textLabel.text = [self.searchOfferCriteria objectAtIndex:indexPath.row];
        if ([_searchSelectedOfferCriteria containsObject:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

@end
