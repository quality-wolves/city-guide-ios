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
#import "HotspotAnnotationView.h"
#import "HotspotsDetailsViewController.h"


@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *hotspots;
@property (strong, nonatomic) NSArray *annotations;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property BOOL didUpdatedUserLocBefore;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backButton setImage:[[self.backButton imageForState:UIControlStateNormal] imageTintedWithColor:[UIColor blackColor]] forState:UIControlStateNormal];

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
        HotspotAnnotation *a = [[HotspotAnnotation alloc] initWithHotspot:h];
        [ann addObject:a];
    }

    self.annotations = ann;
    [_mapView addAnnotations:self.annotations];
}

- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    [_mapView showAnnotations:self.annotations animated:NO];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[HotspotAnnotation class]]) {
        HotspotAnnotation *ann = (HotspotAnnotation *) view.annotation;
        HotspotsDetailsViewController *vc = [[HotspotsDetailsViewController alloc] initWithHotspot:ann.hotspot];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[HotspotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
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
