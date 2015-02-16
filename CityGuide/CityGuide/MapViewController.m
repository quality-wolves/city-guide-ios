//
//  MapViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CityGuide-Swift.h"
#import "HotspotAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *hotspots;
@property (strong, nonatomic) NSArray *annotations;
@property BOOL didUpdatedUserLocBefore;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.didUpdatedUserLocBefore = NO;
    self.locationManager = [CLLocationManager new];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.387128, 2.168564999999944), MKCoordinateSpanMake(1, 1));
    self.mapView.showsUserLocation = YES;
    [self reload];
}

- (void) reload {
    self.hotspots = [Hotspot allHotspots];
    [self.mapView removeAnnotations:self.annotations];
    NSMutableArray *ann = [NSMutableArray new];
    
    for (Hotspot *h in self.hotspots) {
        HotspotAnnotation *a = [[HotspotAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(h.lat, h.lon) title:h.name];
        [ann addObject:a];
    }
    
    self.annotations = ann;
    [_mapView addAnnotations:self.annotations];
    [_mapView showAnnotations:self.annotations animated:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnsActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appToBackground{
    [self.mapView setShowsUserLocation:NO];
}

- (void)appReturnsActive{
    [self.mapView setShowsUserLocation:YES];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

@end
