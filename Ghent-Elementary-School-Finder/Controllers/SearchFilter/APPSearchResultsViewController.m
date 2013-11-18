//
//  APPSearchResultsViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPSearchResultsViewController.h"

@interface APPSearchResultsViewController ()

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) NSMutableArray *tableData;

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation APPSearchResultsViewController

static BOOL haveAlreadyReceivedCoordinates;

-(id)initWithSchoolData:(NSMutableArray *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.delegate = self;
    self.dataSource = self;
    self.navigationItem.title = @"Schoolzoeker Gent";
    [self.locationManager startUpdatingLocation];
    haveAlreadyReceivedCoordinates = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), tableViewHeight - 49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    PHFRefreshControl *refreshControl = [PHFRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshSchools) forControlEvents:UIControlEventValueChanged];
    [_tableView setRefreshControl:refreshControl];
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), tableViewHeight - 49)];
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    self.mapView.delegate = self;
    
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
    region.center.latitude = [[[_data objectAtIndex:0] valueForKey:@"lat"] floatValue];
    region.center.longitude = [[[_data objectAtIndex:0] valueForKey:@"long"] floatValue];
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [self.mapView setRegion:region animated:YES];
    
    
    for (int i = 0; i < [_data count]; i++) {
        APPAnnotation *annotation = [[APPAnnotation alloc] init];
        annotation.lat = [[_data[i] valueForKey:@"lat"] floatValue];
        annotation.lon = [[_data[i] valueForKey:@"long"] floatValue];
        annotation.title = [_data[i] valueForKey:@"roepnaam"];
        annotation.subtitle = [_data[i] valueForKey:@"straat"];
        annotation.tag = i;
        [self.mapView addAnnotation:annotation];
    }
    
    [self.view addSubview:self.mapView];
    self.mapView.hidden = YES;
    self.mapView.showsUserLocation = YES;
    
    // show all annotations in region
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
}

-(void)refreshSchools {
    [[self.tableView refreshControl] beginRefreshing];
    haveAlreadyReceivedCoordinates = NO;
    [_locationManager startUpdatingLocation];
    [_tableView reloadData];
    [[self.tableView refreshControl] endRefreshing];
}

-(void)orderResponseDataByDistance {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _tableData = [NSMutableArray array];
        for (id school in _data) {
            CLLocation *restoLocation = [[CLLocation alloc] initWithLatitude:[[school objectForKey:@"lat"] floatValue] longitude:[[school objectForKey:@"long"] floatValue]];
            CLLocationDistance meters = [restoLocation distanceFromLocation:_location];
            [school setValue:[NSNumber numberWithInt:(int) meters] forKey:@"distance"];
        }
        
        [_data sortUsingComparator:^(id obj1, id obj2) {
            NSNumber *distance1 = [(NSDictionary *)obj1 objectForKey:@"distance"];
            NSNumber *distance2 = [(NSDictionary *)obj2 objectForKey:@"distance"];
            return [distance1 compare:distance2];
        }];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

#pragma mark - MKMapView Delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString * const identifier = @"Identifier";
    MKPinAnnotationView* annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView) {
        annotationView.annotation = annotation;
    }
    else {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    //annotationView.image = [UIImage imageNamed:@"location"];
    if (annotation == mapView.userLocation) {
        annotationView.pinColor = MKPinAnnotationColorGreen;
    }
    else {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    APPAnnotation *annotation = (APPAnnotation*)view.annotation;
    APPSchoolDetailViewController *schoolDetailVC = [[APPSchoolDetailViewController alloc] initWithDetailInformation:[_data objectAtIndex:annotation.tag]];
    [self.navigationController pushViewController:schoolDetailVC animated:YES];
}

#pragma mark - CLLocationManager Delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(!haveAlreadyReceivedCoordinates) {
        _location = [locations lastObject];
        [self orderResponseDataByDistance];
    }
    [self.locationManager stopUpdatingLocation];
    haveAlreadyReceivedCoordinates = YES;
}

#pragma mark - TableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    APPSchoolDetailViewController *schoolDetailVC = [[APPSchoolDetailViewController alloc] initWithDetailInformation:[_data objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:schoolDetailVC animated:YES];
}

#pragma mark - TableView DataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    APPSchoolCell *cell = (APPSchoolCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[APPSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setValues:[_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - ViewPager DataSource methods
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    if (index == 0) {
        imageView.image = [UIImage imageNamed:@"list"];
    }
    else {
        imageView.image = [UIImage imageNamed:@"location"];
    }
    return imageView;
}

#pragma mark - ViewPager Delegate methods
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator:
            return appColorBlue;
        default:
            return color;
    }
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    if (index == 0) {
        self.tableView.hidden = NO;
        self.mapView.hidden = YES;
    }
    else {
        self.tableView.hidden = YES;
        self.mapView.hidden = NO;
    }
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 0.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 1.0;
        default:
            return value;
    }
}

@end
