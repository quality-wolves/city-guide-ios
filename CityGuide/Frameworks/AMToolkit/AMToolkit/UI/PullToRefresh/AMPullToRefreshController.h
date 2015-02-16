//
//  Created by Anton Kaizer on 04.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "MSPullToRefreshController.h"

@class AMPullToRefreshController;

@protocol AMPullToRefreshControllerDelegate <NSObject>

- (void) pullToRefreshControllerRefreshStarted:(AMPullToRefreshController *) controller;

@optional

/*
 * informs the delegate that lifting your finger will trigger a refresh
 * in that direction. This is only called when you cross the refreshable
 * offset defined in the respective MSInflectionOffsets.
 */
- (void) pullToRefreshControllerCanEngageRefreshDirection:(AMPullToRefreshController *) controller;

/*
 * informs the delegate that lifting your finger will NOT trigger a refresh
 * in that direction. This is only called when you cross the refreshable
 * offset defined in the respective MSInflectionOffsets.
 */
- (void) pullToRefreshControllerDidDisengageRefreshDirection:(AMPullToRefreshController *) controller;


@end

@interface AMPullToRefreshController : NSObject

@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet id<AMPullToRefreshControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIView *pullToRefreshView;
@property (nonatomic, assign) IBOutlet UIView *arrowView;
@property (nonatomic, assign) IBOutlet UIView *refreshProgressView;

@property (nonatomic) MSRefreshDirection direction;

- (void) endRefresh;

@end
