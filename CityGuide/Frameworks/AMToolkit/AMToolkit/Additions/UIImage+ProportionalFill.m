//
//  UIImage+ProportionalFill.m
//

#import "UIImage+ProportionalFill.h"


@implementation UIImage (ProportionalFill)


- (UIImage *)imageToFitSize:(CGSize)fitSize method:(ImageResizingMethod)resizeMethod
{
    float sourceWidth = [self size].width * self.scale;
    float sourceHeight = [self size].height * self.scale;
    float targetWidth = fitSize.width;
    float targetHeight = fitSize.height;
    BOOL cropping = !(resizeMethod == ImageResizeScale);
	
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    CGRect sourceRect, destRect;
    if (cropping) {
        destRect = CGRectMake(0, 0, targetWidth, targetHeight);
        float destX = .0f, destY = .0f;
        if (resizeMethod == ImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == ImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
				// Crop top
				destX = 0.0;
				destY = 0.0;
            } else {
				// Crop left
                destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == ImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
				// Crop bottom
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
            } else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor, 
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
        destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
    }
    
    // Create appropriately modified image.
	UIImage *image;
	UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 0.0); // 0.0 for scale means "correct scale for device's main screen".
	CGImageRef sourceI = CGImageCreateWithImageInRect([self CGImage], sourceRect); // cropping happens here.
	image = [UIImage imageWithCGImage:sourceI scale:0.0 orientation:self.imageOrientation]; // create cropped UIImage.
	[image drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
	CGImageRelease(sourceI);
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    return image;
}


- (UIImage *)imageCroppedToFitSize:(CGSize)fitSize
{
    return [self imageToFitSize:fitSize method:ImageResizeCrop];
}


- (UIImage *)imageScaledToFitSize:(CGSize)fitSize
{
    return [self imageToFitSize:fitSize method:ImageResizeScale];
}


@end
