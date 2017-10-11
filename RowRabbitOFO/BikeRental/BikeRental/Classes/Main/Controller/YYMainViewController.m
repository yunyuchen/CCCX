//
//  YYMainViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMainViewController.h"
#import "UIImage+Color.h"
#import "YYRentalViewController.h"
#import "YYUserNeedsViewController.h"
#import "YYFreightViewController.h"
#import "YYAboutUSViewController.h"
#import "YYFeedBackViewController.h"
#import "YYContractUsViewController.h"
#import "NSNotificationCenter+Addition.h"
#import "YYSiteModel.h"
#import "Masonry.h"

@interface YYMainViewController ()

@property (nonatomic,strong) NSArray *normalImages;

@property (nonatomic,strong) NSArray *selectedImages;

@property (nonatomic,strong) NSMutableArray<UIButton *> *buttonArray;

@property (nonatomic,strong) UIButton *selectedButton;

@property (nonatomic,strong) UIView *rightView;

@property (nonatomic,strong) UIView *lineView;

@property (strong, nonatomic)  UIButton *indexButton;

@property (strong, nonatomic)  UIButton *personalCenterButton;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong,nonatomic) UIButton *selectedIndexBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,assign) NSInteger flag;

@end

@implementation YYMainViewController

-(NSMutableArray<UIButton *> *)buttonArray
{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initImages];
    
    [self initLeftMenus];
    
    [self initChildViewControllers];
    
    self.nameLabel.text = self.name;

    [NSNotificationCenter addObserver:self action:@selector(refreshAction:) name:kSiteRefreshNotifaction];
}

-(void) refreshAction:(NSNotification *)noti
{
    YYSiteModel *model = (YYSiteModel *)noti.object;
    self.nameLabel.text = model.name;
}

-(void) initLineView
{
    UIButton *personalCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalCenterButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [personalCenterButton setTitleColor:[UIColor colorWithHexString:@"#A2A2A2"] forState:UIControlStateNormal];
    [personalCenterButton setTitleColor:[UIColor colorWithHexString:@"#404040"] forState:UIControlStateSelected];
    personalCenterButton.titleLabel.font = [UIFont systemFontOfSize:12];
    personalCenterButton.frame = CGRectMake(kScreenWidth - 88, self.topView.height - 24, 80, 20);
    [self.topView addSubview:personalCenterButton];
    [personalCenterButton addTarget:self action:@selector(indexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.personalCenterButton = personalCenterButton;
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    indexButton.selected = YES;
    [indexButton setTitle:@"首页" forState:UIControlStateNormal];
    [indexButton setTitleColor:[UIColor colorWithHexString:@"#A2A2A2"] forState:UIControlStateNormal];
    [indexButton setTitleColor:[UIColor colorWithHexString:@"#404040"] forState:UIControlStateSelected];
    indexButton.titleLabel.font = [UIFont systemFontOfSize:12];
    indexButton.frame = CGRectMake(CGRectGetMinX(personalCenterButton.frame) - 88, personalCenterButton.top, 80, 20);
    [indexButton addTarget:self action:@selector(indexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:indexButton];
    self.indexButton = indexButton;
    self.selectedIndexBtn = indexButton;
    
    UIView *lineView = [[UIView alloc] init];
    [self.topView addSubview:lineView];
    self.lineView = lineView;
    lineView.width = 40;
    lineView.height = 3;
    lineView.centerX = indexButton.centerX;
    lineView.centerY = indexButton.centerY + 13;
    lineView.backgroundColor = [UIColor colorWithHexString:@"#ED1847"];

}


-(void) indexButtonClick:(UIButton *)sender
{
    self.selectedIndexBtn.selected = NO;
    sender.selected = YES;
    self.selectedIndexBtn = sender;

    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.centerX = sender.centerX;
    }];
}

-(void) initChildViewControllers
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    YYRentalViewController *rentalViewController = [storyboard instantiateViewControllerWithIdentifier:@"rental"];
    rentalViewController.sid = self.sid;
    [self addChildViewController:rentalViewController];
    YYUserNeedsViewController *userNeedsViewController = [[YYUserNeedsViewController alloc] init];
    [self addChildViewController:userNeedsViewController];
    
    YYFreightViewController *freightViewController = [[YYFreightViewController alloc] init];
    [self addChildViewController:freightViewController];
    
    YYContractUsViewController *aboutUSViewController = [[YYContractUsViewController alloc] init];
    [self addChildViewController:aboutUSViewController];
    
    YYFeedBackViewController *feedBackViewController = [storyboard instantiateViewControllerWithIdentifier:@"feedback"];
    [self addChildViewController:feedBackViewController];
    
    UIView *rightView = rentalViewController.view;
    rightView.frame = CGRectMake(CGRectGetMaxX(self.selectedButton.frame), 103, kScreenWidth - self.selectedButton.width, kScreenHeight - 103);
    [self.view addSubview:rightView];
    self.rightView = rightView;
}

