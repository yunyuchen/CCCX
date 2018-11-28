//
//  YYReturnViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYReturnViewController.h"
#import "YYAroundSiteRequest.h"
#import "YYReturnBikeRequest.h"
#import "YYSiteModel.h"
#import <pop/POP.h>
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "YYScrollAddressView.h"
#import "YYOrderInfoRequest.h"
#import "YYReturnResultModel.h"
#import "YYUserModel.h"
#import "YYOrderInfoView.h"
#import "YYTips1View.h"
#import "YYFileCacheManager.h"
#import "YYFaultWarrantyController.h"
#import "YYOrderPriceNoCheckRequest.h"
#import "YYBuyMemberCardViewController.h"
#import "YYEnabledCouponViewController.h"
#import "YYFeeIntroViewController.h"
#import "YYArroundAreaRequest.h"
#import "NSString+YYExtension.h"
#import "YYWarmPromptView.h"
#import "YYReturnFeedbackView.h"
#import "UIImage+Size.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <zlib.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <QMUIKit/QMUIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface YYReturnViewController ()<MAMapViewDelegate,AMapSearchDelegate,AddressViewDelegate,OrderInfoViewDelegate,Tips1ViewDelegate,ScrollAddressViewDelegate,AVAudioPlayerDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic,strong) AMapSearchAPI *search;

@property (nonatomic,strong) UIImageView *pickImageView;

@property (nonatomic,strong) NSArray<YYSiteModel *> *models;

@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

@property(nonatomic, strong) AVAudioPlayer *audioPlayer;

/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) AMapRoute *route;

@property (nonatomic,strong) YYScrollAddressView *addressView;

@property (nonatomic,strong) YYReturnResultModel *resultModel;

@property (nonatomic,assign) NSInteger selectedId;

@property (nonatomic,strong) YYUserModel *userModel;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (nonatomic,assign) BOOL flag;

@property (nonatomic,assign) BOOL firstLoad;

@property (nonatomic,weak) YYTips1View *tipsView;

@property (nonatomic,assign) CLLocationCoordinate2D lastPostion;

@property(nonatomic, weak) UIView *shadeView;

@property (nonatomic, strong) NSArray *polygons;

@property (weak, nonatomic) IBOutlet UIView *siteInfoView;

@property (weak, nonatomic) IBOutlet UIImageView *siteImageView;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property(nonatomic, strong) MAAnnotationView *selectedAnnotation;

@property(nonatomic, copy) NSString *bleID;

@property(nonatomic, weak) YYOrderInfoView* orderInfoView;

@property(nonatomic, strong) YYReturnFeedbackView *returnFeedbackView;

@property(nonatomic, strong) UIImage *uploadImage;

@property(nonatomic, assign) int bleFlag;

@property(nonatomic, assign) NSInteger rsid;

@end

@implementation YYReturnViewController

static NSString *reuseIndetifier = @"annotationReuseIndetifier";

-(NSArray<YYSiteModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"目的站点查询";
    [self initMap];
    [self initAnnotations];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.flag = NO;
    self.firstLoad = YES;
    self.annotations = [NSMutableArray array];
    
    YYTips1View *tips1View = [[YYTips1View alloc] init];
    tips1View.delegate = self;
    tips1View.frame = CGRectMake(0, 64, kScreenWidth, 150);
    tips1View.hidden = YES;
    self.tipsView = tips1View;
    [self.view addSubview:self.tipsView];
    
    [self checkLBSAuth];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopScanAction) name:@"stopScan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccessAction) name:@"connectSuccess" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        //[self getAroundSiteRequest];
        
        [self getArroundAreaData];
    });
}

- (void) connectSuccessAction
{
    [self.orderInfoView.confirmButton setTitle:@"连接成功 确定还车" forState:UIControlStateNormal];
    [self.orderInfoView.confirmButton setFillColor:[UIColor colorWithHexString:@"#218E02"]];
    self.orderInfoView.confirmButton.userInteractionEnabled = YES;
}

- (void) stopScanAction
{
    [self.orderInfoView.confirmButton setTitle:@"连接失败 通过网络还车" forState:UIControlStateNormal];
    self.bleFlag = 0;
    [self.orderInfoView.confirmButton setFillColor:[UIColor colorWithHexString:@"#000000"]];
    self.orderInfoView.confirmButton.userInteractionEnabled = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"stopScan" object:nil];
}

