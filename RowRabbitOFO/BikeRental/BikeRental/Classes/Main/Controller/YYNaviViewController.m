//
//  YYNaviViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/13.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYNaviViewController.h"
#import "YYAroundSiteRequest.h"
#import "YYSiteModel.h"
#import "YYMainViewController.h"
#import "YYPersonalViewController.h"
#import "YYUserManager.h"
#import "YYLoginViewController.h"
#import "YYUserModel.h"
#import "POP.h"
#import "YYUseBikeViewController.h"
#import "YYReturnBikeViewController.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "YYNavigationController.h"
#import "NSNotificationCenter+Addition.h"
#import "YYWalkDetailView.h"
#import "POP.h"
#import "YYControlBikeViewController.h"
#import "YYBikeListView.h"
#import "YYYSiteModel.h"
#import "YYGetYBikeRequest.h"
#import "YYPayDepositViewController.h"
#import "YYCertificationViewController.h"
#import "YYChargeViewController.h"
#import "YYCreateOrderReuquest.h"
#import "YYBikeInfoViewCell.h"
#import "YYFileCacheManager.h"
#import "YYRecomendListView.h"
#import "YYGetBikeRequest1.h"
#import "YYShareHBView.h"
#import "YYRegisterHBView.h"
#import "YYGuideView.h"
#import "YYNavScrollView.h"
#import "YYMessageViewController.h"
#import "YYInviteViewController.h"
#import "YYWarmPromptView.h"
#import <JDFTooltips/JDFTooltips.h>
#import <WZLBadge/WZLBadgeImport.h>
#import <UMSocialCore/UMSocialCore.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <QMUIKit/QMUIKit.h>

#define ButtonXMargin 20
#define ButtonHeight 44
//static const NSInteger RoutePlanningPaddingEdge  = 20;

typedef enum {
    MoreOperationTagShareWechat,
    MoreOperationTagShareMoment,
    MoreOperationTagShareQzone,
    MoreOperationTagShareWeibo,
} MoreOperationTag;

@interface YYNaviViewController ()<MAMapViewDelegate,AMapSearchDelegate,YYWalkDetailViewDelegate,BikeListViewDelegate,RecomendListViewDelegate,ShareHBViewDelegate,QMUIMoreOperationDelegate,RegisterHBViewDelegate,NavScrollViewDelegate>

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (nonatomic,strong) UIButton *bottomButton;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) AMapRoute *route;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *directView;

@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic,strong) AMapSearchAPI *search;

/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic,retain) NSArray *pathPolylines;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic,strong) UIImageView *pickImageView;

@property (weak, nonatomic) IBOutlet UILabel *bikeCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (nonatomic,strong) NSArray<YYSiteModel *> *models;

@property (nonatomic,assign) NSInteger selectedId;

@property (nonatomic,strong) YYUserModel *userModel;

@property (nonatomic,strong) YYRentalModel *rentalModel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;

@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic,assign) CLLocationCoordinate2D lastPostion;

@property (nonatomic,copy) NSString *city;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (nonatomic,assign) NSInteger flag;

@property (weak, nonatomic) IBOutlet QMUIFillButton *rentalButton;

@property (nonatomic,strong) YYWalkDetailView *detailView;

@property (nonatomic,strong) YYRecomendListView *listView;

@property (nonatomic,strong) YYNavScrollView *navScrollView;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (nonatomic,strong)  QMUIMoreOperationController *moreOperationController;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet UIButton *pCenterButton;

@property (weak, nonatomic) IBOutlet UIButton *activityButton;

@property (weak, nonatomic) IBOutlet UIView *nearestView;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel1;

@property (nonatomic,assign) BOOL firstLoad;

@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property(nonatomic, strong) JDFTooltipView *tooltipView;

@end

static NSString *reuseIndetifier = @"annotationReuseIndetifier";

@implementation YYNaviViewController

-(NSArray<YYSiteModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化地图
    [self initMap];
    //初始化控件
    [self setUpControls];
    //检测更新
    [self checkUpdate];
    //初始化搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    //绑定通知
    [NSNotificationCenter addObserver:self action:@selector(dirctAction:) name:kDirectNotifaction];
    [NSNotificationCenter addObserver:self action:@selector(returnSuccessAction:) name:kReturnSuccessNotification];
    [NSNotificationCenter addObserver:self action:@selector(loginSuccessAction:) name:kLoginSuccessNotification];
    
    YYWarmPromptView *contentView = [[YYWarmPromptView alloc] init];
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.maximumContentViewWidth = kScreenWidth - 100;
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    [modalViewController showWithAnimated:YES completion:nil];
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的定位->设置->隐私->定位" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    }
}

