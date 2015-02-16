//
//  HotspotCollectionView.m
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotCollectionView.h"
#import "Additions/UIView+LoadFromNib.h"

@implementation HotspotCollectionView

+ (instancetype) create {
	return [self loadFromNib];
}

- (IBAction) backButtonClicked {
	if(self.backButtonAction)
		self.backButtonAction();
}

@end