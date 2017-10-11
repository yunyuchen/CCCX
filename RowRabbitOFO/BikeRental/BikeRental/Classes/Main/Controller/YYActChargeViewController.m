//
//  YYActChargeViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYActChargeViewController.h"
#import "YYCreateBlanceRequest.h"
#import "NSNotificationCenter+Addition.h"
#import "YYUserModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface YYActChargeViewController ()

@property (weak, nonatomic) IBOutlet UIView *wechatPayView;

@property (weak, nonatomic) IBOutlet UIView *aliPayView;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;

@property (weak, nonatomic) IBOutlet UIButton *wechatSelectButton;

@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;

@property (weak, nonatomic) IBOutlet UIButton *alipaySelectButton;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic,strong) YYUserModel *userModel;


@end

@implementation YYActChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.title = @"充值";
    self.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    self.priceLabel.text = [NSString stringWithFormat:@"%.0f",self.price];
    [self getUserInfoRequest];
    
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];
    
    [WXApi registerApp:@"wx535feea77188fcab"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取用户状态信息
-(void) getUserInfoRequest
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.userModel = [YYUserModel modelWithDictionary:response];
         
            weak_self.titleView.subtitle = [NSString stringWithFormat:@"充值账号:%@",weak_self.userModel.tel];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = [UIColor colorWithHexString:@"#ED1847"].CGColor;
    border1.fillColor = nil;
    border1.path = [UIBezierPath bezierPathWithRoundedRect:self.aliPayView.layer.bounds cornerRadius:5].CGPath;
    border1.frame = self.aliPayView.bounds;
    border1.lineWidth = 1.f;
    border1.lineJoin = @"round";
    border1.lineCap = @"round";
    border1.lineDashPattern = @[@4, @2];
    [self.aliPayView.layer addSublayer:border1];
    
    
    CAShapeLayer *border2 = [CAShapeLayer layer];
    border2.strokeColor = [UIColor colorWithHexString:@"#ED1847"].CGColor;
    border2.fillColor = nil;
    border2.path = [UIBezierPath bezierPathWithRoundedRect:self.wechatPayView.layer.bounds cornerRadius:5].CGPath;
    border2.frame = self.wechatPayView.bounds;
    border2.lineWidth = 1.f;
    border2.lineCap = @"round";
    border2.lineJoin = @"round";
    border2.lineDashPattern = @[@4, @2];
    [self.wechatPayView.layer addSublayer:border2];
    
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
    request.price = self.price;
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


@end