-(void) dirctAction:(NSNotification *)noti
{
    YYSiteModel *model = (YYSiteModel *)noti.object;
    self.destinationCoordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    [self.mapView setCenterCoordinate:self.destinationCoordinate];
    [self ddd:nil];
}

-(void) loginSuccessAction:(NSNotification *)noti
{
    [self checkAccount];
}

-(void) checkAccount
{
    if (![YYUserManager isHaveLogin]) {
        return;
    }
    
    
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
        if (success) {
            weak_self.userModel = [YYUserModel modelWithDictionary:response];
            
            
            //未认证身份
            if ([weak_self.userModel.idcard isEqualToString:@""]) {
                //Certification
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                
               [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
                return;
            }
            
            //未交押金
            if (weak_self.userModel.authtype == 0 &&  weak_self.userModel.zmstate == 0 && (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3)) {
                //payDeposit
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
                [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
                //[weak_self.navigationController pushViewController:payDepositViewController animated:YES];
                return;
            }
            
            if (weak_self.userModel.money <= 0) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(200, 100);
                [tips showInfo:@"您的余额不足，请充值" hideAfterDelay:2];
                
                YYChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"charge"];
                
                [self.navigationController pushViewController:chargeViewController animated:YES];
                return;
            }
            //用户有订单的情况
            if ([weak_self.userModel.hasorder isEqualToString:@"1"]) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(100, 100);
                [tips showError:@"上次借车还未付款, 请先付款" hideAfterDelay:2];
                YYBaseRequest *orderRequest = [[YYBaseRequest alloc] init];
                orderRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
                [orderRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
                    
                    YYReturnBikeViewController *returnBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"returnBike"];
                    returnBikeViewController.price = weak_self.rentalModel.price;
                    returnBikeViewController.extprice = 0;
                    returnBikeViewController.keep = weak_self.rentalModel.keep;
                    [weak_self.navigationController pushViewController:returnBikeViewController animated:YES];
                } error:^(NSError *error) {
                    
                }];
                
            }
        }
    } error:^(NSError *error) {
        [tips hideAnimated:YES];
    }];
}

-(void) returnSuccessAction:(NSNotification *)noti
{
    YYShareHBView *shareHBView = [[YYShareHBView alloc] init];
    shareHBView.delegate = self;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = shareHBView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
}


-(void) checkUpdate
{
    [self Postpath:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppId]];
}

#pragma mark -- 获取数据
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
                
                NSString* thisVersion = kAppVersion;
                
                if ([[receiveStatusDic valueForKey:@"version"] floatValue] > [thisVersion floatValue]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"发现新版本，是否要去更新？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString  *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",kAppId];
                        
                        NSURL *url = [NSURL URLWithString:urlStr];
                        [[UIApplication sharedApplication]openURL:url];
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    });
                }
                
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
    }];
    
}

//获取用户状态信息
-(void) getUserInfoRequest
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.userModel = [YYUserModel modelWithDictionary:response];
            
            if (self.firstLoad) {
                return;
            }
            self.firstLoad = YES;
            //未认证身份
            if ([weak_self.userModel.idcard isEqualToString:@""]) {
                //Certification
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
                //[weak_self.navigationController pushViewController:certificationViewController animated:YES];
                return;
            }
            
            //学生证认证(认证中)
            if (weak_self.userModel.authtype == 1 && weak_self.userModel.xstate == 0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                certificationViewController.preState = YES;
                [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
                return;
            }
            
            //未交押金
            if (weak_self.userModel.authtype == 0 && weak_self.userModel.zmstate == 0 && (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3)) {
                //payDeposit
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
                [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
                //[weak_self.navigationController pushViewController:payDepositViewController animated:YES];
                return;
            }
            
            if (weak_self.userModel.money <= 0) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(200, 100);
                [tips showInfo:@"您的余额不足，请充值" hideAfterDelay:2];
                
                YYChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"charge"];
                [weak_self.navigationController pushViewController:chargeViewController animated:YES];
                return;
            }
            //用户有订单的情况
            if (weak_self.userModel.hasorder != nil) {
                YYBaseRequest *orderRequest = [[YYBaseRequest alloc] init];
                orderRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
                [orderRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
                    YYControlBikeViewController *useBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"controlBike"];
                    useBikeViewController.last_mileage = weak_self.rentalModel.last_mileage;
                    useBikeViewController.deviceid = weak_self.rentalModel.deviceid;
                    useBikeViewController.ctime = weak_self.rentalModel.ctime;
                    useBikeViewController.ID = weak_self.rentalModel.ID;
                    useBikeViewController.name = weak_self.rentalModel.name;
                    [weak_self.navigationController pushViewController:useBikeViewController animated:YES];
                    
                    
                } error:^(NSError *error) {
                    
                }];
                
            }
            
            
        }
    } error:^(NSError *error) {
        
    }];
}



