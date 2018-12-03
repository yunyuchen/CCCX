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
#import "YYUserManager.h"
#import "YYLoginViewController.h"
#import "YYUserModel.h"
#import "POP.h"
#import "YYReturnBikeViewController.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "YYNavigationController.h"
#import "NSNotificationCenter+Addition.h"
#import "YYControlBikeViewController.h"
#import "YYYSiteModel.h"
#import "YYGetYBikeRequest.h"
#import "YYPayDepositViewController.h"
#import "YYCertificationViewController.h"
#import "YYChargeViewController.h"
#import "YYCreateOrderReuquest.h"
#import "YYFileCacheManager.h"
#import "YYRecomendListView.h"
#import "YYGetBikeRequest1.h"
#import "YYShareHBView.h"
#import "YYRegisterHBView.h"
#import "YYGuideView.h"
#import "YYMessageViewController.h"
#import "YYWarmPromptView.h"
#import "YYGuideViewController.h"
#import "YYReAuthViewController.h"
#import "YYFaultWarrantyController.h"
#import "YYGetCouponRequest.h"
#import "YYReAuthViewController1.h"
#import "YYOtherAuthViewController.h"
#import "HMSegmentedControl.h"
#import "YYArroundAreaRequest.h"
#import "YYBikeModel.h"
#import "YYSiteInfoView.h"
#import "YYBikeInfoView.h"
#import "YYMyAppointmentRequest.h"
#import "YYAppointmentModel.h"
#import "YYAppointmentRequest.h"
#import "MZTimerLabel.h"
#import "YYCancelAppointmentRequest.h"
#import "YYInformationController.h"
#import "YYBuyMemberCardViewController.h"
#import "YYFindBikeRequest.h"
#import <DateTools/DateTools.h>
#import <AudioToolbox/AudioToolbox.h>
#import <JDFTooltips/JDFTooltips.h>
#import <WZLBadge/WZLBadgeImport.h>
#import <UMSocialCore/UMSocialCore.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>

#define ButtonXMargin 20
#define ButtonHeight 44
//static const NSInteger RoutePlanningPaddingEdge  = 20;

@interface YYNaviViewController ()<MAMapViewDelegate,AMapSearchDelegate,RecomendListViewDelegate,ShareHBViewDelegate,QMUIMoreOperationDelegate,RegisterHBViewDelegate,YYBikeInfoViewDelegate,MZTimerLabelDelegate>

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (nonatomic,strong) UIButton *bottomButton;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) AMapRoute *route;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic,strong) AMapSearchAPI *search;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic,retain) NSArray *pathPolylines;

@property (nonatomic,strong) UIImageView *pickImageView;

@property (nonatomic,strong) NSArray<YYSiteModel *> *models;

@property (nonatomic,assign) NSInteger selectedId;

@property (nonatomic,strong) YYUserModel *userModel;

@property (nonatomic,strong) YYRentalModel *rentalModel;

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

@property (nonatomic,assign) NSInteger flag;

@property (weak, nonatomic) IBOutlet QMUIFillButton *rentalButton;

@property (nonatomic,strong) YYRecomendListView *listView;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (nonatomic,strong)  QMUIMoreOperationController *moreOperationController;

@property (weak, nonatomic) IBOutlet UIButton *pCenterButton;

@property (nonatomic,assign) BOOL firstLoad;

@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property(nonatomic, strong) JDFTooltipView *tooltipView;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightCons;

@property (weak, nonatomic) IBOutlet UIButton *noticeButton;

@property(nonatomic, assign) CGRect tmpFrame;

