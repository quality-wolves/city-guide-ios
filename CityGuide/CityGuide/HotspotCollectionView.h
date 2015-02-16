//
//  HotspotCollectionView.h
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "TransparentView.h"

@interface HotspotCollectionView : TransparentView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, strong) void (^backButtonAction)();

+ (instancetype) create;

@end