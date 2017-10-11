//
//  YYRemoteViewCell.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSiteModel.h"

@class YYRemoteViewCell;
@protocol RemoteViewCellDelegate <NSObject>

-(void) RemoteViewCell:(YYRemoteViewCell *)cell didClickReturnButton:(UIButton *)returnButton;

@end

@interface YYRemoteViewCell : UITableViewCell

@property (nonatomic,strong) YYSiteModel *model;

@property (nonatomic,weak) id<RemoteViewCellDelegate> delegate;

@end
