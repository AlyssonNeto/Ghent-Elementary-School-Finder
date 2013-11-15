//
//  APPSearchFilterViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPSearchFilterViewController.h"


@interface APPSearchFilterViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *searchTermTextField;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *filteredData;


@property (strong, nonatomic) NSArray *searchOfferCriteria;
@property (strong, nonatomic) NSMutableArray *searchSelectedOfferCriteria;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation APPSearchFilterViewController

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
    
    self.searchOfferCriteria = @[@"Basisschool (Kleuter + Lager)", @"Kleuterschool", @"Buitengewoon onderwijs", @"Lagere school", @"LO", @"KO"];
    self.searchSelectedOfferCriteria = [[NSMutableArray alloc] init];
    
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
    
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = @"data-schools.plist";
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    self.data = [NSMutableArray arrayWithContentsOfFile:path];
}

-(void)showInfo {
    
}

- (void) hideKeyboard {
    [self.searchTermTextField resignFirstResponder];
}

- (void) search {
    if ([self.searchTermTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Geen zoekterm" message:@"Gelieve een zoekterm in te vullen aub" delegate:self cancelButtonTitle:@"Oke" otherButtonTitles:nil] show];
    }
    else if ([self.searchSelectedOfferCriteria count]  == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Geen aanbod" message:@"Gelieve een aanbod aan te duiden aub" delegate:self cancelButtonTitle:@"Oke" otherButtonTitles:nil] show];
    }
    else {
        self.filteredData = [[NSMutableArray alloc] init];
        NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchNetwork"];

        if (_data) {
            for (int i = 0; i < [_data count]; i++) {
                if ([[[[_data objectAtIndex:i] valueForKey:@"roepnaam"] lowercaseString] rangeOfString:[self.searchTermTextField.text lowercaseString]].location != NSNotFound) {
                    if ([[[_data objectAtIndex:i] valueForKey:@"net"] isEqualToString:network]) {
                        if ([self.searchSelectedOfferCriteria containsObject:[[_data objectAtIndex:i] valueForKey:@"aanbod"]]) {
                            [_filteredData addObject:[_data objectAtIndex:i]];
                        }
                    }
                }
            }
        }
        
        if ([self.filteredData count] > 0) {
            APPSearchResultsViewController *searchResultsVC = [[APPSearchResultsViewController alloc] initWithSchoolData:self.filteredData];
            [self.navigationController pushViewController:searchResultsVC animated:YES];
        }
        else {
           [[[UIAlertView alloc] initWithTitle:@"Geen scholen gevonden" message:@"Er konden geen scholen gevonden worden met dit zoekcriteria" delegate:self cancelButtonTitle:@"Oke" otherButtonTitles:nil] show];
        }
    }
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == kSearchTerm) return @"IN DE BUURT";
    else if (section == kSearchOffer) return @"AANBOD";
    else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSearchTerm) {
        return 2;
    }
    else if (section == kSearchOffer) {
        return 6;
    }
    return 1;
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
            
            self.searchTermTextField.delegate = self;
            self.searchTermTextField.placeholder = @"Zoekterm";
            self.searchTermTextField.tag = 1;
            [cell.contentView addSubview:self.searchTermTextField];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Net";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchNetwork"];
        }
    }
    
    else if(indexPath.section == kSearchOffer) {
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
