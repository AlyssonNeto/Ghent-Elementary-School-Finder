//
//  APPSchoolDetailViewController.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPSchoolDetailViewController.h"
#import "MDCParallaxView.h"

#define padding 15

@interface APPSchoolDetailViewController ()

@property (strong, nonatomic) NSArray *detailInfo;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation APPSchoolDetailViewController

-(id)initWithDetailInformation:(NSArray *)detailInfo {
    self = [super init];
    if (self) {
        _detailInfo = detailInfo;
        self.navigationItem.title = [NSString stringWithFormat:@"%@", [_detailInfo valueForKey:@"roepnaam"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), scrollViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 480)];
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:NO];
    [mapView setScrollEnabled:NO];
    mapView.delegate = self;
    
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
    region.center.latitude = [[_detailInfo valueForKey:@"lat"] floatValue];
    region.center.longitude = [[_detailInfo valueForKey:@"long"] floatValue];
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [mapView setRegion:region animated:YES];
    
    APPAnnotation *annotation = [[APPAnnotation alloc] init];
    annotation.lat = [[_detailInfo valueForKey:@"lat"] floatValue];
    annotation.lon = [[_detailInfo valueForKey:@"long"] floatValue];
    [mapView addAnnotation:annotation];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 600)];
    containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, padding, 270, 40)];
    nameTitle.font = [UIFont boldSystemFontOfSize:18];
    nameTitle.textColor = appColorBlue;
    nameTitle.text = [_detailInfo valueForKey:@"roepnaam"];
    [nameTitle sizeToFit];
    [containerView addSubview:nameTitle];
    
    UILabel *addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(nameTitle) + padding, 270, 40)];
    addressTitle.font = [UIFont boldSystemFontOfSize:16];
    addressTitle.textColor = appColorBlue;
    addressTitle.text = @"Adres";
    [addressTitle sizeToFit];
    [containerView addSubview:addressTitle];
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(addressTitle) + 5, 270, 40)];
    address.font = [UIFont systemFontOfSize:14];
    address.textColor = [UIColor blackColor];
    address.text = [_detailInfo valueForKey:@"straat"];
    [address sizeToFit];
    [containerView addSubview:address];
    
    UILabel *offerTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(address) + padding, 270, 40)];
    offerTitle.font = [UIFont boldSystemFontOfSize:16];
    offerTitle.textColor = appColorBlue;
    offerTitle.text = @"Aanbod";
    [offerTitle sizeToFit];
    [containerView addSubview:offerTitle];
    
    UILabel *offer = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(offerTitle) + 5, 270, 40)];
    offer.font = [UIFont systemFontOfSize:14];
    offer.textColor = [UIColor blackColor];
    offer.text = [_detailInfo valueForKey:@"aanbod"];
    [offer sizeToFit];
    [containerView addSubview:offer];
    
    UILabel *networkTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(offer) + padding, 270, 40)];
    networkTitle.font = [UIFont boldSystemFontOfSize:16];
    networkTitle.textColor = appColorBlue;
    networkTitle.text = @"Net";
    [networkTitle sizeToFit];
    [containerView addSubview:networkTitle];
    
    UILabel *network = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(networkTitle) + 5, 270, 40)];
    network.font = [UIFont systemFontOfSize:14];
    network.textColor = [UIColor blackColor];
    network.text = [_detailInfo valueForKey:@"net"];
    network.numberOfLines = 0;
    network.lineBreakMode = NSLineBreakByWordWrapping;
    [network sizeToFit];
    [containerView addSubview:network];
    
    UIButton *showRouteBtn = [KHFlatButton buttonWithFrame:CGRectMake(CENTER_IN_PARENT_X(containerView, 300), BOTTOM(network) + padding, 300, 50) withTitle:@"TOON ROUTE" backgroundColor:appColorGreen];
    
    [showRouteBtn addTarget:self action:@selector(showRoute) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:showRouteBtn];
    
    containerView.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y, containerView.frame.size.width, BOTTOM(showRouteBtn) + HEIGHT(self.tabBarController.tabBar) + HEIGHT(self.navigationController.navigationBar) + [UIApplication sharedApplication].statusBarFrame.size.height + padding);
    
    MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:mapView foregroundView:containerView];
    parallaxView.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view));
    parallaxView.scrollView.scrollsToTop = YES;
    parallaxView.scrollViewDelegate = self;
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:parallaxView];
}

-(CALayer*)createBorderWithY:(CGFloat)y {
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, y, 320, 2);
    border.backgroundColor = appColorBlue.CGColor;
    return border;
}

- (void)showRoute
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[_detailInfo valueForKey:@"lat"] floatValue], [[_detailInfo valueForKey:@"long"] floatValue]);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:[_detailInfo valueForKey:@"roepnaam"]];
        
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
