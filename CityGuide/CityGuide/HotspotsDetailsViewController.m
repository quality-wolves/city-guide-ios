//
//  HotspotsDetailsViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 20.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotsDetailsViewController.h"
#import "FavouritesManager.h"

@interface HotspotsDetailsViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HotspotsDetailsViewController

- (id) initWithHotspot: (Hotspot *) hotspot {
    if (self = [super initWithNibName:@"HotspotsDetailsViewController" bundle:nil]) {
        self.hotspots = @[hotspot];
    }
    return self;
}

- (id) initWithHotspots: (NSArray *) hotspots {
    if (self = [super initWithNibName:@"HotspotsDetailsViewController" bundle:nil]) {
        self.hotspots = hotspots;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
