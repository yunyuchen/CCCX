//
//  YYContractUsViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/1.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYContractUsViewController.h"
#import "Masonry.h"


@interface YYContractUsViewController ()


@property (nonatomic,strong) UIWebView *webView;

@end

@implementation YYContractUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bs.51xytu.com/htm/concatus.htm"]]];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.webView = webView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