@property(nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *polygons;

@property(nonatomic, strong) NSArray<YYBikeModel *> *bikeModels;

@property(nonatomic, strong) YYSiteInfoView *siteView;

@property(nonatomic, strong) YYBikeInfoView *bikeInfoView;

@property(nonatomic, assign) BOOL Renting;

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
    //检测更新
    [self checkUpdate];
    //初始化搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    //绑定通知
    [NSNotificationCenter addObserver:self action:@selector(dirctAction:) name:kDirectNotifaction];
    [NSNotificationCenter addObserver:self action:@selector(returnSuccessAction:) name:kReturnSuccessNotification];
    [NSNotificationCenter addObserver:self action:@selector(loginSuccessAction:) name:kLoginSuccessNotification];
    // 状态栏(statusbar)
    CGRect StatusRect=[[UIApplication sharedApplication] statusBarFrame];
    //标题
    CGRect NavRect=self.navigationController.navigationBar.frame;
    self.topViewHeightCons.constant = StatusRect.size.height + NavRect.size.height;
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"电单车", @"还车点"]];
    segmentedControl.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, 44);
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorColor = [UIColor qmui_colorWithHexString:@"#F08300"];
    segmentedControl.selectionIndicatorHeight = 2;
    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor qmui_colorWithHexString:@"#F08300"]};
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    [self.view addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    self.segmentedControl = segmentedControl;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadMyAppoinmentBikes];
    });
}

- (void) segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self getAroundSiteRequest];
        //[self loadUserArea];
        if (self.siteView) {
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 184)];
            animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, SCREEN_HEIGHT - 184 - 12, SCREEN_WIDTH, 184)];
            [self.siteView.layer pop_addAnimation:animation forKey:nil];
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                [self.siteView removeFromSuperview];
                self.siteView = nil;
            };
        }
    }else{
        [self getArroundAreaData];
    }
}

- (void) getArroundAreaData
{
    YYArroundAreaRequest *request = [[YYArroundAreaRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAroundSiteAPI];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
    request.lat = coordinate.latitude;
    request.lng = coordinate.longitude;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            NSLog(@"%@",response);
            weakSelf.lastPostion = coordinate;
            [weakSelf.mapView removeAnnotations:weakSelf.annotations];
            [weakSelf.mapView removeOverlays:weakSelf.polygons];
            weakSelf.models = [YYSiteModel modelArrayWithDictArray:response];
            [weakSelf.annotations removeAllObjects];
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *models = response;
            for (int i = 0; i < models.count; i++) {
                NSArray *areas = models[i][@"area"];
                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                a1.coordinate = CLLocationCoordinate2DMake([models[i][@"lat"] doubleValue], [models[i][@"lng"] doubleValue]);
                a1.title = [NSString stringWithFormat:@"%d",i];
                //a1.title      = [NSString stringWithFormat:@"%@_%@_%@", models[i][@"name"],models[i][@"distance"],models[i][@"img1"]];
                a1.subtitle   = @"2";
                [weakSelf.annotations addObject:a1];
                CLLocationCoordinate2D coordinates[areas.count];
                for (int index = 0; index < areas.count; index ++) {
                    coordinates[index].longitude = [areas[index][0] doubleValue];
                    coordinates[index].latitude = [areas[index][1] doubleValue];
                }
                MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:areas.count];
                [arr addObject:polygon];
                
            }
            [weakSelf.mapView addAnnotations:weakSelf.annotations];
            [weakSelf.mapView removeOverlays:weakSelf.polygons];
            weakSelf.polygons = [NSArray arrayWithArray:arr];
            [weakSelf.mapView addOverlays:weakSelf.polygons];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void) getAroundSiteRequest
{
    YYAroundSiteRequest *request = [[YYAroundSiteRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kArroundBikeAPI];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
    request.lat = coordinate.latitude;
    request.lng = coordinate.longitude;
    WEAK_REF(self);
    [QMUITips showLoadingInView:self.view];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [QMUITips hideAllToastInView:weak_self.view animated:YES];
        if (success) {
            [weak_self.mapView removeAnnotations:weak_self.annotations];
            [weak_self.mapView removeOverlays:weak_self.polygons];
            weak_self.lastPostion = coordinate;
            weak_self.bikeModels = [YYBikeModel modelArrayWithDictArray:response];
            [weak_self.mapView removeAnnotations:weak_self.annotations];
            weak_self.annotations = [NSMutableArray array];
            
            for (int i = 0; i < weak_self.bikeModels.count; ++i)
            {
                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                a1.coordinate = CLLocationCoordinate2DMake(weak_self.bikeModels[i].lat, weak_self.bikeModels[i].lon);
                a1.title      = [NSString stringWithFormat:@"%d", i];
                a1.subtitle   =  [NSString stringWithFormat:@"%ld",(long)weak_self.bikeModels[i].discount];
                if ([weak_self.bikeModels[i].last_percent floatValue] < 0.2 || weak_self.bikeModels[i].isonline == NO) {
                    a1.subtitle = [NSString stringWithFormat:@"%d",3];
                }
                [weak_self.annotations addObject:a1];
            }
            [weak_self.mapView addAnnotations:weak_self.annotations];
            
            //[weak_self getArroundAreaData];
        }
    } error:^(NSError *error) {
        [QMUITips hideAllToastInView:weak_self.view animated:YES];
    }];
    
}



