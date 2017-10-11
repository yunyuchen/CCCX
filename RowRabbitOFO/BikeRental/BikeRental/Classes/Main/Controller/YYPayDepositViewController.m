//
//  YYPayDepositViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYPayDepositViewController.h"
#import "NSNotificationCenter+Addition.h"
#import "YYPayDepositRequest.h"
#import "YYUserModel.h"
#import "YYFileCacheManager.h"
#import <WXApi.h>
#import <QMUIKit/QMUIKit.h>
#import <AlipaySDK/AlipaySDK.h>

@interface YYPayDepositViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,assign) CGFloat angle;

@property (nonatomic,strong) UIImageView *tranformImageView;

@property (weak, nonatomic) IBOutlet UIView *dotView;

@property (weak, nonatomic) IBOutlet UIView *dotView1;

@property (weak, nonatomic) IBOutlet UIView *wechatPayView;

@property (weak, nonatomic) IBOutlet UIView *aliPayView;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;

@property (weak, nonatomic) IBOutlet UIButton *wechatSelectButton;

@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;

@property (weak, nonatomic) IBOutlet UIButton *alipaySelectButton;

@property (weak, nonatomic) IBOutlet UILabel *despiteLabel;

@property (nonatomic,strong) YYUserModel *userModel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;


@end

@implementation YYPayDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTopView];
    
    [self getUserInfoRequest];
    
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];

    self.tipsLabel.text = [NSString stringWithFormat:@"您的芝麻信用分低于%@，为确保合规用车，需缴纳押金，可随时退回付款账号",[YYFileCacheManager readUserDataForKey:@"config"][@"zmscore"]];
    
    [WXApi registerApp:@"wx535feea77188fcab"];
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
          
            weak_self.despiteLabel.text = [NSString stringWithFormat:@"¥%.0f",weak_self.userModel.needDeposit];
       
            weak_self.accountLabel.text = [NSString stringWithFormat:@"账号:%@",weak_self.userModel.tel];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void) paySuccessAction:(NSNotification *)noti
{
    if (self.userModel.dstate == 0) {
         [self performSegueWithIdentifier:@"finish" sender:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) wechatPaySuccessAction:(NSNotification *)noti
{
    NSString *strMsg = @"";
    BaseResp *resp = (BaseResp *)(noti.object);
    switch (resp.errCode) {
        case WXSuccess:
        {
            strMsg = @"订单支付成功！";
            if (self.userModel.dstate == 0) {
                [self performSegueWithIdentifier:@"finish" sender:self];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
                //[self.navigationController popToRootViewControllerAnimated:YES];
            }
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

-(void)dealloc
{
    [NSNotificationCenter removeAllObserverForObj:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpTopView
{
    CGFloat margin = (kScreenWidth - 2 * 50) / 4;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通过"]];
    imageView1.left = 50;
    imageView1.top = 80;
    [self.topView addSubview:imageView1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView1.frame) + 8, 68, 20)];
    label1.centerX = imageView1.centerX;
    label1.text = @"手机绑定";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor colorWithHexString:@"#F08300"];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label1];
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame), imageView1.top, margin, 20)];
    [self.topView addSubview:sep1];
    UIImageView *arrwowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头11"]];
    arrwowImage.centerX = sep1.width * 0.5;
    arrwowImage.centerY = sep1.height * 0.5;
    [sep1 addSubview:arrwowImage];
    
    
    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step2Button.left = CGRectGetMaxX(sep1.frame);
    step2Button.top = 80;
    step2Button.layer.masksToBounds = YES;
    step2Button.width = step2Button.height = 20;
    [step2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step2Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step2Button setImage:[UIImage imageNamed:@"通过"] forState:UIControlStateNormal];
    [self.topView addSubview:step2Button];
    

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step2Button.frame) + 8, 100, 20)];
    label2.centerX = step2Button.centerX;
    label2.text = @"实名认证";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithHexString:@"#F08300"];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label2];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step2Button.frame), imageView1.top, margin, 1)];
    [self.topView addSubview:sep2];
    UIImageView *arrwowImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头22"]];
    arrwowImage1.centerX = sep1.width * 0.5;
    arrwowImage1.centerY = sep1.height * 0.5;
    [sep2 addSubview:arrwowImage1];
    
    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step3Button.left = CGRectGetMaxX(sep2.frame);
    step3Button.top = 80;
    step3Button.layer.cornerRadius = 10;
    step3Button.layer.masksToBounds = YES;
    step3Button.width = step3Button.height = 20;
    [step3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step3Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step3Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step3Button setTitle:@"3" forState:UIControlStateNormal];
    [self.topView addSubview:step3Button];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step3Button.frame) + 8, 68, 20)];
    label3.centerX = step3Button.centerX;
    label3.text = @"押金充值";
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = [UIColor colorWithHexString:@"#404040"];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label3];
    
    
    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step3Button.frame), imageView1.top, margin, 1)];
    [self.topView addSubview:sep3];
    UIImageView *arrwowImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头22"]];
    arrwowImage2.centerX = sep1.width * 0.5;
    arrwowImage2.centerY = sep1.height * 0.5;
    [sep3 addSubview:arrwowImage2];
    
    UIButton *step4Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step4Button.left = CGRectGetMaxX(sep3.frame);
    step4Button.top = 80;
    step4Button.layer.cornerRadius = 10;
    step4Button.layer.masksToBounds = YES;
    step4Button.width = step4Button.height = 20;
    [step4Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step4Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step4Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step4Button setTitle:@"4" forState:UIControlStateNormal];
    [self.topView addSubview:step4Button];
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step4Button.frame) + 8, 68, 20)];
    label4.centerX = step4Button.centerX;
    label4.text = @"开始用车";
    label4.font = [UIFont systemFontOfSize:12];
    label4.textColor = [UIColor colorWithHexString:@"#404040"];
    label4.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label4];
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
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"28背景02"]];
    arrowImageView.centerY = self.topView.height - arrowImageView.height * 0.5;
    arrowImageView.centerX = self.tranformImageView.centerX;
    [self.view addSubview:arrowImageView];

}

-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.tranformImageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void) endAnimation
{
    _angle += 10;
    [self startAnimation];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)chargeButtonClick:(id)sender {
    YYPayDepositRequest *request = [[YYPayDepositRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreatePayDepositAPI];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