-(void) setUpControls
{
    self.searchButton.layer.borderColor = [UIColor colorWithHexString:@"#A5A5A5"].CGColor;
    self.searchButton.layer.borderWidth = 0.5;
    self.searchButton.layer.cornerRadius = 13;
    self.searchButton.layer.masksToBounds = YES;
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.layer.cornerRadius = 4;
    bottomButton.layer.masksToBounds = YES;
    [bottomButton setTitle:@"进入站点租车" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton setBackgroundColor:[UIColor colorWithHexString:@"#00A32E"]];
    bottomButton.frame = CGRectMake(ButtonXMargin, kScreenHeight + ButtonHeight + ButtonXMargin, kScreenWidth - 2 * ButtonXMargin, ButtonHeight);
    [bottomButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    self.bottomButton = bottomButton;
    
    self.directView.layer.cornerRadius = 5;
    self.directView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.flag = 0;
    
    if (kFetchReadMessageKey == nil) {
        [self.pCenterButton showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        [self.pCenterButton setBadgeCenterOffset:CGPointMake(-12, 10)];
    }else{
        [self.pCenterButton clearBadge];
    }
    
    //用户登录的情况下获取用户状态
    if ([YYUserManager isHaveLogin]) {
        [self getUserInfoRequest];
    }
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)closeNoticeButtonClick:(id)sender {
    [self.noticeView removeFromSuperview];
    self.noticeView = nil;
}



- (IBAction)ddd:(id)sender {
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude
                                           longitude:self.mapView.userLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapWalkingRouteSearch:navi];
}



-(void) buttonClick:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"main" sender:self];
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[YYMainViewController class]]) {
        [segue.destinationViewController setValue:@(self.models[self.selectedId].ID) forKey:@"sid"];
        [segue.destinationViewController setValue:self.models[self.selectedId].name forKey:@"name"];
        [segue.destinationViewController setValue:self.city forKey:@"city"];
    }
    if ([segue.destinationViewController isKindOfClass:[YYInviteViewController class]]) {
        [segue.destinationViewController setValue:@(self.userModel.ID) forKey:@"userId"];
    }

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"message1"] || [identifier isEqualToString:@"invite"] || [identifier isEqualToString:@"scanCode"]) {
        if (![YYUserManager isHaveLogin]) {
            UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
            return NO;
        }
        
        //未认证身份
        if ([self.userModel.idcard isEqualToString:@""]) {
            //Certification
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
            return NO;
        }
        
        //学生证认证(认证中)
        if (self.userModel.authtype == 1 && self.userModel.xstate == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
            certificationViewController.preState = YES;
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
            return NO;
        }
        
        //未交押金
        if (self.userModel.authtype == 0 && self.userModel.zmstate == 0 && (self.userModel.dstate == 0 || self.userModel.dstate == 3)) {
            //payDeposit
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
            //[self.navigationController pushViewController:payDepositViewController animated:YES];
            return NO;
        }
        
        if (self.userModel.money <= 0) {
            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(200, 100);
            [tips showInfo:@"您的余额不足，请充值" hideAfterDelay:2];
            YYChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"charge"];
            //[self presentViewController:[[YYNavigationController alloc] initWithRootViewController:chargeViewController] animated:YES completion:nil];
            [self.navigationController pushViewController:chargeViewController animated:YES];
            return NO;
        }
        
    }
    return YES;
}


