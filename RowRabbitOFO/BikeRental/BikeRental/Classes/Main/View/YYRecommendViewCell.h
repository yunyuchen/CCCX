//
//  YYRecommendViewCell.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/21.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRentalModel.h"
#import "YYYSiteModel.h"

@class YYRecommendViewCell;
@protocol RecommendViewCellDelegate <NSObject>

-(void) RecommendViewCell:(YYRecommendViewCell *)recommendViewCell didClickUseButton:(UIButton *)useButton;

@end
@interface YYRecommendViewCell : UITableViewCell

+(instancetype) cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) YYRentalModel *model;

@property (nonatomic,strong) YYYSiteModel *siteModel;

@property (nonatomic,weak) id<RecommendViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *recommendView;

@end
