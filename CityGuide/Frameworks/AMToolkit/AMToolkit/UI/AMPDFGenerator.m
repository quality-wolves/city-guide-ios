/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "AMPDFGenerator.h"

//#import <QuartzCore/QuartzCore.h>


@interface AMPDFGenerator (Private)

- (void) renderUIImageView: (UIImageView *) view frame: (CGRect) frame;
- (void) renderUILabel: (UILabel *) view frame: (CGRect) frame;
- (void) renderUIView: (UIView *) view frame: (CGRect) frame;
- (void) renderView: (UIView *) view;

@end


@implementation AMPDFGenerator

@synthesize filename;
@synthesize pathForFile;


- (id) init {
	if (self = [super init]) {
		pageRect = CGRectMake(0, 0, 595, 842);
	}
	return self;
}

- (id) initWithFilename: (NSString *) aFilename {
	if (self = [self init]) {
		self.filename = aFilename;
	}
	return self;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *) img
{
	UIImage *sourceImage = img;
	UIImage *newImage = nil;        
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor) 
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		}
        else 
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}       
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil) 
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

- (void) renderAMPDFView: (AMPDFView *) view frame: (CGRect) frame {
	[self renderUIView:view frame:frame];
	
	// url is a file URL
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)view.url);
	CGPDFPageRef page1 = CGPDFDocumentGetPage(pdf, 1);
	
	// get the rectangle of the cropped inside
//	CGRect mediaRect = CGPDFPageGetBoxRect(page1, kCGPDFCropBox);
//	CGContextScaleCTM(context, pageRect.size.width / mediaRect.size.width, pageRect.size.height / mediaRect.size.height);
//	CGContextTranslateCTM(context, -mediaRect.origin.x, -mediaRect.origin.y);
	
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextTranslateCTM(context, frame.origin.x, -(frame.size.height + frame.origin.y));
	
	// draw it
	CGContextDrawPDFPage(context, page1);
	CGPDFDocumentRelease(pdf);
}

- (void) renderUIImageView: (UIImageView *) view frame: (CGRect) frame {		
	[self renderUIView:view frame:frame];
	
	if (view.image) {
		float xf = view.image.size.width / frame.size.width;
		float yf = view.image.size.height / frame.size.height;
		float m = MIN(xf, yf);
		xf /= m;
		yf /= m;
		
		UIImage *image = [self imageByScalingAndCroppingForSize:CGSizeMake(view.image.size.width / xf, view.image.size.height / yf) image:view.image];
		
		CGContextSetAlpha(context, view.alpha);
		[image drawInRect:frame];
	}	
}

- (void) renderUILabel: (UILabel *) view frame: (CGRect) frame {
	[self renderUIView:view frame:frame];
	
	CGSize size = [view.text sizeWithFont:view.font constrainedToSize:frame.size];
	
	frame.origin.y = frame.origin.y + frame.size.height / 2.0 - size.height / 2.0;
	frame.size.height = size.height;
	
	if (view.shadowColor) {
		frame.origin.x += view.shadowOffset.width;
		frame.origin.y += view.shadowOffset.height;
		
		CGContextSetAlpha(context, view.alpha);
		CGContextSetFillColorWithColor(context, [view.shadowColor CGColor]);
		[view.text drawInRect:frame withFont:view.font lineBreakMode:view.lineBreakMode alignment:view.textAlignment];
		
		frame.origin.x -= view.shadowOffset.width;
		frame.origin.y -= view.shadowOffset.height;
	}
	
	CGContextSetAlpha(context, view.alpha);
	CGContextSetFillColorWithColor(context, [view.textColor CGColor]);
	[view.text drawInRect:frame withFont:view.font lineBreakMode:view.lineBreakMode alignment:view.textAlignment];
}

- (void) renderUIView: (UIView *) view frame: (CGRect) frame {
	if (view.backgroundColor) {
		CGContextSetAlpha(context, view.alpha);
		CGContextSetFillColorWithColor(context, [view.backgroundColor CGColor]);
		CGContextFillRect(context, frame);
	}
}

- (void) renderView: (UIView *) view {
	CGContextSaveGState(context);
	
	if (view.alpha && !view.hidden) {
		CGRect viewFrame = [viewToRender convertRect:view.frame fromView:view.superview];
		
		if ([view isKindOfClass:[UILabel class]]) {
			[self renderUILabel:(UILabel *)view frame:viewFrame];
		} else if ([view isKindOfClass:[UIImageView class]]) {
			[self renderUIImageView:(UIImageView *)view frame:viewFrame];
		} else if ([view isKindOfClass:[AMPDFView class]]) {
			[self renderAMPDFView:(AMPDFView *)view frame:viewFrame];
		} else if ([view isKindOfClass:[UIView class]]) {
			[self renderUIView:view frame:viewFrame];
		}
		
		for (UIView *subview in view.subviews) {
			[self renderView:subview];
		}
	}
	
	CGContextRestoreGState(context);
}

- (void) renderViewOnNewPage: (UIView *) view {
	viewToRender = view;
	
	CGPDFContextBeginPage(context, NULL);
	
	CGContextTranslateCTM(context, 0.0, pageRect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	UIGraphicsPushContext(context);
	
	[self renderView:view];
	
	UIGraphicsPopContext();
	
	CGPDFContextEndPage(context);
}

- (void) setFilename:(NSString *) newFilename {
	if (filename != newFilename) {
		filename = [newFilename copy];
		
		if (context)
			CGContextRelease(context);
		
		if (pathForFile)
			pathForFile = nil;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
		
		pathForFile = [[NSString alloc] initWithFormat:@"%@/%@", basePath, filename];
		
		NSURL *fileURL = [NSURL fileURLWithPath:pathForFile];
		
		context = CGPDFContextCreateWithURL((CFURLRef)fileURL, &pageRect, NULL);
	}
}

- (void) dealloc {
	CGContextRelease(context);
	
	viewToRender = nil;
	
	filename = nil;
	pathForFile = nil;

}


@end


@implementation AMPDFView

@synthesize url;


@end
