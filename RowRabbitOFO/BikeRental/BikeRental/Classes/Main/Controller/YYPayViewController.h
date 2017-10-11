//
//  YYPayViewController.h
//  BikeRental
//
//  Created by yunyuchen on 2017/9/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

@interface YYPayViewController : QMUICommonViewController

@property (nonatomic,assign) CGFloat price;

@property (nonatomic,copy) NSString *name;
@end