-(void) dirctAction:(NSNotification *)noti
{
    YYSiteModel *model = (YYSiteModel *)noti.object;
    self.destinationCoordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    [self.mapView setCenterCoordinate:self.destinationCoordinate];
    [self ddd:nil];
}

//客服电话
- (IBAction)kefuButtonClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"0596-2671066" message:[NSString stringWithFormat:@"%@",@""] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"0596-2671066"]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)guideButtonClick:(id)sender {
    YYGuideViewController *guideViewController = [[YYGuideViewController alloc] init];
    [self.navigationController pushViewController:guideViewController animated:YES];
}

- (IBAction)YYInformationController:(id)sender {
    YYInformationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"information"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)refreshButtonClick:(UIButton *)sender {
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = 3;
    [sender.layer addAnimation:animation forKey:nil];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self getAroundSiteRequest];
    }else{
        [self getArroundAreaData];
    }
}



- (IBAction)faultRepairButtonClick:(UIButton *)sender {
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
        return;
    }
    YYFaultWarrantyController *faultWarrantyController = [[UIStoryboard storyboardWithName:@"Score" bundle:nil] instantiateViewControllerWithIdentifier:@"faultRepair"];
    [self.navigationController pushViewController:faultWarrantyController animated:YES];
}


-(void) loginSuccessAction:(NSNotification *)noti
{
    //[self checkAccount];
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
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
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
            
            //学生证认证(审核失败)
            if (weak_self.userModel.authtype == 1 && weak_self.userModel.xstate == 2) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYReAuthViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"reAuth"];
                [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
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
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"还车成功" withExtension:@".wav"];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer play];
    
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
            
            //学生证认证(审核失败)
            if (weak_self.userModel.authtype == 1 && weak_self.userModel.xstate == 2  && (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3)) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYReAuthViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"reAuth"];
                [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
                return;
            }
            
            //其他认证(认证中)
            if (weak_self.userModel.authtype == 2 && weak_self.userModel.cstate == 0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYOtherAuthViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"otherAuth"];
                certificationViewController.preState = YES;
                [self presentViewController:[[QMUINavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
                return;
            }
            
            //其他认证(审核失败)
            if (weak_self.userModel.authtype == 2 && weak_self.userModel.cstate == 2  && (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3)) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYReAuthViewController1 *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"reAuth1"];
                [weak_self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
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



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.flag = 0;
    //用户登录的情况下获取用户状态
    if ([YYUserManager isHaveLogin]) {
        [self getUserInfoRequest];
        
        //[self loadMyAppoinmentBikes];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) loadMyAppoinmentBikes {
    YYMyAppointmentRequest *request = [YYMyAppointmentRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kMyAppointmentAPI]];
    request.lat = self.userLocationAnnotationView.annotation.coordinate.latitude;
    request.lng = self.userLocationAnnotationView.annotation.coordinate.longitude;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            YYAppointmentModel *model = [YYAppointmentModel modelWithDictionary:response];
            YYBikeInfoView *bikeInfoView = [[YYBikeInfoView alloc] init];
           
            bikeInfoView.delegate = weakSelf;
            bikeInfoView.frame = CGRectMake(0, -263, SCREEN_WIDTH, 263);
            weakSelf.bikeInfoView = bikeInfoView;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, -263, SCREEN_WIDTH, 263)];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectGetMaxY(weakSelf.topView.frame), SCREEN_WIDTH, 263)];
            [weakSelf.bikeInfoView.layer pop_addAnimation:animation forKey:nil];
            [weakSelf.view addSubview:self.bikeInfoView];
            DTTimePeriod *period = [DTTimePeriod timePeriodWithStartDate:[NSDate date] endDate:[NSDate dateWithString:model.outtime formatString:@"yyyy-MM-dd hh:mm:ss"]];
            [weakSelf.bikeInfoView.countDownLabel setCountDownTime:[period durationInSeconds]];
            weakSelf.bikeInfoView.appModel = model;
            bikeInfoView.countDownHeightCons.constant = 44;
            bikeInfoView.countDownLabel.hidden = NO;
            weakSelf.Renting = YES;
            //NSLog(@"%@",response);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)closeNoticeButtonClick:(id)sender {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    self.tmpFrame = self.noticeView.frame;
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(15, self.noticeView.top , 0, 0)];
    animation.duration = 0.5;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.noticeView.hidden = YES;
        self.noticeButton.hidden = NO;
    }];
    [self.noticeView.layer pop_addAnimation:animation forKey:nil];
}

