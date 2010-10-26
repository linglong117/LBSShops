//
//  UIImage+Jepoque.m
//  Jepoque
//
//  Created by Tsang Mars on 9/28/09.
//  Copyright 2009 jepoque. All rights reserved.
//

#import "UIImage+GtFund.h"


@implementation UIImage(GtFund)

- (UIImage*)transformWidth:(CGFloat)width 
                    height:(CGFloat)height {
	
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
	
    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, 
                                                destW, 
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef), 
                                                4*destW, 
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
	
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return result;
}
//
- (UIImage *)transformToSize:(CGSize)newSize{
	UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
