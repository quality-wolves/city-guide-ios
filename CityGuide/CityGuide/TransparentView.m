//
//  TransparentView.m
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "TransparentView.h"

@implementation TransparentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *view = [super hitTest:point withEvent:event];
	if(view == self)
		return nil;
	
	return view;
}

@end