- (IBAction)noticeButtonClick:(id)sender {

    self.noticeButton.hidden = YES;
     self.noticeView.hidden = NO;
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(15, self.noticeView.top, kScreenWidth - 30, self.tmpFrame.size.height)];
    animation.duration = 0.5;
    [self.noticeView.layer pop_addAnimation:animation forKey:nil];
}


- (IBAction)ddd:(id)sender {
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude
                                           longitude:self.mapView.userLocation.coordinate.longitude];
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


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"message1"] || [identifier isEqualToString:@"invite"] || [identifier isEqualToString:@"scanCode"] || [identifier isEqualToString:@"faultRepair"]) {
        if (![YYUserManager isHaveLogin]) {
            UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
            return NO;
        }
        
        if (self.userModel == nil) {
            [QMUITips showWithText:@"网络不给力" inView:self.view hideAfterDelay:2];
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
        
        //学生证认证(审核失败)
        if (self.userModel.authtype == 1 && self.userModel.xstate == 2 && (self.userModel.dstate == 0 || self.userModel.dstate == 3)) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYReAuthViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"reAuth"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
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
        
        //其他认证(认证中)
        if (self.userModel.authtype == 2 && self.userModel.cstate == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYOtherAuthViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"otherAuth"];
            certificationViewController.preState = YES;
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:certificationViewController] animated:YES completion:nil];
            return NO;
        }
        
        //其他认证(审核失败)
        if (self.userModel.authtype == 2 && self.userModel.cstate == 2  && (self.userModel.dstate == 0 || self.userModel.dstate == 3)) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYReAuthViewController1 *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"reAuth1"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:payDepositViewController] animated:YES completion:nil];
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
    _mapView.showsCompass                = NO;
    _mapView.showsScale                  = NO;
    _mapView.rotateEnabled               = NO;
    _mapView.minZoomLevel = 3;
    [_mapView setZoomLevel:16.5 animated:YES];
    [self.view insertSubview:_mapView atIndex:0];

    [self initAnnotations];

    self.noticeView.layer.cornerRadius = self.noticeView.height * 0.4;
    if ([YYFileCacheManager readUserDataForKey:@"config"][@"chargerule"] != nil) {
          self.noticeLabel.text = [YYFileCacheManager readUserDataForKey:@"config"][@"chargerule"];
    }
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

