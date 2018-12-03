//
//  YYPCenterViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/13.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYPCenterViewController.h"
#import "YYUserManager.h"
#import "YYBaseRequest.h"
#import "YYUserModel.h"
#import "YYMyWalletViewController.h"
#import "YYGuideViewController.h"
#import "YYSettingViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <QMUIKit/QMUIKit.h>
#import <DateTools/DateTools.h>
#import "YYScoreViewController.h"

@interface YYPCenterViewController ()

@property (nonatomic,strong) YYUserModel *model;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet QMUIGhostButton *scoreButton;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyButtonWidthCons;

@property(nonatomic, assign) CGFloat score;

@end

@implementation YYPCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self getUserInfoRequest];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserInfo];
}

-(void) getUserInfoRequest
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            QMUILog(@"%@",response);
            weak_self.model = [YYUserModel modelWithDictionary:response];
            
            weak_self.telLabel.text = weak_self.model.tel;
        }
    } error:^(NSError *error) {
        
    }];
}

- (void) getUserInfo
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserinfoAPI];
    
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            QMUILog(@"%@",response);
            
            [weakSelf.scoreButton setTitle:[NSString stringWithFormat:@"我的积分：%@",response[@"point"]] forState:UIControlStateNormal];
            weakSelf.score = [response[@"point"] floatValue];
            //是会员
            if ([response[@"vipstate"] boolValue] == YES) {
                weakSelf.vipImageView.image = [UIImage imageNamed:@"VIP1"];
                weakSelf.buyButtonWidthCons.constant = 0;
                NSString *outtimeStr = response[@"outtime"];
                NSDate *date = [NSDate dateWithString:outtimeStr formatString:@"yyyy-MM-dd HH:mm:ss"];
                weakSelf.vipLabel.text = [NSString stringWithFormat:@"%@ 到期时间： %@",response[@"des"],[date formattedDateWithFormat:@"yyyy-MM-dd"]];
            }else{
                weakSelf.vipImageView.image = [UIImage imageNamed:@"VIP2"];
                weakSelf.vipLabel.text = @"您还不是VIP会员";
                weakSelf.buyButtonWidthCons.constant = 60;
            }
        }
    } error:^(NSError *error) {
        
    }];
    
}
- (IBAction)signButtonClick:(id)sender {
    YYBaseRequest *request = [YYBaseRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kSignAPI]];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            [QMUITips showSucceed:message inView:weakSelf.view hideAfterDelay:1.5];
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:1.5];
        }
    }];
}

- (IBAction)scoreButtonClick:(id)sender {
    YYScoreViewController *scoreViewController = [[UIStoryboard storyboardWithName:@"Score" bundle:nil] instantiateViewControllerWithIdentifier:@"score"];
    scoreViewController.score = self.score;
    [self.navigationController pushViewController:scoreViewController animated:YES];
}


- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return YES;
}


- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutButtoonClick:(id)sender {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
        [YYUserManager logout];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录吗" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[YYMyWalletViewController class]]) {
        [segue.destinationViewController setValue:self.model forKey:@"model"];
    }
    if ([segue.destinationViewController isKindOfClass:[YYSettingViewController class]]) {
        [segue.destinationViewController setValue:@(self.used) forKey:@"used"];
    }
}

- (IBAction)serviceButtonClick:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"0596-2671066" message:[NSString stringWithFormat:@"%@",@""] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"0596-2671066"]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)guideButtonClick:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:kReadMessageKey];
    YYGuideViewController *guideViewController = [[YYGuideViewController alloc] init];
    [self.navigationController pushViewController:guideViewController animated:YES];
}



@end
