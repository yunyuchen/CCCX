//
//  YYFeeIntroViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/28.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYFeeIntroViewController.h"
#import "Masonry.h"
#import "YYFileCacheManager.h"

@interface YYFeeIntroViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation YYFeeIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"计费说明";
    self.extendedLayoutIncludesOpaqueBars = NO;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[YYFileCacheManager readUserDataForKey:@"config"][@"chargeUrl"]]]];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.webView = webView;
    // 状态栏(statusbar)
    CGRect StatusRect=[[UIApplication sharedApplication] statusBarFrame];
    //标题
    CGRect NavRect=self.navigationController.navigationBar.frame;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, StatusRect.size.height + NavRect.size.height)];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(StatusRect.size.height + NavRect.size.height);
    }];
    topView.backgroundColor = [UIColor whiteColor];
}

@end