//-(void) getAroundSiteRequest
//{
//    YYAroundSiteRequest *request = [[YYAroundSiteRequest alloc] init];
//    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAroundSiteAPI];
//
//    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
//
//    request.lat = coordinate.latitude;
//    request.lng = coordinate.longitude;
//
//    WEAK_REF(self);
//    [QMUITips showLoadingInView:self.view];
//    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//        [QMUITips hideAllToastInView:weak_self.view animated:YES];
//        if (success) {
//
//            weak_self.lastPostion = coordinate;
//            weak_self.models = [YYSiteModel modelArrayWithDictArray:response];
//            [weak_self.mapView removeAnnotations:weak_self.annotations];
//            weak_self.annotations = [NSMutableArray array];
//            weak_self.navScrollView.models = weak_self.models;
//
//            for (int i = 0; i < weak_self.models.count; ++i)
//            {
//                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
//                a1.coordinate = CLLocationCoordinate2DMake(weak_self.models[i].latitude, weak_self.models[i].longitude);
//                a1.title      = [NSString stringWithFormat:@"%d", i];
//                a1.subtitle = weak_self.models[i].address;
//                [weak_self.annotations addObject:a1];
//
//            }
//            if (weak_self.annotations.count > 0) {
//
//                [weak_self.mapView addAnnotations:self.annotations];
//
//            }
//
//        }
//    } error:^(NSError *error) {
//        [QMUITips hideAllToastInView:weak_self.view animated:YES];
//    }];
//
//}

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
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            YYBikeModel *model = self.bikeModels[[annotation.title integerValue]];
            if (model.isonline == 0 || [model.last_percent floatValue] < 0.2) {
                annotationView.image = [UIImage imageNamed:@"车辆(不可用)"];
            }else{
                if (model.red == 1) {
                    annotationView.image = [UIImage imageNamed:@"红包车"];
                }else{
                    annotationView.image = [UIImage imageNamed:@"07车辆"];
                }
            }
         
            
        }else{
            YYSiteModel *model = self.models[[annotation.title integerValue]];
            if (model.red == 1) {
                annotationView.image = [UIImage imageNamed:@"红包站点"];
            }else{
                annotationView.image = [UIImage imageNamed:@"站点"];
            }
        }
        
       
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
    if (self.Renting) {
        return;
    }
    self.listView.hidden = YES;
    if (self.siteView) {
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 184)];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, SCREEN_HEIGHT - 184 - 12, SCREEN_WIDTH, 184)];
        [self.siteView.layer pop_addAnimation:animation forKey:nil];
        animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            [self.siteView removeFromSuperview];
            self.siteView = nil;
        };
    }
    if (self.bikeInfoView) {
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0,  -263, SCREEN_WIDTH, 263)];
        [self.bikeInfoView.layer pop_addAnimation:animation forKey:nil];
        animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            [self.bikeInfoView removeFromSuperview];
            self.bikeInfoView = nil;
        };
    }
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if (self.Renting) {
        return;
    }
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
    }
    [self.mapView deselectAnnotation:view.annotation animated:NO];
    if ([view.annotation.subtitle isEqualToString:@"2"]){
        if (self.siteView == nil) {
            YYSiteInfoView *siteView = [[YYSiteInfoView alloc] init];
            siteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 184);
            self.siteView = siteView;
            [self.view addSubview:self.siteView];
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 184)];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, SCREEN_HEIGHT - 184 - 12, SCREEN_WIDTH, 184)];
            [self.siteView.layer pop_addAnimation:animation forKey:nil];
        }
        self.siteView.model = self.models[[view.annotation.title integerValue]];
    }else{
        if (self.bikeInfoView == nil) {
            YYBikeInfoView *bikeInfoView = [[YYBikeInfoView alloc] init];
            bikeInfoView.delegate = self;
            bikeInfoView.frame = CGRectMake(0, -263, SCREEN_WIDTH, 263);
            self.bikeInfoView = bikeInfoView;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, -263, SCREEN_WIDTH, 263)];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, 263)];
            [self.bikeInfoView.layer pop_addAnimation:animation forKey:nil];
            [self.view addSubview:self.bikeInfoView];
        }
        self.bikeInfoView.model = self.bikeModels[[view.annotation.title integerValue]];
    }