- (void) checkLBSAuth
{
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getUserInfoRequest];
    
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
    [_mapView setZoomLevel:16.5 animated:YES];
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.gpsButton];
    [self.view bringSubviewToFront:self.tipsView];
    [self.view bringSubviewToFront:self.siteInfoView];
    YYScrollAddressView *addressView = [[YYScrollAddressView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 130, kScreenWidth, 120)];
    [self.view addSubview:addressView];
    [self.view bringSubviewToFront:addressView];
    addressView.imgVLeft.delegate = self;
    addressView.imgVRight.delegate = self;
    addressView.imgVCenter.delegate = self;
    addressView.delegate = self;
    self.addressView = addressView;
    self.addressView.hidden = YES;
}

- (void)initAnnotations
{
    UIImageView *pickImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"zuobiao_icon_index"]];
    pickImageView.center = self.view.center;
    [self.view addSubview:pickImageView];
    [self.view bringSubviewToFront:pickImageView];
    self.pickImageView = pickImageView;
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
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *models = response;
            for (int i = 0; i < models.count; i++) {
                NSArray *areas = models[i][@"area"];
                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                a1.coordinate = CLLocationCoordinate2DMake([models[i][@"latitude"] doubleValue], [models[i][@"longitude"] doubleValue]);
                a1.title      = [NSString stringWithFormat:@"%@_%@_%@_%@", models[i][@"name"],models[i][@"distance"],models[i][@"img1"],models[i][@"id"]];
                a1.subtitle   = @"2";
                [weakSelf.annotations addObject:a1];
                CLLocationCoordinate2D coordinates[areas.count];
                for (int index = 0; index < areas.count; index ++) {
                    coordinates[index].longitude = [areas[index][0] doubleValue];
                    coordinates[index].latitude = [areas[index][1] doubleValue];
                }
                MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:areas.count];
                [arr addObject:polygon];
                if (i == 0) {
                    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
                    navi.origin = [AMapGeoPoint locationWithLatitude:weakSelf.mapView.userLocation.coordinate.latitude
                                                           longitude:weakSelf.mapView.userLocation.coordinate.longitude];
                    navi.destination = [AMapGeoPoint locationWithLatitude:a1.coordinate.latitude
                                                                longitude:a1.coordinate.longitude];
                    weakSelf.destinationCoordinate = CLLocationCoordinate2DMake(a1.coordinate.latitude, a1.coordinate.longitude);
                    weakSelf.siteNameLabel.text = models[i][@"name"];
                    weakSelf.distanceLabel.text = [NSString stringWithFormat:@"%.2f",[models[i][@"distance"] floatValue]];
                    [weakSelf.siteImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,models[i][@"img1"]]]];
                    [weakSelf.search AMapWalkingRouteSearch:navi];
                }
            }
            [weakSelf.mapView addAnnotations:weakSelf.annotations];
            [weakSelf.mapView removeOverlays:weakSelf.polygons];
            weakSelf.polygons = [NSArray arrayWithArray:arr];
            [weakSelf.mapView addOverlays:weakSelf.polygons];
        }
    } error:^(NSError *error) {
        
    }];
