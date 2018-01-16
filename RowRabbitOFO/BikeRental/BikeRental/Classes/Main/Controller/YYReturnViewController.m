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
#import "POP.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "YYScrollAddressView.h"
#import "YYOrderInfoRequest.h"
#import "YYReturnResultModel.h"
#import "YYUserModel.h"
#import "YYOrderInfoView.h"
#import "YYTips1View.h"
#import "YYFileCacheManager.h"
#import "YYFeedBackController.h"
#import "YYOrderPriceNoCheckRequest.h"
#import "YYBuyMemberCardViewController.h"
#import "YYEnabledCouponViewController.h"
#import "YYFeeIntroViewController.h"
#import <QMUIKit/QMUIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface YYReturnViewController ()<MAMapViewDelegate,AMapSearchDelegate,AddressViewDelegate,OrderInfoViewDelegate,Tips1ViewDelegate,ScrollAddressViewDelegate,AVAudioPlayerDelegate>

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

@end

@implementation YYReturnViewController

static NSString *reuseIndetifier = @"annotationReuseIndetifier";

//static const NSInteger RoutePlanningPaddingEdge  = 20;
-(NSArray<YYSiteModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"目的站点查询";
    
    [self initMap];
    
    [self initAnnotations];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.flag = NO;
    self.firstLoad = YES;

    YYTips1View *tips1View = [[YYTips1View alloc] init];
    tips1View.delegate = self;
    tips1View.frame = CGRectMake(0, 64, kScreenWidth, 272);
    tips1View.hidden = YES;
    self.tipsView = tips1View;
    [self.view addSubview:self.tipsView];
    
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
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getUserInfoRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    [_mapView setZoomLevel:16.5 animated:YES];
    
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.gpsButton];
    [self.view bringSubviewToFront:self.tipsView];
    
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

-(void) getAroundSiteRequest
{
    YYAroundSiteRequest *request = [[YYAroundSiteRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAroundSiteAPI];
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
    
    request.lat = coordinate.latitude;
    request.lng = coordinate.longitude;
    
    WEAK_REF(self);
    [QMUITips showLoadingInView:self.view];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        if (success) {
             weak_self.lastPostion = coordinate;
            weak_self.models = [YYSiteModel modelArrayWithDictArray:response];
           
            if (weak_self.models.count > 0) {
                weak_self.addressView.hidden = NO;
            }else{
                weak_self.addressView.hidden = YES;
            }
            for (YYSiteModel *model in weak_self.models) {
                //1.将两个经纬度点转成投影点
                MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(model.latitude,model.longitude));
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weak_self.mapView.userLocation.coordinate.latitude,weak_self.mapView.userLocation.coordinate.longitude));
                //2.计算距离
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                model.distance = distance;
            }
             weak_self.addressView.models = weak_self.models;
            [weak_self.mapView removeAnnotations:weak_self.annotations];
            weak_self.annotations = [NSMutableArray array];
            
            for (int i = 0; i < weak_self.models.count; ++i)
            {
                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                a1.coordinate = CLLocationCoordinate2DMake(weak_self.models[i].latitude, weak_self.models[i].longitude);
                a1.title      = [NSString stringWithFormat:@"%d", i];
                a1.subtitle = weak_self.models[i].address;
                [weak_self.annotations addObject:a1];
                
            }
            if (weak_self.annotations.count > 0) {
                [weak_self.mapView addAnnotations:weak_self.annotations];
    
            }
            
            if (self.annotations.count > 0) {
                 self.selectedId = 0;
            }
            if (weak_self.models.count > 0 && weak_self.firstLoad) {
                YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
                orderInfoView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 400);
                orderInfoView.rsid = weak_self.models[0].ID;
                orderInfoView.userModel = weak_self.userModel;
                orderInfoView.delegate = weak_self;
                orderInfoView.siteName = weak_self.models[0].name;
             
                
                YYOrderInfoRequest *request = [[YYOrderInfoRequest alloc] init];
                request.rsid = weak_self.models[0].ID;
                request.lat = self.mapView.userLocation.coordinate.latitude;
                request.lng = self.mapView.userLocation.coordinate.longitude;
                request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderPriceAPI];
               
                [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    if (success) {
                        UIView *shadeView = [[UIView alloc] initWithFrame:weak_self.view.bounds];
                        shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                        [weak_self.view addSubview:shadeView];
                        weak_self.shadeView = shadeView;
                        orderInfoView.resultModel = [YYReturnResultModel modelWithDictionary:response];
                        [weak_self.view addSubview:orderInfoView];
                        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight - 400, kScreenWidth, 400)];
                        animation.beginTime = CACurrentMediaTime();
                        animation.duration = 0.5;
                        [orderInfoView pop_addAnimation:animation forKey:kPOPViewFrame];
                    }else{
                        if (self.models.count > 0) {
                            //1.将两个经纬度点转成投影点
                            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weak_self.models[self.selectedId].latitude,weak_self.models[self.selectedId].longitude));
                            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weak_self.mapView.userLocation.coordinate.latitude,weak_self.mapView.userLocation.coordinate.longitude));
                            //2.计算距离
                            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                            weak_self.tipsView.distanceLabel.text = [NSString stringWithFormat:@"%.0f",distance];
                            weak_self.tipsView.addressLabel.text = weak_self.models[weak_self.selectedId].name;
                            weak_self.tipsView.hidden = NO;
                            [weak_self.view bringSubviewToFront:weak_self.tipsView];
                        }
                    }
                } error:^(NSError *error) {
                    
                }];
           
                weak_self.firstLoad = NO;
            }
            
        }
    } error:^(NSError *error) {
          [QMUITips hideAllToastInView:self.view animated:YES];
    }];
    
}

