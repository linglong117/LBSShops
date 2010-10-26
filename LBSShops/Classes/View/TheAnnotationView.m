//
//  TheAnnotationView.m
//  LBSShops
//
//  Created by Zhou Weikuan on 10-10-11.
//  Copyright 2010 sino. All rights reserved.
//

#import "TheAnnotationView.h"
#import "ShopInfo.h"
#import "PosAnnotation.h"


@implementation TheAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(60.0, 85.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(30.0, 42.0);
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    PosAnnotation *item = (PosAnnotation *)self.annotation;
    if (item != nil)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        
        // draw the gray pointed shape:
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 14.0, 0.0);
        CGPathAddLineToPoint(path, NULL, 0.0, 0.0); 
        CGPathAddLineToPoint(path, NULL, 120.0, 60.0); 
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        
        // draw the cyan rounded box
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 15.0, 0.5);
        CGPathAddArcToPoint(path, NULL, 59.5, 00.5, 59.5, 5.0, 5.0);
        CGPathAddArcToPoint(path, NULL, 59.5, 69.5, 55.0, 69.5, 5.0);
        CGPathAddArcToPoint(path, NULL, 10.5, 69.5, 10.5, 64.0, 5.0);
        CGPathAddArcToPoint(path, NULL, 10.5, 00.5, 15.0, 0.5, 5.0);
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        
		ShopInfo * shop = item.shop;
        [shop.name drawInRect:CGRectMake(15.0, 5.0, 50.0, 40.0) withFont:[UIFont systemFontOfSize:11.0]];

		NSString * imagename = shop.imagename;
        if (shop.imagename == nil) {
            imagename = @"shop1.png";
        }
        [[UIImage imageNamed:imagename] drawInRect:CGRectMake(15, 15.0, 45.0, 45.0)];
    }
}


@end
