/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <Foundation/Foundation.h>

#import <QuartzCore/CALayer.h>


@interface AMPDFGenerator : NSObject {
	CGContextRef context;
	CGRect pageRect;
	
	UIView *viewToRender;
	
	NSString *filename;
	NSString *pathForFile;
}

- (id) initWithFilename: (NSString *) filename;
- (void) renderViewOnNewPage: (UIView *) view;

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, readonly) NSString *pathForFile;

@end


@interface AMPDFView : UIView {
	NSURL *url;
}

@property (nonatomic, strong) NSURL *url;

@end