//
//  YYUseBikeViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/19.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYUseBikeViewController.h"
#import "MZTimerLabel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YYBaseRequest.h"
#import "YYUserModel.h"
#import "YYCreateOrderReuquest.h"
#import "YYOprateBikeRequest.h"
#import "YYReturnBikeRequest.h"
#import "YYReturnBikeViewController.h"
#import "YYReturnResultModel.h"
#import "YYRemoteReturnViewController.h"
#import "YYOrderInfoView.h"
#import <JDFTooltips/JDFTooltips.h>
#import <DateTools/DateTools.h>
#import <QMUIKit/QMUIKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MapKit/MapKit.h>

@interface YYUseBikeViewController ()<AMapLocationManagerDelegate,OrderInfoViewDelegate>

#define OPENOP  @"11"
#define CLOSEOP @"10"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

//底部View
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//内侧ImageView
@property (weak, nonatomic) IBOutlet UIImageView *outerImageView;

//外侧ImageView
@property (weak, nonatomic) IBOutlet UIImageView *innerImageView;

//开始按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;

//停止按钮
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

//秒表Label
@property (weak, nonatomic) IBOutlet MZTimerLabel *timeLabel;

//中间View
@property (weak, nonatomic) IBOutlet UIView *runView;

//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

//用户信息
@property (nonatomic,strong) YYUserModel *model;

//车辆信息
@property (weak, nonatomic) IBOutlet UILabel *driveLabel;

//剩余电量
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;

//可使用里程
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;

@property (nonatomic,strong) UIButton *returnButton;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (nonatomic,strong) YYReturnResultModel *returnResultModel;

@property (nonatomic,strong) JDFTooltipView *toolTipView;

@end

@implementation YYUseBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    self.driveLabel.text = [NSString stringWithFormat:@"ID:%ld",self.rentalModel.deviceid];
    self.batteryLabel.text = [NSString stringWithFormat:@"%.0f",self.rentalModel.last_percent * 100];
    self.mileageLabel.text = [NSString stringWithFormat:@"%.0f",self.rentalModel.last_mileage];
    
    [self setUpAnimation];

}

-(void) setUpAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = ULLONG_MAX;
    rotationAnimation.removedOnCompletion = false;
    [self.outerImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    CABasicAnimation* rotationAnimation1;
    rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation1.duration = 3.5;
    rotationAnimation1.cumulative = YES;
    rotationAnimation1.repeatCount = ULLONG_MAX;
    rotationAnimation1.removedOnCompletion = false;
    [self.innerImageView.layer addAnimation:rotationAnimation1 forKey:@"rotationAnimation"];
    
   
}

//获取用户状态信息
-(void) getUserInfoRequest
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.model = [YYUserModel modelWithDictionary:response];
            
            //用户有订单的情况
            if ([weak_self.model.hasorder isEqualToString:@"0"]) {
                weak_self.cancelButton.hidden = YES;
                NSDate *startDate = [NSDate dateWithString:weak_self.rentalModel.ctime formatString:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval time = [[NSDate date] secondsFrom:startDate];
                [weak_self.timeLabel setCountDownTime:time];
                weak_self.returnButton.hidden = NO;
                //[weak_self startRide];
            }else{
                weak_self.cancelButton.hidden = NO;
                weak_self.returnButton.hidden = YES;
            }
            //用户无订单
            
        }
    } error:^(NSError *error) {
        
    }];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.returnButton == nil) {
        UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnButton setTitle:@"还车" forState:UIControlStateNormal];
        [returnButton setBackgroundImage:[UIImage imageNamed:@"34还车"] forState:UIControlStateNormal];
        [returnButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [returnButton addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        returnButton.frame = CGRectMake(0, 0, 119, 119);
        returnButton.center = CGPointMake(kScreenWidth * 0.5, self.bottomView.top);
        [self.view addSubview:returnButton];
        returnButton.hidden = YES;
        self.returnButton = returnButton;
    }

    JDFTooltipView *tooltip = [[JDFTooltipView alloc] initWithTargetView:self.startButton hostView:self.view tooltipText:@"再次点击可临时停车" arrowDirection:JDFTooltipViewArrowDirectionUp width:200.0f];
    [tooltip show];
    self.toolTipView = tooltip;
    
    [self getUserInfoRequest];
}

-(void) createOrderReqeust
{
    YYCreateOrderReuquest *request = [[YYCreateOrderReuquest alloc] init];
    request.sid = self.rentalModel.sid;
    request.bid = self.rentalModel.ID;
    request.deviceid = self.rentalModel.deviceid;
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreateOrderAPI];
    WEAK_REF(self);
    QMUITips *tips = [QMUITips createTipsToView:self.view];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
        if (success) {
            weak_self.model.hasorder = @"0";
            weak_self.returnButton.hidden = NO;
            [weak_self startRide];
        }else{
            QMUITips *tips = [QMUITips createTipsToView:self.view];
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(100, 100);
            [tips showError:message hideAfterDelay:2];
        }
    } error:^(NSError *error) {
        [tips hideAnimated:YES];
    }];

}

- (IBAction)startButtonClick:(id)sender {
    if (self.model.hasorder == nil) {
        [self createOrderReqeust];

    }else{
        [self startRide];
    }
}

