//
//  UIImage+Jepoque.h
//  Jepoque
//
//  Created by Tsang Mars on 9/28/09.
//  Copyright 2009 jepoque. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(GtFund)
- (UIImage *)transformWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)transformToSize:(CGSize)newSize;

@end
