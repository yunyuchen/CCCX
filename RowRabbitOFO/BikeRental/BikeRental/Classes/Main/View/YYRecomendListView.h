//
//  YYRecomendListView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/21.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYSiteModel.h"
#import "YYRentalModel.h"

@class YYRecomendListView;
@protocol RecomendListViewDelegate <NSObject>

-(void) YYRecomendListView:(YYRecomendListView *)recomendListView didClickCloseButton:(UIButton *)closeButton;

-(void) YYRecomendListView:(YYRecomendListView *)recomendListView didClickUseButton:(UIButton *)useButton;

@end

@interface YYRecomendListView : UIView

@property (nonatomic,strong) YYYSiteModel *siteModel;

@property (nonatomic,strong) YYRentalModel *selectedModel;

@property (nonatomic,weak) id<RecomendListViewDelegate> delegate;

@property (nonatomic,strong) NSArray<YYRentalModel *> *rentalArray;

@property (nonatomic,strong) NSArray<YYRentalModel *> *array;

@property(nonatomic, copy) NSString *siteName;

@property(nonatomic, assign) CGFloat distance;

@end