# pragma mark 初始化地图
-(void) initMap
{
    [AMapServices sharedServices].apiKey = kAMapKey;
    
    _mapView.delegate                    = self;
    _mapView.showsUserLocation           = YES;
    _mapView.cameraDegree = 0;
    _mapView.userTrackingMode            = MAUserTrackingModeFollow;
    _mapView.rotateCameraEnabled       = NO;
    _mapView.skyModelEnable              = YES;
    _mapView.showsCompass                = NO;
    _mapView.showsScale                  = NO;
    _mapView.rotateEnabled               = NO;
    [_mapView setZoomLevel:18.5 animated:YES];
    [self.view addSubview:_mapView];
    
    [self.view bringSubviewToFront:self.gpsButton];
    [self.view bringSubviewToFront:self.directView];
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.rentalButton];
    [self.view bringSubviewToFront:self.activityButton];
    [self.view bringSubviewToFront:self.nearestView];
    [self.view bringSubviewToFront:self.noticeView];
    
    [self initAnnotations];

    self.noticeView.layer.cornerRadius = self.noticeView.height * 0.4;
    if ([YYFileCacheManager readUserDataForKey:@"config"][@"chargerule"] != nil) {
          self.noticeLabel.text = [YYFileCacheManager readUserDataForKey:@"config"][@"chargerule"];
    }
  
    
    YYNavScrollView *addressView = [[YYNavScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 130, kScreenWidth, 120)];
    addressView.delegate = self;
    [self.view addSubview:addressView];
    [self.view bringSubviewToFront:addressView];
    self.navScrollView = addressView;
    self.navScrollView.hidden = YES;
    self.nearestView.hidden = YES;
}

# pragma mark 测试初始化点
- (void)initAnnotations
{
    UIImageView *pickImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"zuobiao_icon_index"]];
    pickImageView.center = self.view.center;
    [self.view addSubview:pickImageView];
    [self.view bringSubviewToFront:pickImageView];
    self.pickImageView = pickImageView;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    if ([YYFileCacheManager readUserDataForKey:kLocationTipsKey] == nil) {
        JDFTooltipView *tooltip = [[JDFTooltipView alloc] initWithTargetView:self.gpsButton hostView:self.view tooltipText:@"点击这里，可以重新定位" arrowDirection:JDFTooltipViewArrowDirectionDown width:200.0f];
        [tooltip show];
        self.tooltipView = tooltip;
        [YYFileCacheManager saveUserData:@"1" forKey:kLocationTipsKey];
    }

    
}


- (IBAction)nearestButtonClick:(id)sender {
    [self.mapView selectAnnotation:self.annotations[0] animated:YES];
}


- (IBAction)locationButtonClick:(id)sender {
    [self.tooltipView hideAnimated:YES];
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}


- (IBAction)personalCenterButtonClick:(id)sender {
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];

        
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
    }else{
        [self performSegueWithIdentifier:@"personal" sender:nil];
    }

}

-(void) getAroundSiteRequest
{
    YYAroundSiteRequest *request = [[YYAroundSiteRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAroundSiteAPI];
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
    
    request.lat = coordinate.latitude;
    request.lng = coordinate.longitude;
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            
            weak_self.lastPostion = coordinate;
            weak_self.models = [YYSiteModel modelArrayWithDictArray:response];
            [weak_self.mapView removeAnnotations:weak_self.annotations];
            weak_self.annotations = [NSMutableArray array];
            weak_self.navScrollView.models = weak_self.models;
          
            for (int i = 0; i < weak_self.models.count; ++i)
            {
                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                a1.coordinate = CLLocationCoordinate2DMake(weak_self.models[i].latitude, weak_self.models[i].longitude);
                a1.title      = [NSString stringWithFormat:@"%d", i];
                a1.subtitle = weak_self.models[i].address;
                [weak_self.annotations addObject:a1];
                
            }
            if (weak_self.annotations.count > 0) {
               
                [weak_self.mapView addAnnotations:self.annotations];
              
            }
          
        }
    } error:^(NSError *error) {
        
    }];
    
}

//路线解析
- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        
        //          MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
        
        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}

//解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    
    return coordinates;
}