-(void) initLeftMenus
{
    CGFloat buttonH = (kScreenHeight - 103) / 6;
    CGFloat selectedButtonH = 2 * buttonH;
    CGFloat buttonW = kScreenWidth * 0.3;
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ED1847"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#C90530"]] forState:UIControlStateSelected];
        if (i == 0) {
            btn.frame = CGRectMake(0, 103, buttonW, selectedButtonH);
            btn.selected = YES;
            self.selectedButton = btn;
        }else{
            btn.frame = CGRectMake(0, 103 + selectedButtonH + (i - 1) * buttonH, buttonW, buttonH);
        }
        
        [btn setImage:[UIImage imageNamed:self.normalImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.selectedImages[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.buttonArray addObject:btn];
        [self.view addSubview:btn];
    }


}

-(void) initImages
{
    self.normalImages = @[@"10租车信息02",@"11用户需知02",@"12计费标准02",@"13联系我们02",@"14反馈保修02"];
    self.selectedImages = @[@"10租车信息01",@"11用户需知01",@"12计费标准01",@"13联系我们01",@"14反馈保修01"];
}
//邀请你的好友注册行运兔，你就可以获得5元奖励，奖励以余额的形式充入邀请人账户。
//
//你邀请的好友完成实名认证，你可以额外获得5元奖励，奖励以余额的形式充入邀请人账户。
//
//被邀请人完成行运兔app注册，即可获得10元新手奖励，奖励以余额的形式充入被邀请人账户。
//
//如果用户在活动期间，虚构操作或有其他违反平台规定的情形，将取消全部活动奖励，给行运兔平台或运营方造成损失的，将不允许继续使用平台服务。
-(void) buttonClick:(UIButton *)sender
{
    CGFloat buttonH = (kScreenHeight - 103) / 6;
    if (sender.selected == YES) {
        return;
    }
    if (sender.tag > self.selectedButton.tag) {
        for (NSInteger i = self.selectedButton.tag + 1; i <= sender.tag; i++) {
            self.buttonArray[i].top -= buttonH;
        }
    }else{
        for (NSInteger i = self.selectedButton.tag - 1; i >= sender.tag; i--) {
            self.buttonArray[i+1].top += buttonH;
        }
        //self.buttonArray[sender.tag+1].top += buttonH;
    }
    self.selectedButton.selected = NO;
    self.selectedButton.height = buttonH;
    sender.selected = YES;
    self.selectedButton = sender;
    self.selectedButton.height = buttonH * 2;

    if (self.rightView) {
        [self.rightView removeFromSuperview];
    }
    
    UIView *rightView = self.childViewControllers[sender.tag].view;
    rightView.frame = CGRectMake(CGRectGetMaxX(sender.frame), 103, kScreenWidth - sender.width, kScreenHeight - 103);
    [self.view addSubview:rightView];
    self.rightView = rightView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)tapAction:(id)sender {
    self.flag = 2;
    [self performSegueWithIdentifier:@"desSegue" sender:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