//    YYArroundAreaRequest *request = [[YYArroundAreaRequest alloc] init];
//    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAroundSiteAPI];
//    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
//    request.lat = coordinate.latitude;
//    request.lng = coordinate.longitude;
//    __weak __typeof(self)weakSelf = self;
//    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//        if (success) {
//            NSLog(@"%@",response);
//            NSMutableArray *arr = [NSMutableArray array];
//            NSArray *models = response;
//            for (int i = 0; i < models.count; i++) {
//                NSArray *areas = models[i][@"area"];
//                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
//                a1.coordinate = CLLocationCoordinate2DMake([models[i][@"latitude"] doubleValue], [models[i][@"longitude"] doubleValue]);
//                a1.title      = [NSString stringWithFormat:@"%@_%@_%@", models[i][@"name"],models[i][@"distance"],models[i][@"img1"]];
//                a1.subtitle   = [NSString stringWithFormat:@"%d",i];
//                [weakSelf.annotations addObject:a1];
//                CLLocationCoordinate2D coordinates[areas.count];
//                for (int index = 0; index < areas.count; index ++) {
//                    coordinates[index].longitude = [areas[index][0] doubleValue];
//                    coordinates[index].latitude = [areas[index][1] doubleValue];
//                }
//                MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:areas.count];
//                [arr addObject:polygon];
//                if (i == 0) {
//                    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
//                    navi.origin = [AMapGeoPoint locationWithLatitude:weakSelf.mapView.userLocation.coordinate.latitude
//                                                           longitude:weakSelf.mapView.userLocation.coordinate.longitude];
//                    navi.destination = [AMapGeoPoint locationWithLatitude:a1.coordinate.latitude
//                                                                longitude:a1.coordinate.longitude];
//                    weakSelf.destinationCoordinate = CLLocationCoordinate2DMake(a1.coordinate.latitude, a1.coordinate.longitude);
//                    weakSelf.siteNameLabel.text = models[i][@"name"];
//                    weakSelf.distanceLabel.text = [NSString stringWithFormat:@"%.2f",[models[i][@"distance"] floatValue]];
//                    [weakSelf.siteImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,models[i][@"img1"]]]];
//                    [weakSelf.search AMapWalkingRouteSearch:navi];
//                }
//            }
//            [weakSelf.mapView addAnnotations:weakSelf.annotations];
//            [weakSelf.mapView removeOverlays:weakSelf.polygons];
//            weakSelf.polygons = [NSArray arrayWithArray:arr];
//            [weakSelf.mapView addOverlays:weakSelf.polygons];
//        }
//    } error:^(NSError *error) {
//
//    }];
}

-(void) getAroundSiteRequest
{
    YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
    orderInfoView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 473);
    orderInfoView.delegate = self;
    self.orderInfoView = orderInfoView;
    YYOrderInfoRequest *request = [[YYOrderInfoRequest alloc] init];
    request.lat = self.mapView.userLocation.coordinate.latitude;
    request.lng = self.mapView.userLocation.coordinate.longitude;
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderPriceAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            YYReturnResultModel *model = [YYReturnResultModel modelWithDictionary:response];
            if (model.movebike <= 0) {
                UIView *shadeView = [[UIView alloc] initWithFrame:weakSelf.view.bounds];
                shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                [weakSelf.view addSubview:shadeView];
                weakSelf.shadeView = shadeView;
                orderInfoView.resultModel = model;
                [weakSelf.view addSubview:orderInfoView];
                POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight - 473, kScreenWidth, 473)];
                animation.beginTime = CACurrentMediaTime();
                animation.duration = 0.5;
                [orderInfoView pop_addAnimation:animation forKey:kPOPViewFrame];
            }else{
                NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"还车失败" withExtension:@".mp3"];
                weakSelf.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
                weakSelf.audioPlayer.numberOfLoops = 0;
                [weakSelf.audioPlayer play];
                weakSelf.tipsView.hidden = NO;
                weakSelf.siteInfoView.hidden = NO;
                [self showWarmView];
                weakSelf.tipsView.movebikeLabel.text = [NSString stringWithFormat:@"(%.2f元)",model.movebike];
                [weakSelf.view bringSubviewToFront:weakSelf.tipsView];
            }
            
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }}];
    
}

- (IBAction)returnButtonClick:(id)sender {
    YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
    orderInfoView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 473);
    orderInfoView.delegate = self;
    
    YYOrderInfoRequest *request = [[YYOrderInfoRequest alloc] init];
    request.lat = self.mapView.userLocation.coordinate.latitude;
    request.lng = self.mapView.userLocation.coordinate.longitude;
    request.rsid = self.rsid;
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderPriceAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            YYReturnResultModel *model = [YYReturnResultModel modelWithDictionary:response];
            if (model.movebike <= 0) {
                UIView *shadeView = [[UIView alloc] initWithFrame:weakSelf.view.bounds];
                shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                [weakSelf.view addSubview:shadeView];
                weakSelf.shadeView = shadeView;
                orderInfoView.resultModel = model;
                orderInfoView.siteName = weakSelf.siteNameLabel.text;
                [weakSelf.view addSubview:orderInfoView];
                POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight - 473, kScreenWidth, 473)];
                animation.beginTime = CACurrentMediaTime();
                animation.duration = 0.5;
                weakSelf.tipsView.hidden = YES;
                [orderInfoView pop_addAnimation:animation forKey:kPOPViewFrame];
            }else{
                NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"还车失败" withExtension:@".mp3"];
                weakSelf.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
                weakSelf.audioPlayer.numberOfLoops = 0;
                [weakSelf.audioPlayer play];
                weakSelf.tipsView.hidden = NO;
                [self showWarmView];
                weakSelf.tipsView.movebikeLabel.text = [NSString stringWithFormat:@"(%.2f元)",model.movebike];
                [weakSelf.view bringSubviewToFront:weakSelf.tipsView];
            }
            
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }}];
}



