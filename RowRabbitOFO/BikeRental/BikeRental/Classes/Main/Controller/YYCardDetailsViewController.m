//
//  YYCardDetailsViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/9/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYCardDetailsViewController.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace_h.h"
#import "YYUserManager.h"
#import "YYLoginViewController.h"
#import "YYNavigationController.h"
#import "YYBaseRequest.h"
#import "YYUserModel.h"
#import "YYCertificationViewController.h"
#import "YYPayDepositViewController.h"
#import "YYChargeViewController.h"
#import <QMUIKit/QMUIKit.h>

@interface YYCardDetailsViewController ()

//卡名称
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
//卡描述
@property (weak, nonatomic) IBOutlet UILabel *cardDescriptionLabel;
//价格标准
@property (weak, nonatomic) IBOutlet UILabel *cardFeeLabel;
//现价
@property (weak, nonatomic) IBOutlet UILabel *cardPriceLabel;
//背景色
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property(nonatomic, strong) YYUserModel *userModel;

@end

@implementation YYCardDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    
    self.cardNameLabel.text = self.model.name;
    self.cardDescriptionLabel.text = self.model.content;
    self.cardPriceLabel.text = self.model.vip;
    self.cardFeeLabel.text = [NSString stringWithFormat:@"限时%@小时/月",self.model.viphour];
    self.navigationItem.title = [NSString stringWithFormat:@"%@详情",self.model.name];
    NSInteger day = 30;
    if ([self.model.name isEqualToString:@"月卡"]) {
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#4CD964"];
    }else if ([self.model.name isEqualToString:@"季卡"]){
        day = 90;
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F98574"];
    }else if ([self.model.name isEqualToString:@"年卡"]){
        day = 365;
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#0080FF"];
    }
    self.tipsLabel.text = [NSString stringWithFormat:@"1、每张%@成功购买后%ld天内有效，可多次购买，时间自动累计。\n2、退押金后无法继续租车，已购买的本卡有效期不变；重新缴纳押金后，本卡权益立即恢复。\n3、成功购买本卡后，购卡费用不予退还。\n4、如本卡使用时间累积超过限定时间，超出时间将以正常计费规则收费。\n5、使用有效期可以在：个人中心-我的钱包 里面查看。\n6、法律允许范围内此卡最终解释权归本公司所有。",self.model.name,(long)day];
    [UILabel changeLineSpaceForLabel:self.tipsLabel WithSpace:8];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserInfoRequest];
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
            
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setValue:self.model.vip forKey:@"price"];
    [segue.destinationViewController setValue:self.model.name forKey:@"name"];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
        return NO;
    }
    
    //未认证身份
    if ([self.userModel.idcard isEqualToString:@""]) {
        //Certification
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
        //[self.navigationController pushViewController:certificationViewController animated:YES];
        return NO;
    }
    
    //未交押金
    if (self.userModel.zmstate == 0 && (self.userModel.dstate == 0 || self.userModel.dstate == 3)) {
        //payDeposit
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
        //[self.navigationController pushViewController:payDepositViewController animated:YES];
        return NO;
    }
    
    if (self.userModel.money <= 0) {
        QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(200, 100);
        [tips showInfo:@"您的余额不足，请充值" hideAfterDelay:2];
        
        YYChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"charge"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:chargeViewController] animated:YES completion:nil];
        //[self.navigationController pushViewController:chargeViewController animated:YES];
        return NO;
    }
    
    return YES;
}

@end
