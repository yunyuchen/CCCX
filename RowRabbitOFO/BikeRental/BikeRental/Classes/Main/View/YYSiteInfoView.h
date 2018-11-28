//
//  YYSiteInfoView.h
//  BikeRental
//
//  Created by yunyuchen on 2018/11/27.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSiteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYSiteInfoView : UIView

@property (weak, nonatomic) IBOutlet UIView *discountView;

@property (weak, nonatomic) IBOutlet UIImageView *siteImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property(nonatomic, strong) YYSiteModel *model;


@end

NS_ASSUME_NONNULL_END