- (IBAction)locationButtonClick:(UIButton *)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}


-(void) showRoute
{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude
                                           longitude:self.mapView.userLocation.coordinate.longitude];
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    [self.search AMapWalkingRouteSearch:navi];
    
}


#pragma mark - mapview delegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
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
        annotationView.image = [UIImage imageNamed:@"站点"];
        if ([annotation isKindOfClass:[MAUserLocation class]]){
            annotationView.image = [UIImage imageNamed:@"08定位02"];
            annotationView.imageView.hidden = NO;
        }
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        //annotationView.selected = YES;
        return annotationView;
    }
    return nil;
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
    }
    if ([view.annotation.subtitle isEqualToString:@"2"]){
        self.siteInfoView.hidden = NO;
        //self.rentalButton.hidden = self.gpsButton.hidden = self.refreshButton.hidden = self.alarmButton.hidden = self.serviceButton.hidden = !self.siteInfoView.hidden;
        self.selectedAnnotation = view;
        NSArray *info = [view.annotation.title componentsSeparatedByString:@"_"];
        self.siteNameLabel.text = info[0];
        self.rsid = [info[3] integerValue];
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",[info[1] doubleValue]];
        [self.siteImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,info[2]]]];
    }
}


-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    //self.tipsView.hidden = YES;
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
    MAMapPoint point1 = MAMapPointForCoordinate(self.lastPostion);
    MAMapPoint point2 = MAMapPointForCoordinate(coordinate);
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
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
    
    if (self.flag) {
        return;
    }
    self.flag = NO;
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
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth   = 4.f;
        polygonRenderer.strokeColor = [UIColor qmui_colorWithHexString:@"#FF9317"];
        polygonRenderer.fillColor   = [UIColor clearColor];
        polygonRenderer.lineCapType =  kMALineCapSquare;
        return polygonRenderer;
    }
    
    return nil;
    
}


#pragma mark - AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
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

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //self.tipsView.hidden = YES;
    self.siteInfoView.hidden = YES;
}

