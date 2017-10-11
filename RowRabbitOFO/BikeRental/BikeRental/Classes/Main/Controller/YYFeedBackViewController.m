//
//  YYFeedBackViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYFeedBackViewController.h"
#import "YYFeedBackRequest.h"
#import <QMUIKit/QMUIKit.h>

@interface YYFeedBackViewController ()

@property (weak, nonatomic) IBOutlet UIButton *dialogButton;

@property (weak, nonatomic) IBOutlet QMUITextView *desTextView;

@property (weak, nonatomic) IBOutlet QMUITextField *telTextField;

@end

@implementation YYFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dialogButtonClick:(id)sender {
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"问题类型";
    //车辆硬件问题,车把.轮胎.电池等
//    车辆控制器问题, 无法解锁上锁
//    车辆电池电量不足, 无法使用
//    车辆无法归还到指定站点
//    站点太少, 找不到站点
//    其他问题
    dialogViewController.items = @[@"车辆硬件问题,车把.轮胎.电池等",@"车辆控制器问题, 无法解锁上锁",@"车辆电池电量不足, 无法使用",@"车辆无法归还到指定站点",@"站点太少, 找不到站点",@"其他问题"];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        [aDialogViewController hide];
        [self.dialogButton setTitle:aDialogViewController.items[itemIndex] forState:UIControlStateNormal];
    };
    [dialogViewController show];
}

- (IBAction)submitButtonClick:(id)sender {
//    YYFeedBackRequest *request = [[YYFeedBackRequest alloc] init];
//    request.title = self.dialogButton.currentTitle;
//    request.des = self.desTextView.text;
//    request.tel = self.telTextField.text;
//    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFeedBackAPI];
//    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
//    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
//    contentView.minimumSize = CGSizeMake(100, 100);
//    [tips showLoading];
//    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//        [tips hideAnimated:YES];
//        if (success) {
//            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
//            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
//            contentView.minimumSize = CGSizeMake(100, 100);
//            [tips showSucceed:@"提交成功" hideAfterDelay:2];
//        }else{
//            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
//            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
//            contentView.minimumSize = CGSizeMake(100, 100);
//            [tips showError:message hideAfterDelay:2];
//        }
//        
//    } error:^(NSError *error) {
//            [tips hideAnimated:YES];
//    }];
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
