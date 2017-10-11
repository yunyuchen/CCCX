//
//  YYReturnBikeViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYReturnBikeViewController.h"
#import "YYPayOrderRequest.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NSNotificationCenter+Addition.h"
#import <QMUIKit/QMUIKit.h>
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import <DateTools/DateTools.h>

@interface YYReturnBikeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (weak, nonatomic) IBOutlet UIView *outerView;

@property (weak, nonatomic) IBOutlet UIView *wechatPayView;

@property (weak, nonatomic) IBOutlet UIView *aliPayView;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;

@property (weak, nonatomic) IBOutlet UIButton *wechatSelectButton;

@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;

@property (weak, nonatomic) IBOutlet UIButton *alipaySelectButton;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (weak, nonatomic) IBOutlet UILabel *extPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *extDeslabel;

@end

@implementation YYReturnBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payButton.layer.cornerRadius = 12;
    self.payButton.layer.masksToBounds = YES;
    
    self.outerView.layer.cornerRadius = 5;
    self.outerView.layer.masksToBounds = YES;
    
    NSInteger hour = self.keep / 60;
    NSInteger minute = self.keep % 60;
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%ld时%ld分钟",hour,minute];
    self.totalPrice.text = [NSString stringWithFormat:@"¥%.0f",self.price];
    self.extPriceLabel.text = [NSString stringWithFormat:@"%.0f",self.extprice];
    self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.0f",self.price + self.extprice];
    self.fd_interactivePopDisabled = YES;
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];
}

-(void) paySuccessAction:(NSNotification *)noti
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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

- (IBAction)payButtonClick:(id)sender {
    YYPayOrderRequest *request = [[YYPayOrderRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreatePayOrderAPI];
        if (self.alipaySelectButton.selected) {
            request.ptype = 0;
            [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                if (success) {
                    NSString *appScheme = @"bsPay";
                    NSString *orderString = [NSString stringWithFormat:@"%@",response];
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic){
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
   
        //============================================================
        // V3&V4支付流程实现
        // 注意:参数配置请查看服务器端Demo
        // 更新时间：2015年11月20日
        //============================================================
//        NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
//        //解析服务端返回json数据
//        NSError *error;
//        //加载一个NSURL对象
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        //将请求的url数据放到NSData对象中
//        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        if ( response != nil) {
//            NSMutableDictionary *dict = NULL;
//            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//            dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//            
//            NSLog(@"url:%@",urlString);
//            if(dict != nil){
//                NSMutableString *retcode = [dict objectForKey:@"retcode"];
//                if (retcode.intValue == 0){
//                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//                    
//                    //调起微信支付
//                    PayReq* req             = [[PayReq alloc] init];
//                    req.partnerId           = [dict objectForKey:@"partnerid"];
//                    req.prepayId            = [dict objectForKey:@"prepayid"];
//                    req.nonceStr            = [dict objectForKey:@"noncestr"];
//                    req.timeStamp           = stamp.intValue;
//                    req.package             = [dict objectForKey:@"package"];
//                    req.sign                = [dict objectForKey:@"sign"];
//                    [WXApi sendReq:req];
//                    //日志输出
//                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//                
//                }else{
//                  
//                }
//            }else{
//           
//            }
//        }
    
}

-(void) wechatPaySuccessAction:(NSNotification *)noti
{
    NSString *strMsg = @"";
    BaseResp *resp = (BaseResp *)(noti.object);
    switch (resp.errCode) {
        case WXSuccess:
        {
            strMsg = @"订单支付成功！";
            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
            
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(300, 100);
            [tips showSucceed:strMsg hideAfterDelay:3];
            [self.navigationController popToRootViewControllerAnimated:YES];

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



@end