-(void)addressView:(YYAddressView *)addressView didClickReturnButton:(UIButton *)returnButton
{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
        YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
        orderInfoView.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, 473);
        orderInfoView.rsid = addressView.model.ID;
        orderInfoView.userModel = self.userModel;
        orderInfoView.delegate = self;
        orderInfoView.siteName = self.siteNameLabel.text;
        
        YYOrderInfoRequest *request = [[YYOrderInfoRequest alloc] init];
        request.rsid = self.models[self.selectedId].ID;
        request.lat = self.mapView.userLocation.coordinate.latitude;
        request.lng = self.mapView.userLocation.coordinate.longitude;
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderPriceAPI];
        WEAK_REF(self);
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                UIView *shadeView = [[UIView alloc] initWithFrame:weak_self.view.bounds];
                shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                [weak_self.view addSubview:shadeView];
                weak_self.shadeView = shadeView;
                orderInfoView.resultModel = [YYReturnResultModel modelWithDictionary:response];
                [weak_self.view addSubview:orderInfoView];
                POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight - 473, kScreenWidth, 473)];
                animation.beginTime = CACurrentMediaTime();
                animation.duration = 0.5;
                [orderInfoView pop_addAnimation:animation forKey:kPOPViewFrame];
                weak_self.firstLoad = NO;
            }else{
                if (self.models.count > 0) {
                    //1.将两个经纬度点转成投影点
                    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weak_self.models[self.selectedId].latitude,weak_self.models[weak_self.selectedId].longitude));
                    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weak_self.mapView.userLocation.coordinate.latitude,weak_self.mapView.userLocation.coordinate.longitude));
                    //2.计算距离
                    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                    weak_self.tipsView.distanceLabel.text = [NSString stringWithFormat:@"%.0f",distance];
                    weak_self.tipsView.addressLabel.text = [NSString stringWithFormat:@"您还未到还车点 %@ 无法还车",weak_self.models[weak_self.selectedId].name] ;;
                    weak_self.tipsView.hidden = NO;
                }
                
                
            }
        } error:^(NSError *error) {
            
        }];
        
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"1.区域外还车需扣除一定的挪车服务费，您确定要区域外还车吗？\n2.如有疑问，请在故障报修里提交内容，客服人员会联系您处理" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
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
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)orderInfoView:(YYOrderInfoView *)orderView didClickOKButton:(UIButton *)sender
{
    YYOrderInfoRequest *request = [[YYOrderInfoRequest alloc] init];
    request.lat = self.mapView.userLocation.coordinate.latitude;
    request.lng = self.mapView.userLocation.coordinate.longitude;
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderPriceAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            YYReturnResultModel *model = [YYReturnResultModel modelWithDictionary:response];
            if (model.movebike <= 0) {
                if ([orderView.confirmButton.currentTitle isEqualToString:@"点击连接"]) {
                    [orderView.confirmButton setTitle:@"连接中..." forState:UIControlStateNormal];
                    orderView.confirmButton.userInteractionEnabled = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"connect" object:nil];
                    return;
                }
                
                if (self.bleFlag) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shutdown" object:nil];
                    
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    YYReturnBikeRequest *request = [[YYReturnBikeRequest alloc] init];
                    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kReturnBikeAPI];
                    request.rsid = orderView.rsid;
                    request.lng = self.mapView.userLocation.coordinate.longitude;
                    request.lat = self.mapView.userLocation.coordinate.latitude;
                    request.cid = orderView.cid;
                    if (orderView.error > 0) {
                        request.error = orderView.error;
                    }
                    request.ble = self.bleFlag;
                    WEAK_REF(self);
                    QMUITips *tips = [QMUITips createTipsToView:self.view];
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(100, 100);
                    [tips showLoading];
                    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                        [tips hideAnimated:YES];
                        [weak_self.shadeView removeFromSuperview];
                        weak_self.shadeView = nil;
                        
                        
                        if (success) {
                            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                            
                            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight, kScreenWidth, 473)];
                            animation.beginTime = CACurrentMediaTime();
                            animation.duration = 0.5;
                            [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                                [orderView removeFromSuperview];
                            }];
                            [orderView pop_addAnimation:animation forKey:kPOPViewFrame];
                            weak_self.resultModel = [YYReturnResultModel modelWithDictionary:response];
                            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                            contentView.minimumSize = CGSizeMake(200, 100);
                            [tips showSucceed:@"还车成功" hideAfterDelay:2];
                            [YYFileCacheManager removeUserDataForkey:KBLEIDKey];
                            [YYFileCacheManager saveUserData:@"0" forKey:kBikeStateKey];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kReturnSuccessNotification object:nil];
                            [weak_self.navigationController popToRootViewControllerAnimated:YES];
                        }else{
                            
                            if ([message isEqualToString:@"车辆不在站点, 请到指定站点还车"]) {
                                if (self.models.count > 0) {
                                    //1.将两个经纬度点转成投影点
                                    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weak_self.models[weak_self.selectedId].latitude,weak_self.models[weak_self.selectedId].longitude));
                                    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weak_self.mapView.userLocation.coordinate.latitude,weak_self.mapView.userLocation.coordinate.longitude));
                                    //2.计算距离
                                    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                                    self.tipsView.distanceLabel.text = [NSString stringWithFormat:@"%.0f",distance];
                                    self.tipsView.addressLabel.text = [NSString stringWithFormat:@"您还未到还车点 %@ 无法还车",weak_self.models[weak_self.selectedId].name] ;;
                                    self.tipsView.hidden = NO;
                                }
                            }else{
                                //orderView.confirmButton.userInteractionEnabled = NO;
                                [QMUITips showError:message inView:self.view hideAfterDelay:2];
                                [orderView.confirmButton setTitle:@"点击连接" forState:UIControlStateNormal];
                                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"网络不好？通过手机蓝牙连接还车"];
                                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#218E02"] range:NSMakeRange(9, 6)];
                                orderView.connectTips.attributedText = attrStr;
                                orderView.connectTips.userInteractionEnabled = YES;
                                weak_self.bleFlag = 1;
                                
                            }
                            
                            
                        }
                    } error:^(NSError *error) {
                        [orderView.confirmButton setTitle:@"点击连接" forState:UIControlStateNormal];
                        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"网络不好？通过手机蓝牙连接还车"];
                        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#218E02"] range:NSMakeRange(9, 6)];
                        orderView.connectTips.attributedText = attrStr;
                        orderView.connectTips.userInteractionEnabled = YES;
                        weak_self.bleFlag = 1;
                        //[QMUITips showError:message inView:self.view hideAfterDelay:2];
                        [tips hideAnimated:YES];
                    }];
                });
            }else{
                POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                
                animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight, kScreenWidth, 473)];
                animation.beginTime = CACurrentMediaTime();
                animation.duration = 0.5;
                [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    [orderView removeFromSuperview];
                    [self.shadeView removeFromSuperview];
                    self.shadeView = nil;
                }];
                [orderView pop_addAnimation:animation forKey:kPOPViewFrame];
                NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"还车失败" withExtension:@".mp3"];
                weakSelf.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
                weakSelf.audioPlayer.numberOfLoops = 0;
                [weakSelf.audioPlayer play];
                weakSelf.tipsView.hidden = NO;
                [self showWarmView];
                weakSelf.tipsView.movebikeLabel.text = [NSString stringWithFormat:@"(%.2f元)",model.movebike];
                [weakSelf.view bringSubviewToFront:weakSelf.tipsView];
            }
            
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }}];
    
    
    
    
}

