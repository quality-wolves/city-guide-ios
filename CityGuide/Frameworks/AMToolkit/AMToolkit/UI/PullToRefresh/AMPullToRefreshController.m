//
//  AMPullToRefreshController.m
//  PTRTest
//
//  Created by Anton Kaizer on 04.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "AMPullToRefreshController.h"

@interface AMPullToRefreshController () <MSPullToRefreshDelegate>

@property (nonatomic, retain) MSPullToRefreshController *ptrc;

@end

@implementation AMPullToRefreshController

- (void) updateView {
	if (self.scrollView && self.pullToRefreshView && self.delegate) {
		[_scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
		self.ptrc = [[MSPullToRefreshController alloc] initWithScrollView:_scrollView delegate:self];
		[self.scrollView addSubview:self.pullToRefreshView];
		[self updatePullToRefreshViewPosition];
	}
}

- (void) updatePullToRefreshViewPosition {
	CGPoint origin = CGPointZero;
	if (self.direction == MSRefreshDirectionLeft)
		origin.x = -self.pullToRefreshView.frame.size.width;
	else if (self.direction == MSRefreshDirectionRight)
		origin.x = self.scrollView.contentSize.width < self.scrollView.frame.size.width ? self.scrollView.frame.size.width : self.scrollView.contentSize.width;

	if (self.direction == MSRefreshDirectionTop)
		origin.y = -self.pullToRefreshView.frame.size.height;
	else if (self.direction == MSRefreshDirectionBottom)
		origin.y = self.scrollView.contentSize.height < self.scrollView.frame.size.height ? self.scrollView.frame.size.height : self.scrollView.contentSize.height;
	
	self.pullToRefreshView.frame = CGRectMake(origin.x, origin.y, self.pullToRefreshView.frame.size.width, self.pullToRefreshView.frame.size.height);
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(UIScrollView *)object change:(NSDictionary *)change context:(void *)context {	
	[self updatePullToRefreshViewPosition];
	
}

- (void) setScrollView:(UIScrollView *)scrollView {
	if (scrollView != _scrollView) {
		[_scrollView removeObserver:self forKeyPath:@"contentSize"];
		_scrollView = scrollView;
		[self updateView];
	}
}

- (void) setDelegate:(id<AMPullToRefreshControllerDelegate>)delegate {
	if (delegate != _delegate) {
		_delegate = delegate;
		[self updateView];
	}
}

- (void) setPullToRefreshView:(UIView *)pullToRefreshView {
	if (pullToRefreshView != _pullToRefreshView) {
		_pullToRefreshView = pullToRefreshView;
		[self updateView];
	}
}

- (void) setDirection:(MSRefreshDirection)direction {
	_direction = direction;
	[self updateView];
}

- (void) dealloc {
	self.scrollView = nil;
	self.delegate = nil;
	self.pullToRefreshView = nil;
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void) endRefresh {
    [_ptrc finishRefreshingDirection:self.direction animated:YES];
	self.arrowView.transform = CGAffineTransformMakeRotation([self startAngle]);
	[UIView transitionWithView:self.pullToRefreshView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		self.arrowView.hidden = NO;
		self.refreshProgressView.hidden = YES;
	} completion:nil];
	
}

- (CGFloat) startAngle {
	switch (self.direction) {
		case MSRefreshDirectionTop:
			return 0;
			break;
		case MSRefreshDirectionBottom:
			return M_PI;
			break;
		case MSRefreshDirectionLeft:
			return M_PI/2;
			break;
		case MSRefreshDirectionRight:
			return -M_PI/2;
			break;
		default:
			break;
	}
}

- (CGFloat) flippedAngle {
	return [self startAngle] + M_PI;
}

#pragma mark - MSPullToRefreshDelegate Methods

- (BOOL) pullToRefreshController:(MSPullToRefreshController *)controller canRefreshInDirection:(MSRefreshDirection)direction {
    return direction == self.direction;
}

- (CGFloat) pullToRefreshController:(MSPullToRefreshController *)controller refreshingInsetForDirection:(MSRefreshDirection)direction {
	if (self.direction == MSRefreshDirectionLeft || self.direction == MSRefreshDirectionRight)
		return self.pullToRefreshView.frame.size.width;
	else
		return self.pullToRefreshView.frame.size.height;
}

- (CGFloat) pullToRefreshController:(MSPullToRefreshController *)controller refreshableInsetForDirection:(MSRefreshDirection)direction {
    return [self pullToRefreshController:controller refreshingInsetForDirection:direction];
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller canEngageRefreshDirection:(MSRefreshDirection)direction {
	[UIView animateWithDuration:0.2 animations:^{
		self.arrowView.transform = CGAffineTransformMakeRotation([self flippedAngle]);
	}];
	if ([self.delegate respondsToSelector:@selector(pullToRefreshControllerCanEngageRefreshDirection:)])
		[self.delegate pullToRefreshControllerCanEngageRefreshDirection:self];
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller didDisengageRefreshDirection:(MSRefreshDirection)direction {
	[UIView animateWithDuration:0.2 animations:^{
		self.arrowView.transform = CGAffineTransformMakeRotation([self startAngle]);
	}];
	if ([self.delegate respondsToSelector:@selector(pullToRefreshControllerDidDisengageRefreshDirection:)])
		[self.delegate pullToRefreshControllerDidDisengageRefreshDirection:self];
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller didEngageRefreshDirection:(MSRefreshDirection)direction {
	[UIView transitionWithView:self.pullToRefreshView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		self.arrowView.hidden = YES;
		self.refreshProgressView.hidden = NO;
	} completion:nil];
	[self.delegate pullToRefreshControllerRefreshStarted:self];
}


@end
