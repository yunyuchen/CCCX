//
//  XSPopoverView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/10/12.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "XSPopoverView.h"


@interface XSPopoverView ()

@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;

@end

@implementation XSPopoverView

- (UILabel *)textLB
{
    if (_textLB == nil) {
        _textLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLB.backgroundColor = RGBA_255(0, 0, 0, 0.7);
        _textLB.textAlignment = NSTextAlignmentCenter;
        _textLB.numberOfLines = 0;
        _textLB.textColor = [UIColor whiteColor];
        _textLB.font = [UIFont systemFontOfSize:12];
    }
    return _textLB;
}

- (void)addTriangleRelateView:(UIView *)view
{
    if (_triangleLayer == nil) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(view.width / 2.0 - 8, view.height)];
        [path addLineToPoint:CGPointMake(view.width  / 2.0, view.height + 10)];
        [path addLineToPoint:CGPointMake(view.width  / 2.0 + 8, view.height)];
        _triangleLayer = [CAShapeLayer layer];
        _triangleLayer.path = path.CGPath;
        _triangleLayer.fillColor = view.backgroundColor.CGColor;
        [self.layer addSublayer:_triangleLayer];
    }
}

- (void)adjustBoundsWithMaxWidth:(CGFloat)maxWidth
{
    [_textLB sizeToFit];
    // 最大宽度，防止超出屏幕
    if (_textLB.width >=maxWidth) {
        _textLB.width = maxWidth;
    }
    [_textLB sizeToFit];
    _textLB.width += 10;
    _textLB.height += 10;
    _textLB.layer.cornerRadius = 6;
    _textLB.layer.masksToBounds = YES;
    
    self.width = _textLB.width;
    self.height = _textLB.height;
    //
    [self addSubview:self.textLB];
    [self addTriangleRelateView:self.textLB];
}

+ (XSPopoverView *)showText:(NSString *)text inView:(UIView *)superView relateView:(UIView *)relateView
{
    XSPopoverView *popoverView = [[XSPopoverView alloc] init];
    popoverView.textLB.text = text;
    [superView addSubview:popoverView];
    
    // 距离左右屏幕的距离，取最小的
    CGFloat minWiddh = MIN(relateView.left + relateView.width / 2.0, superView.width - (relateView.left + relateView.width / 2.0));
    [popoverView adjustBoundsWithMaxWidth:(minWiddh - 10) * 2];
    popoverView.centerX = relateView.left + relateView.width / 2.0;
    popoverView.centerY = relateView.top - popoverView.height / 2.0;
    
    return popoverView;
    
}

@end


