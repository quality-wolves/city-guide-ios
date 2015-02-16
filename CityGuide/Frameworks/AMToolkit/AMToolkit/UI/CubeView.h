//
//  CubeView.h
//
//  Created by Jesse Boyes on 2/20/12.
//  Copyright (c) 2012 Jesse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CubeOrientationVertical,
    CubeOrientationHorizontal
} CubeOrientation;

@class CubeView;
@protocol CubeViewDelegate <NSObject>

- (NSUInteger)numPagesForCubeView:(CubeView *)CubeView;
- (UIView *)viewForPage:(NSUInteger)page CubeView:(CubeView *)CubeView;
- (CGRect)edgeRectForPage:(NSUInteger)page CubeView:(CubeView *)CubeView;

@optional

- (UIView *)topEdgePaneForCubeView:(CubeView *)CubeView;
- (UIView *)bottomEdgePaneForCubeView:(CubeView *)CubeView;

- (BOOL)supportsPullActionTop:(CubeView *)CubeView;
- (BOOL)supportsPullActionBottom:(CubeView *)CubeView;

- (void)pullTopActionTriggered:(CubeView *)CubeView topActionFrame:(CGRect)frame;
- (void)CubeView:(CubeView *)CubeView showedPageAtIndex: (NSUInteger) index;

@end

@interface CubeView : UIView

@property (nonatomic, weak) IBOutlet id<CubeViewDelegate> delegate;
@property (nonatomic) CubeOrientation orientation;

- (id)initWithFrame:(CGRect)frame delegate:(id<CubeViewDelegate>)del orientation:(CubeOrientation)co;

- (void)setTopEdgePaneHidden:(BOOL)hidden;
- (void)setCurrentPage:(NSUInteger)page;
- (void)reload;
- (NSUInteger) currentPage;

@end
