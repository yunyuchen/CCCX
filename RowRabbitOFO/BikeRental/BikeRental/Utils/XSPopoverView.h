//
//  XSPopoverView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/10/12.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XSPopoverView : UIView
+ (XSPopoverView *)showText:(NSString *)text
                     inView:(UIView *)superView
                 relateView:(UIView *)relateView;

@end