- (void) showWarmView
{
    YYWarmPromptView *contentView = [[YYWarmPromptView alloc] init];
    contentView.tipsLabel.image = [UIImage imageNamed:@"使用提示"];
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.contentViewMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    [modalViewController showWithAnimated:YES completion:nil];
}


-(void) navScrollView:(YYScrollAddressView *)scrollView didSelectCurrentModel:(YYSiteModel *)model
{
    for (int i = 0; i < self.annotations.count; i++) {
        if ([((MAPointAnnotation *)self.annotations[i]).subtitle isEqualToString:model.address]) {
            [self.mapView selectAnnotation:self.annotations[i] animated:YES];
            break;
        }
    }
}

-(void)orderInfoView:(YYOrderInfoView *)orderView didClickCloseButton:(UIButton *)sender
{
    [self.shadeView removeFromSuperview];
    self.shadeView = nil;
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight, kScreenWidth, 473)];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = 0.5;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self.orderInfoView removeFromSuperview];
    }];
    [orderView pop_addAnimation:animation forKey:kPOPViewFrame];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void) orderInfoView:(YYOrderInfoView *)orderView didClickBuyButton:(UIButton *)sender
{
    YYBuyMemberCardViewController *memberCardViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"memberCard"];
    [self.navigationController pushViewController:memberCardViewController animated:YES];
}

//选择优惠券
-(void)orderInfoView:(YYOrderInfoView *)orderView didClickCouponButton:(UIButton *)sender
{
    YYEnabledCouponViewController *couponViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Enabledcoupon"];
    couponViewController.selected = YES;
    couponViewController.cid = orderView.cid;
    CGFloat price = 0.0f;
    if (orderView.resultModel.vip > 1) {
        price = orderView.resultModel.price * orderView.resultModel.vip / 10;
    }else{
        price = orderView.resultModel.price;
    }
    if (orderView.resultModel.weekcut > 1) {
        price = price * orderView.resultModel.weekcut / 10;
    }
    couponViewController.price = price;
    [self.navigationController pushViewController:couponViewController animated:YES];
}



-(void)orderInfoView:(YYOrderInfoView *)orderView didClickFeeButton:(UIButton *)sender
{
    YYFeeIntroViewController *feeIntroViewController = [[YYFeeIntroViewController alloc] init];
    [self.navigationController pushViewController:feeIntroViewController animated:YES];
}



-(void)YYTips1View:(YYTips1View *)tipsView didClickCloseButton:(UIButton *)closeButton
{
    self.tipsView.hidden = YES;
    
}

