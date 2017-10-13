//
//  KKPopTooltip.h
//  KKPopTooltip
//
//  Created by 刘继新 on 2017/7/21.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import "UIView+Size.h"
#import "NSString+Category.h"
#import "UIColor+Additions.h"

/// 箭头位置方向.
typedef NS_ENUM(NSInteger, TooltipArrowPosition) {
    TooltipArrowPositionTop,
    TooltipArrowPositionBottom
};

@interface KKPopTooltip : UIView

/// 指向UIBarButtonItem.
+ (KKPopTooltip *)showAtBarButtonItem:(UIBarButtonItem *)barButtonItem message:(NSString *)message arrowPosition:(TooltipArrowPosition)position;
/// 指向UIView.
+ (KKPopTooltip *)showPointingAtView:(UIView *)targetView inView:(UIView *)containerView message:(NSString *)message arrowPosition:(TooltipArrowPosition)position;
/// 指向点.
+ (KKPopTooltip *)showPointing:(CGPoint)point inView:(UIView *)containerView message:(NSString *)message arrowPosition:(TooltipArrowPosition)position;


- (instancetype)initWithFrame:(CGRect)frame position:(TooltipArrowPosition)positin;
@property (nonatomic, assign) TooltipArrowPosition arrowPosition;
@property (nonatomic, strong) UILabel *textLabel;

- (void)showInView:(UIView *)view animation:(BOOL)animation;
- (void)removeViewAnimated:(BOOL)animated;
@end
