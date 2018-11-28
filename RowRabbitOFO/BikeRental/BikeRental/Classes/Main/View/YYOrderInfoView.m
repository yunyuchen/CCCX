//
//  YYOrderInfoView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYOrderInfoView.h"
#import "YYOrderInfoRequest.h"
#import "YYReturnResultModel.h"
#import "NSNotificationCenter+Addition.h"
#import "YYCouponModel.h"
#import <QMUIKit/QMUIKit.h>
#import <DateTools/DateTools.h>

@interface YYOrderInfoView()

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *extPrriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *vipButton;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;

@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *actButton;

@property (weak, nonatomic) IBOutlet UIView *actView;

@property (weak, nonatomic) IBOutlet UILabel *actLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actViewHeightCons;
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@end


@implementation YYOrderInfoView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.indicatorImageView.image = [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:[UIColor qmui_colorWithHexString:@"#9B9B9B"]];
      
        [NSNotificationCenter addObserver:self action:@selector(selectCouponAction:) name:kSelectedCouponNotification];
        self.actButton.layer.cornerRadius = 4;
        self.actButton.layer.masksToBounds = YES;
    }
    return self;
}


- (void) selectCouponAction:(NSNotification *)noti
{
    YYCouponModel *model = noti.object;
    self.cid = model.ID;
    YYReturnResultModel *resultModel = self.resultModel;
    resultModel.cid = model.ID;
    resultModel.money = model.money;
    self.resultModel = resultModel;
}

-(void)setSiteName:(NSString *)siteName
{
    _siteName = siteName;
    self.siteNameLabel.text = siteName;
}

-(void)setResultModel:(YYReturnResultModel *)resultModel
{
    _resultModel = resultModel;
    
    NSInteger hour = self.resultModel.keep / 60;
    NSInteger minute = self.resultModel.keep % 60;

//    if (resultModel.weekcut <= 1) {
//        self.actView.hidden = YES;
//        self.actViewHeightCons.constant = 0;
//    }else{
//        self.actView.hidden = NO;
//        self.actViewHeightCons.constant = 40;
//    }
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%ld时%ld分钟（行驶时长）",hour,minute];
    self.cid = resultModel.cid;
    if (resultModel.reds || resultModel.red) {
        self.discountView.hidden = YES;
    }else{
        if (self.resultModel.red) {
            self.discountLabel.text = [NSString stringWithFormat:@"付款成功后可获得红包%.1f元",resultModel.redBike];
        }
        if (self.resultModel.reds) {
            self.discountLabel.text = [NSString stringWithFormat:@"付款成功后可获得红包%.1f元",resultModel.redSite];
        }
    }
    if (resultModel.vip  > 1) {
        if (resultModel.weekcut > 1) {
             self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.2f",self.resultModel.price * self.resultModel.vip / 10 * self.resultModel.weekcut / 10 - resultModel.money];
            self.actLabel.text =  [NSString stringWithFormat:@"¥%.2f",self.resultModel.insurance];
        }else{
            self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.2f",self.resultModel.price * self.resultModel.vip / 10 - resultModel.money];
             self.actLabel.text =  [NSString stringWithFormat:@"¥%.2f",self.resultModel.insurance];
        }
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.resultModel.price * self.resultModel.vip / 10];
       
    }else{
        self.extPrriceLabel.hidden = YES;
        if (resultModel.weekcut > 1) {
            self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.2f",self.resultModel.price * self.resultModel.vip * self.resultModel.weekcut / 10- resultModel.money];
            self.actLabel.text =  [NSString stringWithFormat:@"¥%.2f",self.resultModel.insurance];
        }else{
            self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.2f",self.resultModel.price * self.resultModel.vip - resultModel.money];
            self.actLabel.text = [NSString stringWithFormat:@"¥%.2f",self.resultModel.insurance];
        }
     
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.resultModel.price * self.resultModel.vip];
    
    }
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",self.resultModel.price] attributes:attribtDic];
    self.extPrriceLabel.attributedText = attribtStr;
    self.siteNameLabel.text = [NSString stringWithFormat:@"%@",self.self.siteName];
    
    if (resultModel.vipstate) {
        [self.vipButton setImage:[UIImage imageNamed:@"VIP1"] forState:UIControlStateNormal];
        self.buyButton.hidden = YES;
    }else{
        [self.vipButton setImage:[UIImage imageNamed:@"VIP2"] forState:UIControlStateNormal];
        self.buyButton.hidden = NO;
    }
    NSString *vipType = resultModel.des;
   
    if (resultModel.cid > 0) {
        [self.couponPriceLabel setTextColor:[UIColor qmui_colorWithHexString:@"#FF5500"]];
        self.couponPriceLabel.text = [NSString stringWithFormat:@"-¥%.1f",resultModel.money];
    }else{
        self.couponPriceLabel.text = @"无可用优惠券";
    }
    
    if (resultModel.vip  > 1) {
      [self.vipButton setTitle:[NSString stringWithFormat:@"  %@ 享受%.1f折优惠",vipType,resultModel.vip] forState:UIControlStateNormal];
    }else{
       [self.vipButton setTitle:[NSString stringWithFormat:@"您不是VIP会员  无法享受优惠折扣"] forState:UIControlStateNormal];
       [self.vipButton setImage:nil forState:UIControlStateNormal];
    }

}

- (IBAction)okButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickOKButton:)]) {
        [self.delegate orderInfoView:self didClickOKButton:sender];
    }
}

- (IBAction)naviButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickNaviButton:withReturnModel:)]) {
        [self.delegate orderInfoView:self didClickNaviButton:sender withReturnModel:self.resultModel];
    }
}

- (IBAction)closeButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickCloseButton:)]) {
        [self.delegate orderInfoView:self didClickCloseButton:sender];
    }
}

- (IBAction)buyButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickBuyButton:)]) {
        [self.delegate orderInfoView:self didClickBuyButton:sender];
    }
}

- (IBAction)feeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickFeeButton:)]) {
        [self.delegate orderInfoView:self didClickFeeButton:sender];
    }
}

- (IBAction)couponButtonClick:(id)sender {
    if (self.resultModel.cid == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickCouponButton:)]) {
        [self.delegate orderInfoView:self didClickCouponButton:sender];
    }
}

-(void) reload
{
    [self setUserModel:self.userModel];
    [self setResultModel:self.resultModel];
}

-(void)setRsid:(NSInteger)rsid
{
    _rsid = rsid;
}

-(void)dealloc
{
    [NSNotificationCenter removeAllObserverForObj:self];
}

@end
