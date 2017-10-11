//
//  YYWalkDetailView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/13.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYSiteModel.h"

@class YYWalkDetailView;
@protocol YYWalkDetailViewDelegate <NSObject>

-(void) YYWalkDetailView:(YYWalkDetailView *)walkDetailView didClickRentalButton:(UIButton *)rentalButton;

-(void) walkDetail:(YYWalkDetailView *)walkDetailView didClickAddressButton:(UIButton *)addressButton;

@end

@interface YYWalkDetailView : UIView

@property (nonatomic,weak) id<YYWalkDetailViewDelegate> delegate;

@property (nonatomic,strong) YYYSiteModel *model;

@end