//    if ([view.annotation.subtitle isEqualToString:@"2"]){
//        self.siteInfoView.hidden = NO;
//        self.rentalButton.hidden = self.gpsButton.hidden = self.refreshButton.hidden = self.alarmButton.hidden = self.serviceButton.hidden = !self.siteInfoView.hidden;
//        NSArray *info = [view.annotation.title componentsSeparatedByString:@"_"];
//        self.siteNameLabel.text = info[0];
//        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",[info[1] doubleValue]];
//        [self.siteImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,info[2]]]];
//    } else{
//        self.siteInfoView.hidden = YES;
//        self.rentalButton.hidden = self.gpsButton.hidden = self.refreshButton.hidden = self.alarmButton.hidden = self.serviceButton.hidden = !self.siteInfoView.hidden;
//        NSString *deviceID = [NSString stringWithFormat:@"%ld",(long)self.bikeModels[[[view.annotation title] integerValue]].did];
//        YYScanCodeRequest *request = [[YYScanCodeRequest alloc] init];
//        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kScanCodeAPI];
//        request.code = deviceID;
//        __weak __typeof(self)weakSelf = self;
//        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//            if (success) {
//                YYBikeModel *model = [YYBikeModel modelWithDictionary:response];
//                model.userLon = weakSelf.mapView.userLocation.coordinate.longitude;
//                model.userLat = weakSelf.mapView.userLocation.coordinate.latitude;
//                AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
//                navi.origin = [AMapGeoPoint locationWithLatitude:weakSelf.mapView.userLocation.coordinate.latitude
//                                                       longitude:weakSelf.mapView.userLocation.coordinate.longitude];
//                navi.destination = [AMapGeoPoint locationWithLatitude:model.lat
//                                                            longitude:model.lon];
//                
//                [weakSelf.search AMapWalkingRouteSearch:navi];
//                if (weakSelf.bikeInfoView == nil) {
//                    YYBikeInfoView *bikeInfoView = [[YYBikeInfoView alloc] init];
//                    bikeInfoView.delegate = weakSelf;
//                    bikeInfoView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + weakSelf.navigationController.navigationBar.frame.size.height + 1, SCREEN_WIDTH, bikeInfoView.qmui_height);
//                    [weakSelf.view addSubview:bikeInfoView];
//                    weakSelf.bikeInfoView = bikeInfoView;
//                    weakSelf.segmentedControl.hidden = YES;
//                }
//                weakSelf.bikeInfoView.model = model;
//            }else{
//                QMUITips *tips = [QMUITips createTipsToView:weakSelf.view];
//                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
//                contentView.minimumSize = CGSizeMake(100, 100);
//                [tips showWithText:message hideAfterDelay:2];
//            }
//        } error:^(NSError *error) {
//            
//        }];
//        
//    }
    
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
        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
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
        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
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
    
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self getAroundSiteRequest];
    }else{
        [self getArroundAreaData];
    }
   
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
}

- (void)updateTotal
{
    self.totalCourse = self.route.paths.count;
}

- (IBAction)tapAction:(id)sender {
    self.flag = 1;
    [self performSegueWithIdentifier:@"desSegue" sender:nil];
}





