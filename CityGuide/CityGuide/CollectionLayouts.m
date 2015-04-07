//
//  CollectionLayouts.m
//  CityGuide
//
//  Created by Chudin Yuriy on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "CollectionLayouts.h"
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"

@implementation CollectionLayouts

- (instancetype) init {
	if(self = [super init]) {
		_smallLayout = [HACollectionViewSmallLayout new];
		_largeLayout = [HACollectionViewLargeLayout new];
	}
	
	return self;
}

@end