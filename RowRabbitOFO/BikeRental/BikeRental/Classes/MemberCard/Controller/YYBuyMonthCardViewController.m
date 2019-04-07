//
//  YYBuyMonthCardViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2019/3/29.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import "YYBuyMonthCardViewController.h"
#import "YYCardModel.h"
#import "YYMonthCardViewCell.h"
#import "YYBaseRequest.h"
#import "YYSelectPayView.h"
#import "YYCreateVipRequest.h"
#import "NSNotificationCenter+Addition.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface YYBuyMonthCardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YYSelectPayViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSArray<YYCardModel *> *models;

@property(nonatomic, strong) YYCardModel *selectedCard;

@property(nonatomic, strong) QMUIModalPresentationViewController *modalPrentViewController;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation YYBuyMonthCardViewController

-(NSArray<YYCardModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];
    [self setUpCollectionView];
    
    [self requestCardList];
}


-(void)dealloc
{
    [NSNotificationCenter removeAllObserverForObj:self];
}

-(void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated
{
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"购买月卡";
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
            strMsg = @"订单支付成功！";
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

-(void) requestCardList
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCardListAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYCardModel modelArrayWithDictArray:response];
            [weakSelf.models enumerateObjectsUsingBlock:^(YYCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    obj.selected = YES;
                    weakSelf.selectedCard = obj;
                    weakSelf.priceLabel.text = [NSString stringWithFormat:@"¥ %.0f",weakSelf.selectedCard.price];
                }
            }];
            [weakSelf.collectionView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.models enumerateObjectsUsingBlock:^(YYCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        self.selectedCard = obj;
    }];
    self.models[indexPath.row].selected = YES;
    self.selectedCard = self.models[indexPath.row];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.0f",self.selectedCard.price];
    [self.collectionView reloadData];
}

- (void) setUpCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 4 * 15) / 3, 94);
    self.collectionView.collectionViewLayout = layout;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYMonthCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthCardViewCell" forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
    
}

- (IBAction)payButtonClick:(id)sender {
    YYSelectPayView *payView = [[YYSelectPayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 279)];
    payView.delegate = self;
    payView.price = self.selectedCard.price;
    payView.vipId = self.selectedCard.ID;
    CGFloat bottomMargin = (kScreenHeight - payView.height) * 0.5;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = payView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.contentViewMargins = UIEdgeInsetsMake(0, 0,-2 *bottomMargin, 0);
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
}


#pragma mark - payViewDelegate
-(void)YYSelectPayView:(YYSelectPayView *)payView didClickPayButton:(UIButton *)sender
{
    [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
    YYCreateVipRequest *request = [[YYCreateVipRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreatePayCardAPI];
    if (payView.payType == 0) {
        request.ptype = 1;
    }else{
        request.ptype = 0;
    }
    request.cardid = self.selectedCard.ID;
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
