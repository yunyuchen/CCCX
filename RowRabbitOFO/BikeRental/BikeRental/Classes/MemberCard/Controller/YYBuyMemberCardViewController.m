//
//  YYBuyMemberCardViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBuyMemberCardViewController.h"
#import "YYMemberCardViewCell.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace_h.h"
#import "YYPayView.h"
#import "YYBaseRequest.h"
#import "YYCreateVipRequest.h"
#import "YYCardModel.h"
#import "YYFileCacheManager.h"
#import "NSNotificationCenter+Addition.h"
#import <DateTools/DateTools.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface YYBuyMemberCardViewController ()<UITableViewDelegate,UITableViewDataSource,YYPayViewDelegate>

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *memberCardRemarkLabel;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property(nonatomic, strong) NSArray<YYCardModel *> *models;

@property (weak, nonatomic) IBOutlet UIButton *vipButton;


@end

@implementation YYBuyMemberCardViewController

-(NSArray<YYCardModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.memberCardRemarkLabel.text = [YYFileCacheManager readUserDataForKey:@"config"][@"vipmsg"];
     [UILabel changeLineSpaceForLabel:self.memberCardRemarkLabel WithSpace:6];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
   
    
    [self requestVipList];
    
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfo];
}


- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"购买VIP会员";
}

- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return NO;
}

- (void) getUserInfo
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserinfoAPI];
    
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            QMUILog(@"%@",response);
            NSString *outtimeStr = response[@"outtime"];
            NSDate *date = [NSDate dateWithString:outtimeStr formatString:@"yyyy-MM-dd HH:mm:ss"];
            //是会员
            if ([response[@"vipstate"] boolValue] == YES) {
                [weakSelf.vipButton setTitle:[NSString stringWithFormat:@"%@ 有效期至 %@",response[@"des"],[date formattedDateWithFormat:@"yyyy-MM-dd"]] forState:UIControlStateNormal];
                [weakSelf.vipButton setImage:[UIImage imageNamed:@"VIP1"] forState:UIControlStateNormal];
            
            }else{
               
            }
        }
    } error:^(NSError *error) {
        
    }];
    
}

- (void) requestVipList
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kVipListAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYCardModel modelArrayWithDictArray:response];
//            YYCardModel *tmpModel = nil;
//            for (YYCardModel *model in weakSelf.models) {
//                if (tmpModel == nil) {
//                    tmpModel = model;
//                }else{
//                    if (tmpModel.discount > model.discount) {
//                        tmpModel = model;
//                    }
//                }
//            }
//            for (YYCardModel *model in weakSelf.models) {
//                if (model.ID == tmpModel.ID) {
//                    model.recommend = YES;
//                    break;
//                }
//            }
            [weakSelf.models enumerateObjectsUsingBlock:^(YYCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    obj.recommend = YES;
                }
            }];
            
            [weakSelf.tableView reloadData];
            QMUILog(@"%@",response);
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }
    }];
    
}




#pragma mark - tableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYMemberCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCard"];
    cell.model = self.models[indexPath.row];
    cell.priceClickBlock = ^{
        YYPayView *payView = [[YYPayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 278)];
        payView.delegate = self;
        payView.price = self.models[indexPath.row].price;
        payView.vipId = self.models[indexPath.row].ID;
        CGFloat bottomMargin = (kScreenHeight - payView.height) * 0.5;
        QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
        modalViewController.contentView = payView;
        modalViewController.maximumContentViewWidth = kScreenWidth;
        modalViewController.contentViewMargins = UIEdgeInsetsMake(0, 0,-2 *bottomMargin, 0);
        modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
        [modalViewController showWithAnimated:YES completion:nil];
        self.modalPrentViewController = modalViewController;
    };
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYPayView *payView = [[YYPayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 278)];
    payView.delegate = self;
    payView.price = self.models[indexPath.row].price;
    payView.vipId = self.models[indexPath.row].ID;
    CGFloat bottomMargin = (kScreenHeight - payView.height) * 0.5;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = payView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.contentViewMargins = UIEdgeInsetsMake(0, 0,-2 *bottomMargin, 0);
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
}

-(void) paySuccessAction:(NSNotification *)noti
{
    [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) wechatPaySuccessAction:(NSNotification *)noti
{
    NSString *strMsg = @"";
    BaseResp *resp = (BaseResp *)(noti.object);
    switch (resp.errCode) {
        case WXSuccess:
        {
            [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
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

#pragma mark - payViewDelegate
-(void)YYPayView:(YYPayView *)payView didClickPayButton:(UIButton *)sender
{
    [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
    YYCreateVipRequest *request = [[YYCreateVipRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreatePayVip];
    if (payView.payType == 0) {
        request.ptype = 1;
    }else{
        request.ptype = 0;
    }
    request.vipid = payView.vipId;
    if (payView.payType == 1) {
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                NSString *appScheme = @"chengchePay";
                NSString *orderString = [NSString stringWithFormat:@"%@",response];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }else{
                [QMUITips showWithText:message inView:self.view hideAfterDelay:2];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
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
            }else{
                [QMUITips showWithText:message inView:self.view hideAfterDelay:2];
            }
        } error:^(NSError *error) {
            
        }];
    }
}

@end