#pragma mark - mapview delegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"08定位02"];
    
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
       
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"07车辆"];
       
        if ([annotation isKindOfClass:[MAUserLocation class]]){
            annotationView.image = [UIImage imageNamed:@"08定位02"];
        }
       

        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        //annotationView.selected = YES;
        return annotationView;
    }
   
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.listView.hidden = YES;
    self.navScrollView.hidden = YES;
    self.nearestView.hidden = YES;
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MAUserLocation class]]) {
        
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        CGFloat currentTx = view.transform.ty;
        animation.duration = 1.0;
        CGFloat height = 10;
        animation.values = @[@(currentTx), @(currentTx - height),@(currentTx)];
        animation.keyTimes = @[ @(0), @(0.6),@(1.0)];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [view.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
        self.destinationCoordinate = view.annotation.coordinate;
        
        [self ddd:nil];
        YYGetYBikeRequest *request = [[YYGetYBikeRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetBikeBysidAPI];
        //CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
        request.sid = self.models[[view.annotation.title integerValue]].ID;
        //request.lat = coordinate.latitude;
        //request.lon = coordinate.longitude;
        [self.mapView deselectAnnotation:view.annotation
                                animated:NO];
        if([view.annotation.title integerValue] == 0){
            self.nearestView.hidden = YES;
        }else{
           self.nearestView.hidden = NO;
            self.siteNameLabel1.text = self.models[0].name;
        }
        WEAK_REF(self);
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                NSArray *arr = [YYRentalModel modelArrayWithDictArray:response];
                if (arr.count > 0) {
                    if (weak_self.listView) {
                        [weak_self.listView removeFromSuperview];
                        weak_self.listView = nil;
                    }
                    weak_self.navScrollView.hidden = NO;
                    weak_self.listView.hidden = NO;
                    [weak_self.navScrollView setInfoByCurrentModelIndex:[view.annotation.title integerValue]];
                    YYRecomendListView *listView = [[YYRecomendListView alloc] initWithFrame:weak_self.view.bounds];
                    listView.top = 70;
                    listView.width = kScreenWidth - 20;
                    listView.delegate = weak_self;
                    listView.centerX = kScreenWidth * 0.5;
                    listView.height = 130;
                    [weak_self.view addSubview:listView];
                    [weak_self.view bringSubviewToFront:listView];
                    listView.siteName = weak_self.models[[view.annotation.title integerValue]].name;
                    listView.distance = weak_self.models[[view.annotation.title integerValue]].distance;
                    weak_self.listView = listView;
                    weak_self.listView.array = arr;
                }else{
                    weak_self.navScrollView.hidden = NO;
                    [weak_self.navScrollView setInfoByCurrentModelIndex:[view.annotation.title integerValue]];
                    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(300, 100);
                    [tips showWithText:@"最近站点车辆被使用完毕,拖动地图换个站点试试" hideAfterDelay:2];
                    weak_self.listView.hidden = YES;
                }
              
            }else{
                weak_self.navScrollView.hidden = NO;
                [weak_self.navScrollView setInfoByCurrentModelIndex:[view.annotation.title integerValue]];
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(300, 100);
                [tips showWithText:message hideAfterDelay:2];
                weak_self.listView.hidden = YES;
                
            }
        } error:^(NSError *error) {
            
        }];
    }
    
}

//绘制遮盖时执行的代理方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
    
}

-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
 
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(self.lastPostion);
    MAMapPoint point2 = MAMapPointForCoordinate(coordinate);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    if (distance < 2000) {
        return;
    }

    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTx = self.pickImageView.transform.ty;
    animation.duration = 0.6;
    CGFloat height = 10;
    animation.values = @[@(currentTx), @(currentTx - height),@(currentTx)];
    animation.keyTimes = @[ @(0), @(0.2),@(0.6)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.pickImageView.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
    
    [self getAroundSiteRequest];
   
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
    

}

#pragma mark - AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        //self.addressLabel.text = response.regeocode.pois[0].name;
        self.city = response.regeocode.addressComponent.city;
    }
}


/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    [self.naviRoute removeFromMapView];
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude ] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
//    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
//                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
//                           animated:YES];
}

- (void)updateTotal
{
    self.totalCourse = self.route.paths.count;
}

- (IBAction)tapAction:(id)sender {
    self.flag = 1;
    [self performSegueWithIdentifier:@"desSegue" sender:nil];
}




