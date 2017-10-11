//
//  YYPersonalViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYPersonalViewCell.h"

@interface YYPersonalViewCell()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@end


@implementation YYPersonalViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItemName:(NSString *)itemName
{
    _itemName = itemName;
    self.itemNameLabel.text = itemName;
}

-(void)setItemImage:(NSString *)itemImage
{
    _itemName = itemImage;
    self.itemImageView.image = [UIImage imageNamed:itemImage];
}

@end