-(void)YYTips1View:(YYTips1View *)tipsView didClickReturnButton:(UIButton *)returnButton
{
    //    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    //
    //    }];
    //    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    //        YYReturnBikeRequest *request = [[YYReturnBikeRequest alloc] init];
    //        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kReturnBikeAPI];
    //        request.lng = self.mapView.userLocation.coordinate.longitude;
    //        request.lat = self.mapView.userLocation.coordinate.latitude;
    //        WEAK_REF(self);
    //        [QMUITips showLoadingInView:self.view];
    //        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
    //            [QMUITips hideAllTipsInView:weak_self.view];
    //            if (success) {
    //                weak_self.resultModel = [YYReturnResultModel modelWithDictionary:response];
    //                [YYFileCacheManager removeUserDataForkey:KBLEIDKey];
    //                [YYFileCacheManager saveUserData:@"0" forKey:kBikeStateKey];
    //                [[NSNotificationCenter defaultCenter] postNotificationName:kReturnSuccessNotification object:nil];
    //                [weak_self.navigationController popToRootViewControllerAnimated:YES];
    //            }
    //        } error:^(NSError *error) {
    //            [QMUITips hideAllTipsInView:weak_self.view];
    //        }];
    //
    //    }];
    //    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"1.区域外还车需扣除一定的挪车服务费，您确定要区域外还车吗？\n2.如有疑问，请在故障报修里提交内容，客服人员会联系您处理" preferredStyle:QMUIAlertControllerStyleAlert];
    //    [alertController addAction:action1];
    //    [alertController addAction:action2];
    //    [alertController showWithAnimated:YES];
    YYReturnFeedbackView *contentView = [[YYReturnFeedbackView alloc] init];
    contentView.center = self.view.center;
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    contentView.addPhotoBlock = ^{
        UIImagePickerController *pickerCon = [[UIImagePickerController alloc] init];
        pickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerCon.delegate = self;
        [self presentViewController:pickerCon animated:YES completion:nil];
        
    };
    contentView.cancleBlock = ^{
        [self.returnFeedbackView removeFromSuperview];
        self.returnFeedbackView = nil;
    };
    contentView.confirmBlock = ^{
        if (self.uploadImage == nil) {
            [QMUITips showWithText:@"请上传图片" inView:self.view hideAfterDelay:1.5];
            return;
        }
        YYBaseRequest *uploadRequest = [[YYBaseRequest alloc] init];
        uploadRequest.nh_url = [NSString stringWithFormat:@"%@%@?folder=feedback",kBaseURL,kUploadPhotoAPI];;
        uploadRequest.nh_isPost = YES;
        NSArray *uploadArray = [NSArray arrayWithObjects:[UIImage compressImage:self.uploadImage toByte:1024 * 20], nil];
        uploadRequest.nh_imageArray = uploadArray;
        [uploadRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [SVProgressHUD dismiss];
            if (success) {
                YYReturnBikeRequest *request = [[YYReturnBikeRequest alloc] init];
                request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kReturnBikeAPI];
                request.lng = self.mapView.userLocation.coordinate.longitude;
                request.lat = self.mapView.userLocation.coordinate.latitude;
                request.img = response;
                WEAK_REF(self);
                [QMUITips showLoadingInView:self.view];
                [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    [QMUITips hideAllToastInView:weak_self.view animated:YES];
                    if (success) {
                        weak_self.resultModel = [YYReturnResultModel modelWithDictionary:response];
                        [YYFileCacheManager removeUserDataForkey:KBLEIDKey];
                        [YYFileCacheManager saveUserData:@"0" forKey:kBikeStateKey];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kReturnSuccessNotification object:nil];
                        [weak_self.navigationController popToRootViewControllerAnimated:YES];
                    }
                } error:^(NSError *error) {
                    [QMUITips hideAllToastInView:weak_self.view animated:YES];
                }];
                
            }
            
        } error:^(NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
        
    };
    [self.view addSubview:contentView];
    self.returnFeedbackView = contentView;
}

-(void)YYTips1View:(YYTips1View *)tipsView didClickFeedBackButton:(UIButton *)feedBackButton
{
    YYFaultWarrantyController *faultWarrantyController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"faultRepair"];
//    faultWarrantyController.isFromReturnViewController = YES;
//    faultWarrantyController.deviceId = self.deviceId;
    [self.navigationController pushViewController:faultWarrantyController animated:YES];
    //YYFeedBackController *feedBackViewController = [[YYFeedBackController alloc] init];
    //[self.navigationController pushViewController:feedBackViewController animated:YES];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [self.returnFeedbackView.imageButton setImage:photos[0] forState:UIControlStateNormal];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *img=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.uploadImage = img;
    [self.returnFeedbackView.imageButton setImage:self.uploadImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