-(void)YYWalkDetailView:(YYWalkDetailView *)walkDetailView didClickRentalButton:(UIButton *)rentalButton
{
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
         [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
        return;
    }
    
    
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
        if (success) {
            weak_self.userModel = [YYUserModel modelWithDictionary:response];
            
            //未交押金
            if (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3) {
                //payDeposit
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
                
                [weak_self.navigationController pushViewController:payDepositViewController animated:YES];
                return;
            }
            //未认证身份
            if ([weak_self.userModel.idcard isEqualToString:@""]) {
                //Certification
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                
                [weak_self.navigationController pushViewController:certificationViewController animated:YES];
                return;
            }
            
            if (weak_self.userModel.money <= 0) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(200, 100);
                [tips showInfo:@"您的余额不足，请充值" hideAfterDelay:2];
                
                
                YYChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"charge"];
                [self.navigationController pushViewController:chargeViewController animated:YES];
                return;
            }
            //用户有订单的情况
            if ([weak_self.userModel.hasorder isEqualToString:@"1"]) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(100, 100);
                [tips showError:@"上次借车还未付款, 请先付款" hideAfterDelay:2];
                YYBaseRequest *orderRequest = [[YYBaseRequest alloc] init];
                orderRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
                [orderRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
                    
                    YYReturnBikeViewController *returnBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"returnBike"];
                    returnBikeViewController.price = weak_self.rentalModel.price;
                    returnBikeViewController.extprice = 0;
                    returnBikeViewController.keep = weak_self.rentalModel.keep;
                    [weak_self.navigationController pushViewController:returnBikeViewController animated:YES];
                } error:^(NSError *error) {
                    
                }];
                
            }else{
                YYCreateOrderReuquest *request = [[YYCreateOrderReuquest alloc] init];
                request.sid = self.detailView.model.sid;
                request.bid = self.detailView.model.ID;
                request.deviceid = self.detailView.model.deviceid;
                request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreateOrderAPI];
                WEAK_REF(self);
                QMUITips *tips = [QMUITips createTipsToView:self.view];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(100, 100);
                [tips showLoading];
                
                [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    [tips hideAnimated:YES];
                    if (success) {
                        POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                        anBasic.toValue = @(weak_self.detailView.center.y - 184);
                        anBasic.beginTime = CACurrentMediaTime();
                        [anBasic setCompletionBlock:^(POPAnimation *ani,BOOL finish){
                            [weak_self.detailView removeFromSuperview];
                            weak_self.detailView = nil;
                        }];
                        [weak_self.detailView pop_addAnimation:anBasic forKey:@"position"];
                        YYControlBikeViewController *controlBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"controlBike"];
                        controlBikeViewController.last_mileage = weak_self.detailView.model.last_mileage;
                        controlBikeViewController.deviceid = weak_self.detailView.model.deviceid;
                        controlBikeViewController.ID = weak_self.detailView.model.ID;
                        controlBikeViewController.name = weak_self.detailView.model.name;
                        [YYFileCacheManager saveUserData:weak_self.detailView.model.bleid forKey:KBLEIDKey];
                        [weak_self.navigationController pushViewController:controlBikeViewController animated:YES];
                       
                    }else{
                        QMUITips *tips = [QMUITips createTipsToView:weak_self.view];
                        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                        contentView.minimumSize = CGSizeMake(100, 100);
                        [tips showError:message hideAfterDelay:2];
                    }
                } error:^(NSError *error) {
                    [tips hideAnimated:YES];
                }];
            }
            //用户无订单
            
        }
    } error:^(NSError *error) {
        [tips hideAnimated:YES];
    }];
}


-(void)walkDetail:(YYWalkDetailView *)walkDetailView didClickAddressButton:(UIButton *)addressButton
{
    YYBikeListView *bikeListView = [[YYBikeListView alloc] init];
    bikeListView.sid = walkDetailView.model.sid;
    bikeListView.distance = walkDetailView.model.distance;
    bikeListView.siteName = walkDetailView.model.name;
    bikeListView.delegate = self;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = bikeListView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
}

-(void) BikeListView:(YYBikeListView *)bikeListView didClickCloseButton:(UIButton *)closeButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:nil];
}