-(void) YYRecomendListView:(YYRecomendListView *)recomendListView didClickCloseButton:(UIButton *)closeButton
{
    [self.listView removeFromSuperview];
    self.listView = nil;
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[YYFileCacheManager readUserDataForKey:@"config"][@"shareTitle"] descr:@"" thumImage:[UIImage imageNamed:@"1024"]];
    //设置网页地址
    shareObject.webpageUrl = [YYFileCacheManager readUserDataForKey:@"config"][@"shareUrl"];
   
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
            
                UMSocialLogInfo(@"response message is %@",resp.message);
            }
            [self.modalPrentViewController hideWithAnimated:YES completion:nil];
            YYRegisterHBView *registerHBView = [[YYRegisterHBView alloc] init];
            registerHBView.delegate = self;
            QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
            modalViewController.contentView = registerHBView;
            modalViewController.maximumContentViewWidth = kScreenWidth;
            modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
            [modalViewController showWithAnimated:YES completion:nil];
            self.modalPrentViewController = modalViewController;
         
        }
    }];
}


-(void)YYRegisterHBView:(YYRegisterHBView *)registerHBView didClickOKButton:(UIButton *)okButton
{
    [QMUITips showLoadingInView:self.view];
    YYGetCouponRequest *request = [[YYGetCouponRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetCouponAPI];
//    if (registerHBView.fromLogin) {
//        request.type = 0;
//    }else{
//        request.type = 2;
//    }
    request.type = 3;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [QMUITips hideAllToastInView:weakSelf.view animated:YES];
        if (success) {
            [QMUITips showSucceed:message inView:weakSelf.view hideAfterDelay:2];
            [weakSelf.modalPrentViewController hideWithAnimated:YES completion:nil];
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }
    }];
    
}

- (void)YYBikeInfoView:(YYBikeInfoView *)bikeView didClickSearchButton:(UIButton *)button
{
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
        return;
    }
    
    YYFindBikeRequest *request = [[YYFindBikeRequest alloc] init];
    request.deviceid = bikeView.model.deviceid;
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFindBikeAPI1];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message){
        
    } error:^(NSError *error) {
        
    }];
}

- (void)YYBikeInfoView:(YYBikeInfoView *)bikeView didClickAppointmentButton:(UIButton *)button
{
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
        return;
    }
    
    if (!self.userModel.vipstate) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            YYBuyMemberCardViewController *memberCardViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"memberCard"];
            [self.navigationController pushViewController:memberCardViewController animated:YES];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"您暂时还不是VIP，如需预约请前去购买" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
        return;
    }
    
    if (bikeView.countDownLabel.counting) {
        YYCancelAppointmentRequest *request = [YYCancelAppointmentRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kCancelAppointmentAPI]];
        __weak __typeof(self)weakSelf = self;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                weakSelf.Renting = NO;
                [QMUITips showSucceed:message inView:weakSelf.view hideAfterDelay:1.5];
                [bikeView.appoimentButton setTitle:@"预约（VIP专享）" forState:UIControlStateNormal];
                bikeView.countDownHeightCons.constant = 0;
                bikeView.countDownView.hidden = YES;
                [bikeView.countDownLabel setCountDownTime:0];
            }else{
                [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:1.5];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
        YYAppointmentRequest *request = [YYAppointmentRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kAppointmentAPI]];
        request.bid = bikeView.model.ID;
        __weak __typeof(self)weakSelf = self;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//            [bikeView.countDownLabel setCountDownTime:10];
//            [bikeView.countDownLabel start];
//            
//            bikeView.countDownHeightCons.constant = 44;
//            bikeView.countDownView.hidden = NO;
            if (success) {
                weakSelf.Renting = YES;
                bikeView.countDownHeightCons.constant = 44;
                bikeView.countDownView.hidden = NO;
                [bikeView.appoimentButton setTitle:@"取消预约" forState:UIControlStateNormal];
                [bikeView.countDownLabel setCountDownTime:60 * [response integerValue]];
                [bikeView.countDownLabel start];
            }else{
                [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:1.5];
            }
        } error:^(NSError *error) {
            
        }];
    }
  
}


-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    self.bikeInfoView.countDownView.hidden = YES;
    self.bikeInfoView.countDownHeightCons.constant = 0;
    self.Renting = NO;
}


@end
