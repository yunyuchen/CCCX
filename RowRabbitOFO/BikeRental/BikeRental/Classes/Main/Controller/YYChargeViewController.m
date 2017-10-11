//
//  YYChargeViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/13.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYChargeViewController.h"
#import "UIImage+Color.h"
#import "YYCreateBlanceRequest.h"
#import "NSNotificationCenter+Addition.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <QMUIKit/QMUIKit.h>

@interface YYChargeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *value100Button;

@property (weak, nonatomic) IBOutlet UIButton *value50Button;

@property (weak, nonatomic) IBOutlet UIButton *value20Button;

@property (weak, nonatomic) IBOutlet UIButton *value10Button;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (weak, nonatomic) IBOutlet UIView *outerView;

@property (weak, nonatomic) IBOutlet UIView *wechatPayView;

@property (weak, nonatomic) IBOutlet UIView *aliPayView;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;

@property (weak, nonatomic) IBOutlet UIButton *wechatSelectButton;

@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;

@property (weak, nonatomic) IBOutlet UIButton *alipaySelectButton;

@property (nonatomic,strong) UIButton *selectedButton;

@end

@implementation YYChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
    
    [self.value10Button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#00B734"]] forState:UIControlStateSelected];
    [self.value50Button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#00B734"]] forState:UIControlStateSelected];
    [self.value20Button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#00B734"]] forState:UIControlStateSelected];
    [self.value100Button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#00B734"]] forState:UIControlStateSelected];
    
    self.value10Button.layer.cornerRadius = 8;
    self.value10Button.layer.masksToBounds = YES;
    
    self.value20Button.layer.cornerRadius = 8;
    self.value20Button.layer.masksToBounds = YES;
    
    self.value50Button.layer.cornerRadius = 8;
    self.value50Button.layer.masksToBounds = YES;
    
    self.value100Button.layer.cornerRadius = 8;
    self.value100Button.layer.masksToBounds = YES;
    
    self.selectedButton = self.value100Button;
    
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];
    
    [WXApi registerApp:@"wx535feea77188fcab"];

}

-(void) paySuccessAction:(NSNotification *)noti
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) wechatPaySuccessAction:(NSNotification *)noti
{
    NSString *strMsg = @"";
    BaseResp *resp = (BaseResp *)(noti.object);
    switch (resp.errCode) {
        case WXSuccess:
        {
            strMsg = @"支付成功！";
            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
            
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(300, 100);
            [tips showSucceed:strMsg hideAfterDelay:3];
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        case WXErrCodeCommon: strMsg = @"普通错误类型"; break;
        case WXErrCodeUserCancel: strMsg = @"取消支付"; break;
        case WXErrCodeSentFail: strMsg = @"发送失败"; break;
        case WXErrCodeAuthDeny: strMsg = @"授权失败"; break;
        case WXErrCodeUnsupport: strMsg = @"微信不支持"; break;
        default: strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr]; break;
    }
    
    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
    
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(300, 100);
    [tips showInfo:strMsg hideAfterDelay:3];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = [UIColor colorWithHexString:@"#00842A"].CGColor;
    border1.fillColor = nil;
    border1.path = [UIBezierPath bezierPathWithRoundedRect:self.aliPayView.layer.bounds cornerRadius:5].CGPath;
    border1.frame = self.aliPayView.bounds;
    border1.lineWidth = 1.f;
    border1.lineJoin = @"round";
    border1.lineCap = @"round";
    border1.lineDashPattern = @[@4, @2];
    [self.aliPayView.layer addSublayer:border1];
    
    
    CAShapeLayer *border2 = [CAShapeLayer layer];
    border2.strokeColor = [UIColor colorWithHexString:@"#00842A"].CGColor;
    border2.fillColor = nil;
    border2.path = [UIBezierPath bezierPathWithRoundedRect:self.wechatPayView.layer.bounds cornerRadius:5].CGPath;
    border2.frame = self.wechatPayView.bounds;
    border2.lineWidth = 1.f;
    border2.lineCap = @"round";
    border2.lineJoin = @"round";
    border2.lineDashPattern = @[@4, @2];
    [self.wechatPayView.layer addSublayer:border2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)valueButtonClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
}

- (IBAction)wechatPayButtonClick:(id)sender {
    self.alipayImageView.image = [UIImage imageNamed:@"26支付01"];
    self.wechatImageView.image = [UIImage imageNamed:@"27微信02"];
    self.alipaySelectButton.selected = NO;
    self.wechatSelectButton.selected = YES;
}


- (IBAction)alipayButtonClick:(id)sender {
    self.alipayImageView.image = [UIImage imageNamed:@"26支付02"];
    self.wechatImageView.image = [UIImage imageNamed:@"27微信01"];
    self.alipaySelectButton.selected = YES;
    self.wechatSelectButton.selected = NO;
}



- (IBAction)chargeButtonClick:(id)sender {
    YYCreateBlanceRequest *request = [[YYCreateBlanceRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,KCreatePayBalanceAPI];
    request.price = [self.selectedButton.currentTitle floatValue];
    //request.price = 1;
    if (self.alipaySelectButton.selected) {
        request.ptype = 0;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                NSString *appScheme = @"chengchePay";
                NSString *orderString = [NSString stringWithFormat:@"%@",response];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
        request.ptype = 1;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                PayReq* req  = [[PayReq alloc] init];
                req.partnerId  = response[@"partnerid"];
                req.prepayId            = response[@"prepayid"];
                req.nonceStr            = response[@"noncestr"];
                req.timeStamp           = [response[@"timestamp"] intValue];
                req.package             = response[@"package"];
                req.sign                = response[@"sign"];
                [WXApi sendReq:req];
            }
        } error:^(NSError *error) {
            
        }];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
