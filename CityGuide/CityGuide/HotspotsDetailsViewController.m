//
//  HotspotsDetailsViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 20.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotsDetailsViewController.h"

@interface HotspotsDetailsViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation HotspotsDetailsViewController

- (id) initWithHotspot: (Hotspot *) hotspot {
    if (self = [super initWithNibName:@"HotspotsDetailsViewController" bundle:nil]) {
        self.hotspot = hotspot;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backButton setImage:[[self.backButton imageForState:UIControlStateNormal] imageTintedWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    
    self.imageView.image = [[DataManager instance] imageByHotspot: _hotspot];
    self.titleLabel.text = _hotspot.name;
    self.descriptionLabel.text = _hotspot.desc;
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
