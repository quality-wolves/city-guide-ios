//
//  HotspotDetailsCell.m
//  CityGuide
//
//  Created by Chudin Yuriy on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotDetailsCell.h"
#import "DataManager.h"
#import "CityGuide-Swift.h"

@interface HotspotDetailsCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end

@implementation HotspotDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHotspot:(Hotspot *)hotspot {
	self.imageView.image = [[DataManager instance] imageByHotspot: hotspot];
	self.titleLabel.text = hotspot.name;
	self.descriptionLabel.text = hotspot.desc;
}

@end