-(void)BikeListView:(YYBikeListView *)bikeListView didClickUseButtonCell:(YYBikeInfoViewCell *)useButtonCell
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        if (![YYUserManager isHaveLogin]) {
            UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
            return;
        }
        
        
        YYBaseRequest *request = [[YYBaseRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
        
        WEAK_REF(self);
        QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(100, 100);
        [tips showLoading];
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [tips hideAnimated:YES];
            if (success) {
                weak_self.userModel = [YYUserModel modelWithDictionary:response];
              
                //未交押金
                if (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3) {
                    //payDeposit
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
                    
                    [weak_self.navigationController pushViewController:payDepositViewController animated:YES];
                    return;
                }
                //未认证身份
                if ([weak_self.userModel.idcard isEqualToString:@""]) {
                    //Certification
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                    
                    [weak_self.navigationController pushViewController:certificationViewController animated:YES];
                    return;
                }
                
                if (weak_self.userModel.money <= 0) {
                    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(200, 100);
                    [tips showInfo:@"您的余额不足，请充值" hideAfterDelay:2];
                    
                    YYChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"charge"];
                    [self.navigationController pushViewController:chargeViewController animated:YES];
                    return;
                }
                //用户有订单的情况
                if ([weak_self.userModel.hasorder isEqualToString:@"1"]) {
                    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(100, 100);
                    [tips showError:@"上次借车还未付款, 请先付款" hideAfterDelay:2];
                    YYBaseRequest *orderRequest = [[YYBaseRequest alloc] init];
                    orderRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
                    [orderRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                        weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
                        
                        YYReturnBikeViewController *returnBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"returnBike"];
                        returnBikeViewController.price = weak_self.rentalModel.price;
                        returnBikeViewController.extprice = 0;
                        returnBikeViewController.keep = weak_self.rentalModel.keep;
                        [weak_self.navigationController pushViewController:returnBikeViewController animated:YES];
                    } error:^(NSError *error) {
                        
                    }];
                    
                }else{
                    YYCreateOrderReuquest *request = [[YYCreateOrderReuquest alloc] init];
                    request.sid = useButtonCell.model.sid;
                    request.bid = useButtonCell.model.ID;
                    request.deviceid = useButtonCell.model.deviceid;
                    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreateOrderAPI];
                    WEAK_REF(self);
                    QMUITips *tips = [QMUITips createTipsToView:self.view];
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(100, 100);
                    [tips showLoading];
                    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                        [tips hideAnimated:YES];
                        if (success) {
                            YYControlBikeViewController *controlBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"controlBike"];
                            controlBikeViewController.last_mileage = useButtonCell.model.last_mileage;
                            controlBikeViewController.deviceid = useButtonCell.model.deviceid;
                            controlBikeViewController.ctime = useButtonCell.model.ctime;
                            controlBikeViewController.ID = useButtonCell.model.ID;
                            controlBikeViewController.name = useButtonCell.model.name;
                            [YYFileCacheManager saveUserData:useButtonCell.model.bleid forKey:KBLEIDKey];
                            [self.navigationController pushViewController:controlBikeViewController animated:YES];
                        }else{
                            QMUITips *tips = [QMUITips createTipsToView:weak_self.view];
                            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                            contentView.minimumSize = CGSizeMake(100, 100);
                            [tips showError:message hideAfterDelay:2];
                        }
                    } error:^(NSError *error) {
                        [tips hideAnimated:YES];
                    }];
                }
                //用户无订单
                
            }
        } error:^(NSError *error) {
            [tips hideAnimated:YES];
        }];
    }];
}

-(void) YYRecomendListView:(YYRecomendListView *)recomendListView didClickCloseButton:(UIButton *)closeButton
{
    [self.listView removeFromSuperview];
    
    self.listView = nil;
    
    self.nearestView.hidden = YES;
    
    self.navScrollView.hidden = YES;
}

-(void)YYRecomendListView:(YYRecomendListView *)recomendListView didClickUseButton:(UIButton *)useButton
{
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
        return;
    }
    
    
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
        if (success) {
            weak_self.userModel = [YYUserModel modelWithDictionary:response];
            
            //未认证身份
            if ([weak_self.userModel.idcard isEqualToString:@""]) {
                //Certification
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                
                [weak_self.navigationController pushViewController:certificationViewController animated:YES];
                return;
            }
            
            //未交押金
            if (weak_self.userModel.zmstate == 0 && (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3)) {
                //payDeposit
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
                
                [weak_self.navigationController pushViewController:payDepositViewController animated:YES];
                return;
            }
         
            if (weak_self.userModel.money <= 0) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(200, 100);
                [tips showInfo:@"您的余额不足，请充值" hideAfterDelay:2];
                
                YYChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"charge"];
                [self.navigationController pushViewController:chargeViewController animated:YES];
                return;
            }
            //用户有订单的情况
            if ([weak_self.userModel.hasorder isEqualToString:@"1"]) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(100, 100);
                [tips showError:@"上次借车还未付款, 请先付款" hideAfterDelay:2];
                YYBaseRequest *orderRequest = [[YYBaseRequest alloc] init];
                orderRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
                [orderRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
                    
                    YYReturnBikeViewController *returnBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"returnBike"];
                    returnBikeViewController.price = weak_self.rentalModel.price;
                    returnBikeViewController.extprice = 0;
                    returnBikeViewController.keep = weak_self.rentalModel.keep;
                    [weak_self.navigationController pushViewController:returnBikeViewController animated:YES];
                } error:^(NSError *error) {
                    
                }];
                
            }else{
                QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
                }];
                QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:
                                            QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                    weak_self.navScrollView.hidden = YES;
                    YYCreateOrderReuquest *request = [[YYCreateOrderReuquest alloc] init];
                    request.sid = recomendListView.selectedModel.sid;
                    request.bid = recomendListView.selectedModel.ID;
                    request.deviceid = recomendListView.selectedModel.deviceid;
                    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreateOrderAPI];
                    WEAK_REF(self);
                    QMUITips *tips = [QMUITips createTipsToView:self.view];
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(100, 100);
                    [tips showLoading];
                    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                        [tips hideAnimated:YES];
                        if (success) {
                            YYControlBikeViewController *controlBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"controlBike"];
                            controlBikeViewController.last_mileage =recomendListView.selectedModel.last_mileage;
                            controlBikeViewController.deviceid = recomendListView.selectedModel.deviceid;
                            controlBikeViewController.ctime = recomendListView.selectedModel.ctime;
                            controlBikeViewController.ID = recomendListView.selectedModel.ID;
                            controlBikeViewController.name = recomendListView.selectedModel.name;
                            [YYFileCacheManager saveUserData:recomendListView.selectedModel.bleid forKey:KBLEIDKey];
                            [weak_self.listView removeFromSuperview];
                            weak_self.listView = nil;
                            weak_self.nearestView.hidden = YES;
                            [self.navigationController pushViewController:controlBikeViewController animated:YES];
                        }else{
                            QMUITips *tips = [QMUITips createTipsToView:weak_self.view];
                            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                            contentView.minimumSize = CGSizeMake(100, 100);
                            [tips showError:message hideAfterDelay:2];
                        }
                    } error:^(NSError *error) {
                        [tips hideAnimated:YES];
                    }];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"出行提示" message:@"确定开始租车吗？" preferredStyle:QMUIAlertControllerStyleAlert];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController showWithAnimated:YES];
             
            }
            //用户无订单
            
        }
    } error:^(NSError *error) {
        [tips hideAnimated:YES];
    }];

}

