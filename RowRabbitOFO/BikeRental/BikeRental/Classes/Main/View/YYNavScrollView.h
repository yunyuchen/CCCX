//
//  YYNavScrollView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/7/7.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSiteView.h"

@class  YYNavScrollView;
@protocol NavScrollViewDelegate <NSObject>

-(void) navScrollView:(YYNavScrollView *)navScrollView didSelectCurrentModel:(YYSiteModel *)model;

@end


@interface YYNavScrollView : UIView

@property(nonatomic,strong) UIScrollView *scrollView;
@property (strong, nonatomic) YYSiteView *imgVLeft;
@property (strong, nonatomic) YYSiteView *imgVCenter;
@property (strong, nonatomic) YYSiteView *imgVRight;
@property (assign, nonatomic) NSUInteger currentImageIndex;
@property (assign, nonatomic) NSUInteger imageCount;
@property (nonatomic,strong) NSArray<YYSiteModel *>* models;

- (void)setInfoByCurrentModelIndex:(NSUInteger)currentModelIndex;

@property (nonatomic,weak) id<NavScrollViewDelegate> delegate;

@end
