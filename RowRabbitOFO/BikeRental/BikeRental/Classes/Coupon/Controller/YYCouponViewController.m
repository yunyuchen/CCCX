//
//  YYCouponViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYCouponViewController.h"
#import "YYEnabledCouponViewController.h"
#import "YYDisabledCouponViewController.h"

@interface YYCouponViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *underLineView;

@property (nonatomic,strong) NSMutableArray *buttons;

@property (nonatomic,strong) UIButton *selectedButton;

@end

@implementation YYCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildViewController];
    
    [self setUpScrollView];
    
    [self setUpTitleView];
    
    [self scrollViewDidEndDecelerating:self.scrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F6F7"];
}



/*** 设置ScrollView*/
-(void) setUpScrollView
{
    CGRect StatusRect=[[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect=self.navigationController.navigationBar.frame;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollView.pagingEnabled = YES;
    scrollView.frame = CGRectMake(0, StatusRect.size.height + NavRect.size.height + 44 + 20, kScreenWidth, kScreenHeight - 128);
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F6F7"];
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.qmui_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

-(void) setUpTitleView
{
    self.navigationItem.title = @"我的订单";
    CGRect StatusRect=[[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect=self.navigationController.navigationBar.frame;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusRect.size.height + NavRect.size.height, kScreenWidth, 44)];
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArray = @[@"可使用",@"不可使用"];
    
    CGFloat buttonW = kScreenWidth / 2;
    CGFloat buttonH = 44;
    self.buttons = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        [titleButton setTitle:titleArray[i] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleButton setTitleColor:[UIColor qmui_colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor qmui_colorWithHexString:@"#F08300"] forState:UIControlStateSelected];
        titleButton.tag = i;
        [titleView addSubview:titleButton];
        [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.selectedButton = titleButton;
            self.selectedButton.selected = YES;
        }
        [self.buttons addObject:titleButton];
    }
    
    
    UIView *underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 30, 2)];
    underLineView.backgroundColor = self.selectedButton.currentTitleColor;
    [titleView addSubview:underLineView];
    self.underLineView = underLineView;
    self.underLineView.centerX = self.selectedButton.centerX;
    underLineView.centerX = self.selectedButton.centerX;
}

-(void) setUpChildViewController
{
    YYEnabledCouponViewController *enabledCouponViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Enabledcoupon"];
    [self addChildViewController:enabledCouponViewController];
    
    YYDisabledCouponViewController *disabledCouponViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Disabledcoupon"];
    [self addChildViewController:disabledCouponViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) buttonClick:(UIButton *)sender
{
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    [UIView animateWithDuration:0.5 animations:^{
        self.underLineView.centerX = sender.centerX;
    }];
    [self.scrollView setContentOffset:CGPointMake(sender.tag * kScreenWidth, 0) animated:YES];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / kScreenWidth;
    [self buttonClick:self.buttons[index]];
    
    UITableViewController *childController = self.childViewControllers[index];
    if (childController.isViewLoaded) return;
    childController.view.frame = scrollView.bounds;
    [scrollView addSubview:childController.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return NO;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"我的优惠券";
}

@end
