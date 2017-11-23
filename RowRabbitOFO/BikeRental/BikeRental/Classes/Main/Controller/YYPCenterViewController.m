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
#import "YYInviteViewController.h"
#import "YYSettingViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <QMUIKit/QMUIKit.h>


@interface YYPCenterViewController ()

@property (weak, nonatomic) IBOutlet QMUIButton *logoutButton;

@property (nonatomic,strong) YYUserModel *model;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIView *dotView;


@end

@implementation YYPCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutButton.imagePosition = QMUIButtonImagePositionRight;
    self.fd_prefersNavigationBarHidden = YES;
    [self getUserInfoRequest];
    
    if (self.used) {
        self.logoutButton.hidden = YES;
    }
    
    if (kFetchReadMessageKey == nil) {
        self.dotView.hidden = NO;
        self.dotView.layer.cornerRadius = 5;
        self.dotView.layer.masksToBounds = YES;
    }else{
        self.dotView.hidden = YES;
    }
}

-(void) getUserInfoRequest
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.model = [YYUserModel modelWithDictionary:response];
            
            weak_self.telLabel.text = weak_self.model.tel;
        }
    } error:^(NSError *error) {
        
    }];
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
    if ([segue.destinationViewController isKindOfClass:[YYInviteViewController class]]) {
        [segue.destinationViewController setValue:@(self.model.ID) forKey:@"userId"];
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
     self.dotView.hidden = YES;
    YYGuideViewController *guideViewController = [[YYGuideViewController alloc] init];
    [self.navigationController pushViewController:guideViewController animated:YES];
}



@end
