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
#import "YYChargeItemViewCell.h"
#import "NSNotificationCenter+Addition.h"
#import "YYBaseRequest.h"
#import "YYChargeItemModel.h"
#import <BEMCheckBox/BEMCheckBox.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <QMUIKit/QMUIKit.h>


#define ButtonHeight 75

@interface YYChargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ChargeItemDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray<YYChargeItemModel *> *models;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;

@property (weak, nonatomic) IBOutlet BEMCheckBox *wechatCheckBox;

@property (weak, nonatomic) IBOutlet BEMCheckBox *aliCheckBox;

@property (nonatomic,strong) BEMCheckBox *currentCheckBox;

@property (weak, nonatomic) IBOutlet UILabel *chargeValueLabel;

@end

@implementation YYChargeViewController

-(NSMutableArray<YYChargeItemModel *> *)models
{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentCheckBox = self.wechatCheckBox;
    self.extendedLayoutIncludesOpaqueBars = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth - 44) * 0.5  - 10, 65);
    self.collectionView.collectionViewLayout = layout;
    self.title = @"充值";
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];
    
    [WXApi registerApp:@"wx535feea77188fcab"];

    [self requestChargeValue];
}

- (void) requestChargeValue
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kPayParamsAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYChargeItemModel modelArrayWithDictArray:response];
            if (weakSelf.models.count % 2 == 0) {
                weakSelf.collectionViewHeightCons.constant = ButtonHeight * weakSelf.models.count / 2;
            }else{
                 weakSelf.collectionViewHeightCons.constant = ButtonHeight *(weakSelf.models.count / 2 + 1);
            }
            if (weakSelf.models.count > 0) {
                weakSelf.models[0].selected = YES;
                weakSelf.chargeValueLabel.text = [NSString stringWithFormat:@"%.0f元",weakSelf.models[0].price];
            }
            [weakSelf.collectionView reloadData];
            QMUILog(@"%@",response);
        }
    } error:^(NSError *error) {
        
    }];
    
}

- (IBAction)selectButtonClick:(BEMCheckBox *)sender {
    [self.currentCheckBox setOn:NO animated:NO];
    [sender setOn:YES animated:YES];
    self.currentCheckBox = sender;
}

-(void)YYChargeItemViewCell:(YYChargeItemViewCell *)cell didClickCurrentButton:(UIButton *)sender
{
    for (YYChargeItemModel *model in self.models) {
        if (model.index != cell.model.index) {
            model.selected = NO;
        }else{
            model.selected = YES;
            self.chargeValueLabel.text = [NSString stringWithFormat:@"%.0f元",self.models[cell.model.index].price];
        }
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYChargeItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"charge" forIndexPath:indexPath];
    cell.delegate = self;
    YYChargeItemModel *model = self.models[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    return cell;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)chargeButtonClick:(id)sender {
    YYCreateBlanceRequest *request = [[YYCreateBlanceRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,KCreatePayBalanceAPI];
    CGFloat price = 0;
    for (YYChargeItemModel *model in self.models) {
        if (model.selected) {
            price = model.price;
        }
    }
    request.price = price;
    if (self.aliCheckBox.on) {
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