- (IBAction)locationButtonClick:(UIButton *)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}




-(void) showRoute
{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude
                                           longitude:self.mapView.userLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    [self.search AMapWalkingRouteSearch:navi];

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
        self.selectedId = [view.annotation.title integerValue];
        self.destinationCoordinate = view.annotation.coordinate;
        
        [self showRoute];
        
      self.tipsView.hidden = YES;
        
        [self.addressView setInfoByCurrentModelIndex:self.selectedId];
        if (self.flag) {
            return;
        }
      
        self.flag = YES;
    }
    
}


-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    self.tipsView.hidden = YES;
 
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
    
    /* 缩放地图使其适应polylines的展示. */
//    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
//                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
//                           animated:YES];
}

- (void)updateTotal
{
    self.totalCourse = self.route.paths.count;
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.tipsView.hidden = YES;
}

-(void)addressView:(YYAddressView *)addressView didClickReturnButton:(UIButton *)returnButton
{
    YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
    orderInfoView.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, 400);
    orderInfoView.rsid = addressView.model.ID;
    orderInfoView.userModel = self.userModel;
    orderInfoView.delegate = self;
    orderInfoView.siteName = addressView.model.name;
    
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
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight - 400, kScreenWidth, 400)];
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
                self.tipsView.distanceLabel.text = [NSString stringWithFormat:@"%.0f",distance];
                self.tipsView.addressLabel.text = self.models[self.selectedId].name;
                self.tipsView.hidden = NO;
            }
        
           
        }
    } error:^(NSError *error) {
        
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
            
            QMUILog(@"----------------");
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)orderInfoView:(YYOrderInfoView *)orderView didClickOKButton:(UIButton *)sender
{
    YYReturnBikeRequest *request = [[YYReturnBikeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kReturnBikeAPI];
    request.rsid = orderView.rsid;
    request.lng = self.mapView.userLocation.coordinate.longitude;
    request.lat = self.mapView.userLocation.coordinate.latitude;
    request.cid = orderView.cid;
    if (orderView.error > 0) {
        request.error = orderView.error;
    }
    WEAK_REF(self);
    QMUITips *tips = [QMUITips createTipsToView:self.view];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
        [weak_self.shadeView removeFromSuperview];
        weak_self.shadeView = nil;
        
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight, kScreenWidth, 400)];
        animation.beginTime = CACurrentMediaTime();
        animation.duration = 0.5;
        [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            [orderView removeFromSuperview];
        }];
        [orderView pop_addAnimation:animation forKey:kPOPViewFrame];
        if (success) {
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
                    self.tipsView.addressLabel.text = self.models[0].name;
                    self.tipsView.hidden = NO;
                }
            }else{
                [QMUITips showError:message inView:self.view hideAfterDelay:2];
            }
            
            
        }
    } error:^(NSError *error) {
        [tips hideAnimated:YES];
    }];
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

    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight, kScreenWidth, 400)];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = 0.5;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [orderView removeFromSuperview];
    }];
    [orderView pop_addAnimation:animation forKey:kPOPViewFrame];
    
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

//购买VIP
-(void)orderInfoView:(YYOrderInfoView *)orderView didClickBuyButton:(UIButton *)sender
{
    YYBuyMemberCardViewController *memberCardViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"memberCard"];
    [self.navigationController pushViewController:memberCardViewController animated:YES];
    
    [self.shadeView removeFromSuperview];
    self.shadeView = nil;
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, kScreenHeight, kScreenWidth, 400)];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = 0.5;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [orderView removeFromSuperview];
    }];
    [orderView pop_addAnimation:animation forKey:kPOPViewFrame];
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
    YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
    orderInfoView.rsid = self.models[self.selectedId].ID;
    orderInfoView.userModel = self.userModel;
    orderInfoView.delegate = self;
    orderInfoView.siteName = self.models[self.selectedId].name;
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.models[self.selectedId].latitude,self.models[self.selectedId].longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude,self.mapView.userLocation.coordinate.longitude));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    self.tipsView.distanceLabel.text = [NSString stringWithFormat:@"%.0f",distance];
    self.tipsView.addressLabel.text = self.models[self.selectedId].name;
    self.tipsView.hidden = NO;
    orderInfoView.error = (int)distance;
    YYOrderPriceNoCheckRequest *request = [[YYOrderPriceNoCheckRequest alloc] init];
    request.rsid = self.models[self.selectedId].ID;
    request.error = (int)distance;
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderPriceWithoutCheckAPI];
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            CGFloat bottomMargin = (kScreenHeight - orderInfoView.height) * 0.5;
            orderInfoView.resultModel = [YYReturnResultModel modelWithDictionary:response];
            QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
            modalViewController.contentView = orderInfoView;
            modalViewController.contentViewMargins = UIEdgeInsetsMake(0, 0, bottomMargin, 0);
            modalViewController.maximumContentViewWidth = kScreenWidth;
            modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
            [modalViewController showWithAnimated:YES completion:nil];
            weak_self.modalPrentViewController = modalViewController;
        }
    } error:^(NSError *error) {
        
    }];

}

-(void)YYTips1View:(YYTips1View *)tipsView didClickFeedBackButton:(UIButton *)feedBackButton
{
    YYFeedBackController *feedBackViewController = [[YYFeedBackController alloc] init];
    [self.navigationController pushViewController:feedBackViewController animated:YES];
}

@end
