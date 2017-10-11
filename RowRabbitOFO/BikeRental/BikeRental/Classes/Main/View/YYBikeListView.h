//
//  YYBikeListView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBikeListView,YYBikeInfoViewCell;
@protocol BikeListViewDelegate <NSObject>

-(void) BikeListView:(YYBikeListView *)bikeListView didClickCloseButton:(UIButton *)closeButton;

-(void) BikeListView:(YYBikeListView *)bikeListView didClickUseButtonCell:(YYBikeInfoViewCell *)useButtonCell;

@end


@interface YYBikeListView : UIView

@property(nonatomic,assign) NSInteger sid;

@property (nonatomic,assign) CGFloat distance;

@property (nonatomic,copy) NSString *siteName;

@property (nonatomic,weak) id<BikeListViewDelegate> delegate;

@end