-(void)YYShareHBView:(YYShareHBView *)shareHBView didClickCloseButton:(UIButton *)closeButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        
    }];
}

-(void)YYShareHBView:(YYShareHBView *)shareHBView didClickShareButton:(UIButton *)shareButton
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"行运兔，新出行，新生活" descr:@"" thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://zc.51xytu.com/htm/share.htm";
   
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            YYBaseRequest *request = [[YYBaseRequest alloc] init];
            request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kActCallbackAPI];
            WEAK_REF(self);
            [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                if (success) {
                    [weak_self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
                        YYRegisterHBView *registerHBView = [[YYRegisterHBView alloc] init];
                        registerHBView.delegate = weak_self;
                        registerHBView.price = [response[@"money"] floatValue];
                        QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
                        modalViewController.contentView = registerHBView;
                        modalViewController.maximumContentViewWidth = kScreenWidth;
                        modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
                        [modalViewController showWithAnimated:YES completion:nil];
                        self.modalPrentViewController = modalViewController;
                    }];
                }
            } error:^(NSError *error) {
                
            }];
         
        }
    }];
//    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
//    self.moreOperationController = moreOperationController;
//    self.moreOperationController.delegate = self;
//    
//    [self.moreOperationController addItemWithTitle:@"微信好友" image:UIImageMake(@"icon_moreOperation_shareFriend") type:QMUIMoreOperationItemTypeImportant tag:MoreOperationTagShareWechat];
//    
//    [self.moreOperationController addItemWithTitle:@"朋友圈" image:UIImageMake(@"icon_moreOperation_shareMoment") type:QMUIMoreOperationItemTypeImportant tag:MoreOperationTagShareMoment];
//    // 显示更多操作面板
//    [self.moreOperationController showFromBottom];
}

- (void)moreOperationController:(QMUIMoreOperationController *)moreOperationController didSelectItemAtTag:(NSInteger)tag {
    QMUIMoreOperationItemView *itemView = [moreOperationController itemAtTag:tag];
    NSString *tipString = itemView.titleLabel.text;
    switch (tag) {
        case MoreOperationTagShareWechat:
            break;
        case MoreOperationTagShareMoment:
            break;
        case MoreOperationTagShareWeibo:
            break;
        case MoreOperationTagShareQzone:
            break;
        default:
            break;
    }
    [QMUITips showWithText:tipString inView:self.view hideAfterDelay:0.5];
    [moreOperationController hideToBottom];
}

-(void)YYRegisterHBView:(YYRegisterHBView *)registerHBView didClickOKButton:(UIButton *)okButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:nil];
}

-(void)navScrollView:(YYNavScrollView *)navScrollView didSelectCurrentModel:(YYSiteModel *)model
{
    for (int i = 0; i < self.annotations.count; i++) {
        if ([((MAPointAnnotation *)self.annotations[i]).subtitle isEqualToString:model.address]) {
            if (i > 0) {
                self.siteNameLabel1.text = self.models[0].name;
                self.nearestView.hidden = NO;
            }else{
                self.nearestView.hidden = YES;
            }
          
            [self.mapView selectAnnotation:self.annotations[i] animated:YES];
            break;
        }
    }
}


@end
