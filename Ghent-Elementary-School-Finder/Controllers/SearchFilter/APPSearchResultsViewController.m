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

@property (strong, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) UIButton *listButton;
@property (strong, nonatomic) UIButton *mapButton;

@property (nonatomic) NSInteger idSchool;

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

    UIImageView *showCurrentLocation = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 25, 25)];
    showCurrentLocation.image = [UIImage imageNamed:@"currentLocation"];
    showCurrentLocation.tintColor = [UIColor whiteColor];
    [self.mapView addSubview:showCurrentLocation];
    
    UIButton *showCurrentLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
    [showCurrentLocationBtn addTarget:self action:@selector(showCurrentPos) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:showCurrentLocationBtn];

    self.mapView.hidden = YES;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOM(self.tableView), WIDTH(self.view), 49)];
    footerView.backgroundColor = appColorBackground;
    
    self.listButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view) / 2, 49)];
    [self.listButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateSelected];
    [self.listButton setImage:[UIImage imageNamed:@"list-inactive"] forState:UIControlStateNormal];
    self.listButton.selected = YES;
    [self.listButton addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    
    self.mapButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self.view)/2, 0, WIDTH(self.view) / 2, 49)];
    [self.mapButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateSelected];
    [self.mapButton setImage:[UIImage imageNamed:@"location-inactive"] forState:UIControlStateNormal];
    [self.mapButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:self.listButton];
    [footerView addSubview:self.mapButton];
    
    [self.view addSubview:footerView];
}

-(void)showCurrentPos {
    MKCoordinateRegion mapRegion;
    mapRegion.center = _location.coordinate;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    [self.mapView setRegion:mapRegion animated: YES];
}

-(void)showList {
    self.mapButton.selected = NO;
    self.listButton.selected = YES;
    self.tableView.hidden = NO;
    self.mapView.hidden = YES;
}

-(void)showMap {
    self.mapButton.selected = YES;
    self.listButton.selected = NO;
    self.tableView.hidden = YES;
    self.mapView.hidden = NO;
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
        for (id school in _data) {
            CLLocation *restoLocation = [[CLLocation alloc] initWithLatitude:[[school objectForKey:@"lat"] floatValue] longitude:[[school objectForKey:@"long"] floatValue]];
            CLLocationDistance meters = [restoLocation distanceFromLocation:_location];
            [school setValue:[NSNumber numberWithInt:(int)meters] forKey:@"distance"];
        }
        
        [_data sortUsingComparator:^(id obj1, id obj2) {
            NSNumber *distance1 = [(NSDictionary *)obj1 objectForKey:@"distance"];
            NSNumber *distance2 = [(NSDictionary *)obj2 objectForKey:@"distance"];
            return [distance1 compare:distance2];
        }];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            for (int i = 0; i < [_data count]; i++) {
                APPAnnotation *annotation = [[APPAnnotation alloc] init];
                annotation.lat = [[_data[i] valueForKey:@"lat"] floatValue];
                annotation.lon = [[_data[i] valueForKey:@"long"] floatValue];
                if ([_data[i] valueForKey:@"naam"]) {
                    annotation.title = [_data[i] valueForKey:@"naam"];
                }
                else {
                    annotation.title = [_data[i] valueForKey:@"roepnaam"];
                }
                
                if ([_data[i] valueForKey:@"adres"]) {
                    annotation.subtitle = [_data[i] valueForKey:@"adres"];
                }
                else {
                    annotation.subtitle = [_data[i] valueForKey:@"straat"];
                }
                annotation.tag = i;
                [self.mapView addAnnotation:annotation];
            }
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
        UIImage *image;
        
        APPAnnotation *appAnnotation = (APPAnnotation *)annotation;
        
        if (annotation == mapView.userLocation) {
            image = [UIImage imageNamed:@"purplePin"];
        }
        else if ([[[_data objectAtIndex:appAnnotation.tag] valueForKey:@"aanbod"] isEqualToString:@"Kleuterschool"]) {
            image = [UIImage imageNamed:@"redPin"];
        }
        else if ([[[_data objectAtIndex:appAnnotation.tag] valueForKey:@"aanbod"] isEqualToString:@"Lagere school"]) {
            image = [UIImage imageNamed:@"bluePin"];
        }
        else if ([[[_data objectAtIndex:appAnnotation.tag] valueForKey:@"aanbod"] isEqualToString:@"Basisschool (Kleuter + Lager)"]) {
            image = [UIImage imageNamed:@"greenPin"];
        }
        else if ([[[_data objectAtIndex:appAnnotation.tag] valueForKey:@"aanbod"] isEqualToString:@"Buitengewoon onderwijs"]) {
            image = [UIImage imageNamed:@"brownPin"];
        }
        else {
            image = [UIImage imageNamed:@"redPin"];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [annotationView addSubview:imageView];
    }
    
    self.mapView.userLocation.title = @"Huidige locatie";
    annotationView.canShowCallout = YES;
    if (annotation != mapView.userLocation) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        annotationView.rightCalloutAccessoryView = rightButton;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    APPAnnotation *annotation = (APPAnnotation*)view.annotation;
    APPSchoolDetailViewController *schoolDetailVC = [[APPSchoolDetailViewController alloc] initWithDetailInformation:[_data objectAtIndex:annotation.tag]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = _location.coordinate;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    
    [self.mapView setRegion:mapRegion animated: YES];
}

#pragma mark - TableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    APPSchoolDetailViewController *schoolDetailVC = [[APPSchoolDetailViewController alloc] initWithDetailInformation:[_data objectAtIndex:indexPath.row]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:schoolDetailVC animated:YES];
}

#pragma mark - TableView DataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
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
@end
