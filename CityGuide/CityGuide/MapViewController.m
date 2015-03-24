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


@interface MapViewController () <MKMapViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *hotspots;
@property (strong, nonatomic) NSArray *annotations;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property BOOL didUpdatedUserLocBefore;
@end

@implementation MapViewController

- (id) init {
    if (self = [super init]) {
        self.hotspots = [Hotspot allHotspots];
    }
    return self;
}

- (id) initWithHotspots: (NSArray *) hotspots {
    if (self = [super init]) {
        self.hotspots = hotspots;
    }
    return self;
}

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

- (void) showDetailsForIndex: (NSUInteger) index {
    HotspotsDetailsViewController *vc = [[HotspotsDetailsViewController alloc] initWithHotspot:[_hotspots objectAtIndex:index]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) showDirectionsForIndex: (NSUInteger) index {
    Hotspot *hotspot = [_hotspots objectAtIndex:index];
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:hotspot.lat longitude:hotspot.lon];
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: toLocation.coordinate addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = hotspot.name;
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObject:destination]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:toLocation.coordinate], MKLaunchOptionsMapCenterKey,
                                  MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey,
                                  nil]];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: //Description
            [self showDetailsForIndex:actionSheet.tag];
            break;
        case 1: //Directions
            [self showDirectionsForIndex:actionSheet.tag];
        default:
            break;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[HotspotAnnotation class]]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Description", @"Directions", nil];
        sheet.tag = [_hotspots indexOfObject:((HotspotAnnotation *)view.annotation).hotspot];
        [sheet showInView:self.view];
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
