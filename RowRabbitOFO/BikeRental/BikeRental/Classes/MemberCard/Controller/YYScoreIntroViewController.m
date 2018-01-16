//
//  YYScoreIntroViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/28.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYScoreIntroViewController.h"
#import "YYFileCacheManager.h"
#import <QMUIKit/QMUIKit.h>

@interface YYScoreIntroViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) IBOutlet QMUITextView *remarkTextField;


@end

@implementation YYScoreIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"积分说明";
    self.extendedLayoutIncludesOpaqueBars = NO;
    
   self.remarkTextField.text = [YYFileCacheManager readUserDataForKey:@"config"][@"pointMsg"];
}


@end
