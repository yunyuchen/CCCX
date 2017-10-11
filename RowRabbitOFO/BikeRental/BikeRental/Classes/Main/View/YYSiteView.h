//
//  YYSiteView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/7/7.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSiteModel.h"

@class YYSiteView;
@protocol navScrollViewDelegate <NSObject>

-(void) addressView:(YYSiteView *)addressView didClickReturnButton:(UIButton *)returnButton;

@end

@interface YYSiteView : UIView

@property (nonatomic,strong) YYSiteModel *model;

@property (nonatomic,weak) id<navScrollViewDelegate> delegate;

@end
