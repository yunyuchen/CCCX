//
//  YYDesViewCell.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/18.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSiteModel.h"

@class YYDesViewCell;
@protocol DesViewCellDelegate <NSObject>

-(void) DesViewCell:(YYDesViewCell *)cell didClickGoButton:(UIButton *)sender;

@end

@interface YYDesViewCell : UITableViewCell

@property (nonatomic,strong) YYSiteModel *model;

@property(nonatomic,weak) id<DesViewCellDelegate> delegate;

@end
