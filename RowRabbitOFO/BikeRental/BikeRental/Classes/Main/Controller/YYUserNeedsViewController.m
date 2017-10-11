//
//  YYUserNeedsViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYUserNeedsViewController.h"
#import "Masonry.h"

@interface YYUserNeedsViewController ()

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation YYUserNeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dingdangddc.com/htm/userguide.htm"]]];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.webView = webView;
    self.navigationItem.title = @"用户须知";
    [UINavigationBar appearance].tintColor = [UIColor colorWithHexString:@"#ED1847"];
    
    //设置导航栏的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#ED1847"]] forBarMetrics:UIBarMetricsDefault];
    
    // 去掉导航栏底部阴影
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#ED1847"];
    // Do any additional setup after loading the view.
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = (CGRect){CGPointZero,CGSizeMake(1.0, 1.0)};
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
