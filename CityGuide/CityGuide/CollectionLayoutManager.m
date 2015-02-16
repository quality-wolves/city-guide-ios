//
//  CollectionLayoutManager.m
//  CityGuide
//
//  Created by Chudin Yuriy on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "CollectionLayoutManager.h"
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"

@interface CollectionLayoutManager ()

@end



@implementation CollectionLayoutManager

+ (instancetype) instance {
	static CollectionLayoutManager *manager = nil;
	if(manager)
		return manager;
	
	return manager = [CollectionLayoutManager new];
}

- (instancetype) init {
	if(self = [super init]) {
		_smallLayout = [HACollectionViewSmallLayout new];
		_largeLayout = [HACollectionViewLargeLayout new];
	}
	
	return self;
}

@end