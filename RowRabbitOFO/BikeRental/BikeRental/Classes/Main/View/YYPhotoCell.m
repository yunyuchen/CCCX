//
//  YYPhotoCell.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/19.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "YYPhotoCell.h"

@implementation YYPhotoCell

/** 查看大图 */
- (void)setBigImgViewWithImage:(UIImage *)img{
    if (_BigImgView) {
        //如果大图正在显示，还原小图
        _BigImgView.frame = _profilePhoto.frame;
        _BigImgView.image = img;
    }else{
        _BigImgView = [[UIImageView alloc] initWithImage:img];
        _BigImgView.frame = _profilePhoto.frame;
        [self insertSubview:_BigImgView atIndex:0];
    }
    _BigImgView.contentMode = UIViewContentModeScaleToFill;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
