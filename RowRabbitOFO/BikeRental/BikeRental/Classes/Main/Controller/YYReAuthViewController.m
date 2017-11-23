//
//  YYReAuthViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/8.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYReAuthViewController.h"

@interface YYReAuthViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;


@end

@implementation YYReAuthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 对 self.view 的操作写在这里
    [self setUpTopView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void) setUpTopView
{
    CGFloat margin = (kScreenWidth - 2 * 50) / 4;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通过"]];
    imageView1.left = 50;
    imageView1.top = 80;
    [self.topView addSubview:imageView1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView1.frame) + 8, 68, 20)];
    label1.centerX = imageView1.centerX;
    label1.text = @"手机绑定";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor colorWithHexString:@"#F08300"];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label1];
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame), imageView1.top, margin, 20)];
    [self.topView addSubview:sep1];
    UIImageView *arrwowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头11"]];
    arrwowImage.centerX = sep1.width * 0.5;
    arrwowImage.centerY = sep1.height * 0.5;
    [sep1 addSubview:arrwowImage];
    
    
    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step2Button.left = CGRectGetMaxX(sep1.frame);
    step2Button.top = 80;
    step2Button.layer.cornerRadius = 10;
    step2Button.layer.masksToBounds = YES;
    step2Button.width = step2Button.height = 20;
    [step2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step2Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step2Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step2Button setTitle:@"2" forState:UIControlStateNormal];
    [self.topView addSubview:step2Button];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step2Button.frame) + 8, 100, 20)];
    label2.centerX = step2Button.centerX;
    label2.text = @"实名认证";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithHexString:@"#404040"];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label2];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step2Button.frame), imageView1.top, margin, 1)];
    [self.topView addSubview:sep2];
    UIImageView *arrwowImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头22"]];
    arrwowImage1.centerX = sep1.width * 0.5;
    arrwowImage1.centerY = sep1.height * 0.5;
    [sep2 addSubview:arrwowImage1];
    
    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step3Button.left = CGRectGetMaxX(sep2.frame);
    step3Button.top = 80;
    step3Button.layer.cornerRadius = 10;
    step3Button.layer.masksToBounds = YES;
    step3Button.width = step3Button.height = 20;
    [step3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step3Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step3Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step3Button setTitle:@"3" forState:UIControlStateNormal];
    [self.topView addSubview:step3Button];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step3Button.frame) + 8, 68, 20)];
    label3.centerX = step3Button.centerX;
    label3.text = @"押金充值";
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = [UIColor colorWithHexString:@"#404040"];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label3];
    
    
    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step3Button.frame), imageView1.top, margin, 1)];
    [self.topView addSubview:sep3];
    UIImageView *arrwowImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头22"]];
    arrwowImage2.centerX = sep1.width * 0.5;
    arrwowImage2.centerY = sep1.height * 0.5;
    [sep3 addSubview:arrwowImage2];
    
    UIButton *step4Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step4Button.left = CGRectGetMaxX(sep3.frame);
    step4Button.top = 80;
    step4Button.layer.cornerRadius = 10;
    step4Button.layer.masksToBounds = YES;
    step4Button.width = step4Button.height = 20;
    [step4Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step4Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step4Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step4Button setTitle:@"4" forState:UIControlStateNormal];
    [self.topView addSubview:step4Button];
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step4Button.frame) + 8, 68, 20)];
    label4.centerX = step4Button.centerX;
    label4.text = @"开始用车";
    label4.font = [UIFont systemFontOfSize:12];
    label4.textColor = [UIColor colorWithHexString:@"#404040"];
    label4.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label4];
    
}

- (IBAction)dismissButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end