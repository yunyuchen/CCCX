//
//  YYFinishedViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/18.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYFinishedViewController.h"

@interface YYFinishedViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,assign) CGFloat angle;

@property (nonatomic,strong) UIImageView *tranformImageView;

@end

@implementation YYFinishedViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTopView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpTopView
{
    CGFloat margin = (kScreenWidth - 2 * 50) / 4;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"22完成"]];
    imageView1.left = 50;
    imageView1.top = 70;
    [self.topView addSubview:imageView1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView1.frame) + 8, 68, 20)];
    label1.centerX = imageView1.centerX;
    label1.text = @"手机绑定";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor colorWithHexString:@"#404040"];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label1];
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame), imageView1.centerY, margin, 1)];
    sep1.backgroundColor = [UIColor colorWithHexString:@"#C90530"];
    [self.topView addSubview:sep1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"22完成"]];
    imageView2.left = CGRectGetMaxX(sep1.frame);
    imageView2.top = 70;
    [self.topView addSubview:imageView2];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView2.frame) + 8, 100, 20)];
    label2.centerX = imageView2.centerX;
    label2.text = @"芝麻信用认证";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithHexString:@"#404040"];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label2];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame), imageView1.centerY, margin, 1)];
    sep2.backgroundColor = [UIColor colorWithHexString:@"#C90530"];
    [self.topView addSubview:sep2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"22完成"]];
    imageView3.left = CGRectGetMaxX(sep2.frame);
    imageView3.top = 70;
    [self.topView addSubview:imageView3];

    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView3.frame) + 8, 68, 20)];
    label3.centerX = imageView3.centerX;
    label3.text = @"押金充值";
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = [UIColor colorWithHexString:@"#404040"];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label3];
    
    
    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView3.frame), imageView1.centerY, margin, 1)];
    sep3.backgroundColor = [UIColor colorWithHexString:@"#C90530"];
    [self.topView addSubview:sep3];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"23激活中"]];
    imageView4.left = CGRectGetMaxX(sep3.frame);
    imageView4.top = 70;
    [self.topView addSubview:imageView4];
    self.tranformImageView = imageView4;
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView4.frame) + 8, 68, 20)];
    label4.centerX = imageView4.centerX;
    label4.text = @"开始用车";
    label4.font = [UIFont systemFontOfSize:12];
    label4.textColor = [UIColor colorWithHexString:@"#404040"];
    label4.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label4];
    
    [self startAnimation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"28背景02"]];
    arrowImageView.centerY = self.topView.height - arrowImageView.height * 0.5;
    arrowImageView.centerX = self.tranformImageView.centerX;
    [self.view addSubview:arrowImageView];
}

-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.tranformImageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void) endAnimation
{
    _angle += 10;
    [self startAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)beginButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}


@end