- (IBAction)stopButtonClick:(id)sender {
    [self endRide];
}


-(void) startRide
{
     [self.timeLabel start];
    self.cancelButton.hidden = YES;
    self.startButton.hidden = YES;
    self.runView.hidden = NO;
    self.runView.alpha = 1;
    self.label1.hidden = NO;
    self.label3.hidden = NO;
    self.label2.hidden = YES;
    self.stopButton.hidden = NO;
    [self operateBike:OPENOP];
}

-(void) endRide
{
    self.startButton.hidden = NO;
    self.runView.alpha = 0.4;
    self.label1.hidden = YES;
    self.label3.hidden = YES;
    self.label2.hidden = NO;
    self.stopButton.hidden = YES;
    [self operateBike:CLOSEOP];
}


-(void) operateBike:(NSString *)op
{
    YYOprateBikeRequest *request = [[YYOprateBikeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOpratebikeAPI];
    request.op = op;
    QMUITips *tips = [QMUITips createTipsToView:self.view];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
    } error:^(NSError *error) {
         [tips hideAnimated:YES];
    }];
}


-(void) returnButtonClick:(UIButton *)sender
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 183)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    QMUIFillButton *button = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed frame:CGRectMake(10, 35, contentView.width - 20, 44)];
    [button setBackgroundColor:[UIColor colorWithHexString:@"#ED1847"]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:@"归还至原点" forState:UIControlStateNormal];
    
    QMUIFillButton *button1 = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed frame:CGRectMake(10, 104, contentView.width - 20, 44)];
    [button1 setTitle:@"异地还车" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor colorWithHexString:@"#ED1847"]];
    [button1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    [contentView addSubview:button1];
    
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.maximumContentViewWidth = kScreenWidth - 40;
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
   
}

-(void) buttonClick:(QMUIFillButton *)sender
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        if (self.rentalModel.state == 1) {
         
        }else{
            YYOrderInfoView *contentView = [[YYOrderInfoView alloc] init];
            contentView.delegate = self;
            contentView.rsid =  self.rentalModel.sid == 0 ? self.rentalModel.ssid : self.rentalModel.sid;
            contentView.backgroundColor = UIColorWhite;
            contentView.layer.cornerRadius = 6;
            QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
            modalViewController.contentView = contentView;
            modalViewController.maximumContentViewWidth = kScreenWidth - 20;
            modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
            [modalViewController showWithAnimated:YES completion:nil];
            self.modalPrentViewController = modalViewController;
        }
   
    }];
}

-(void)orderInfoView:(YYOrderInfoView *)orderView didClickOKButton:(UIButton *)sender
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        YYReturnBikeRequest *request = [[YYReturnBikeRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kReturnBikeAPI];
        request.rsid = self.rentalModel.sid == 0 ? self.rentalModel.ssid : self.rentalModel.sid;
        WEAK_REF(self);
        QMUITips *tips = [QMUITips createTipsToView:self.view];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(100, 100);
        [tips showLoading];
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [tips hideAnimated:YES];
            if (success) {
                weak_self.returnResultModel = [YYReturnResultModel modelWithDictionary:response];
                if (weak_self.returnResultModel.price <= 0) {
                    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(300, 100);
                    [tips showSucceed:@"还车成功" hideAfterDelay:2];
                    [weak_self.navigationController popToRootViewControllerAnimated:YES];
                    return;
                }
                [weak_self performSegueWithIdentifier:@"ReturnBike" sender:self];
            }else{
                QMUITips *tips = [QMUITips createTipsToView:self.view];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(200, 100);
                [tips showError:message hideAfterDelay:2];
            }
        } error:^(NSError *error) {
            [tips hideAnimated:YES];
        }];        
    }];
 
}

-(void)orderInfoView:(YYOrderInfoView *)orderView didClickNaviButton:(UIButton *)sender withReturnModel:(YYReturnResultModel *)resultModel
{
    CLLocationCoordinate2D to = CLLocationCoordinate2DMake(resultModel.latitude, resultModel.longitude);

    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    
    toLocation.name = @"还车点";
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
}

#pragma mark ------------------------------ 导航 - 高德
-(void) onDaoHangForGaoDeMap
{

}

-(void) button1Click:(QMUIFillButton *)sender
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished){
        [self performSegueWithIdentifier:@"remoteViewSegue" sender:self];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[YYReturnBikeViewController class]]) {
        YYReturnBikeViewController *returnBikeViewController = (YYReturnBikeViewController *)[segue destinationViewController];
        if (self.returnResultModel != nil) {
            returnBikeViewController.price = self.returnResultModel.price;
            returnBikeViewController.keep = self.returnResultModel.keep;
            returnBikeViewController.extprice = self.returnResultModel.extPrice;
        }else{
            returnBikeViewController.price = self.rentalModel.price;
            returnBikeViewController.keep = self.rentalModel.keep;
            returnBikeViewController.extprice = 0;
        }
    }
    if ([[segue destinationViewController] isKindOfClass:[YYRemoteReturnViewController class]]){
        [[segue destinationViewController] setValue:self.rentalModel forKey:@"model"];
    }
}


@end
