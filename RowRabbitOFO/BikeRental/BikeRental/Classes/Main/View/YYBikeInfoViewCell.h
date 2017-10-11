//
//  YYBikeInfoViewCell.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRentalModel.h"

@class YYBikeInfoViewCell;
@protocol BikeInfoViewCellDelegate <NSObject>

-(void) bikeInfoViewCell:(YYBikeInfoViewCell *)bikeInfoViewCell didClickUseButton:(UIButton *)useButton;

@end

@interface YYBikeInfoViewCell : UITableViewCell

+(instancetype) cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) YYRentalModel *model;

@property (nonatomic,weak) id<BikeInfoViewCellDelegate> delegate;

@end
