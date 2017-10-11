//
//  YYMyWalletViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/18.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMyWalletViewController.h"
#import "YYWalletViewCell.h"
#import "YYBaseRequest.h"
#import "YYRecordModel.h"
#import "YYFileCacheManager.h"
#import <QMUIKit/QMUIKit.h>
#import <DateTools/DateTools.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface YYMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@property (weak, nonatomic) IBOutlet UILabel *depositLabel;

@property (nonatomic,strong) NSMutableArray<YYRecordModel *> *models;

@property (weak, nonatomic) IBOutlet UILabel *ylabel;

@property (weak, nonatomic) IBOutlet UIButton *moneyStateLabel;

@property (weak, nonatomic) IBOutlet UIButton *sesameStateLabel;

@property (weak, nonatomic) IBOutlet UIButton *vipLabel;


@end

@implementation YYMyWalletViewController

-(NSMutableArray<YYRecordModel *> *)models
{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.topView.layer.cornerRadius = 5;
    self.topView.layer.masksToBounds = YES;
    NSLog(@"%.1f",self.model.money);
    self.depositLabel.text = [NSString stringWithFormat:@"%.1f",self.model.money];
    self.ylabel.text =  [NSString stringWithFormat:@"押金%.0f元",self.model.deposit];
    // Do any additional setup after loading the view.
    //[self requestRecord];
}


-(void) getUserInfoRequest
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.model = [YYUserModel modelWithDictionary:response];
            if (!weak_self.model.vipstate) {
                weak_self.vipLabel.hidden = YES;
            }else{
                weak_self.vipLabel.hidden = NO;
            }
            NSString *vipType = @"";
            switch (weak_self.model.vip) {
                case 1:
                    vipType = @"月卡";
                    break;
                case 2:
                    vipType = @"季卡";
                    break;
                default:
                    vipType = @"年卡";
                    break;
            }

            [weak_self.vipLabel setTitle:[NSString stringWithFormat:@"  %@ %@到期",vipType, [[NSDate dateWithString:weak_self.model.outtime formatString:@"yyyy-MM-dd hh:mm:ss"] formattedDateWithStyle:NSDateFormatterShortStyle]] forState:UIControlStateNormal];
            NSString *zmscore = [YYFileCacheManager readUserDataForKey:@"config"][@"zmscore"];
            if (weak_self.model.zmstate == 0) {
                [weak_self.sesameStateLabel setTitle:[NSString stringWithFormat:@"未通过芝麻信用（＜%@分)",zmscore] forState:UIControlStateNormal];
                [weak_self.sesameStateLabel setImage:nil forState:UIControlStateNormal];
            }else{
                [weak_self.sesameStateLabel setTitle:[NSString stringWithFormat:@"成功通过芝麻信用（≥%@分）",zmscore] forState:UIControlStateNormal];
                [weak_self.sesameStateLabel setImage:[UIImage imageNamed:@"aj_成功"] forState:UIControlStateNormal];
            }
            weak_self.depositLabel.text = [NSString stringWithFormat:@"%.1f",self.model.money];
            weak_self.ylabel.text =  [NSString stringWithFormat:@"押金%.0f元",self.model.deposit];
            switch (weak_self.model.dstate) {
                case 0:
                    [weak_self.moneyStateLabel setTitle:@"未缴押金" forState:UIControlStateNormal];
                    weak_self.moneyStateLabel.userInteractionEnabled = NO;
                    break;
                case 1:
                      [weak_self.moneyStateLabel setTitle:@"押金正常(点击申请退款)" forState:UIControlStateNormal];
                    break;
                case 2:
                    [weak_self.moneyStateLabel setTitle:@"押金退还中"forState:UIControlStateNormal];
                    weak_self.moneyStateLabel.userInteractionEnabled = NO;
                    break;
                case 3:
                    [weak_self.moneyStateLabel setTitle:@"押金已退"forState:UIControlStateNormal];
                    weak_self.moneyStateLabel.userInteractionEnabled = NO;
                    break;
                default:
                    break;
            }
        }
    } error:^(NSError *error) {
        
    }];
}

-(void) requestRecord
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAcclogAPI];
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.models = [YYRecordModel modelArrayWithDictArray:response];
            
            [weak_self.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestRecord];
    
    [self getUserInfoRequest];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)refundButtonClick:(id)sender {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
        YYBaseRequest *request = [[YYBaseRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kRefundAPI];
        WEAK_REF(self);
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(300, 100);
                [tips showSucceed:@"申请成功" hideAfterDelay:2];
                [weak_self getUserInfoRequest];
            }else{
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(300, 100);
                [tips showError:message hideAfterDelay:2];
            }
        } error:^(NSError *error) {
            
        }];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"确定申请退款么" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYWalletViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletViewCell"];
    cell.model = self.models[indexPath.row];
    return cell;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"31背景"];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"当前没有明细" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    return str;
}


@end
