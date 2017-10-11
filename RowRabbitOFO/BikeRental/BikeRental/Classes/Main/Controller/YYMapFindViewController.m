//
//  YYMapFindViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMapFindViewController.h"
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
#import "YYRentalModel.h"
#import <QMUIKit/QMUIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


static const NSInteger RoutePlanningPaddingEdge  = 20;
@interface YYMapFindViewController ()<MAMapViewDelegate,AMapSearchDelegate,AddressViewDelegate,OrderInfoViewDelegate,Tips1ViewDelegate>

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic,strong) AMapSearchAPI *search;

@property (nonatomic,strong) UIImageView *pickImageView;

@property (nonatomic,strong) NSArray<YYSiteModel *> *models;

@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

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

@property (nonatomic,strong) YYRentalModel *rentalModel;

@property (weak, nonatomic) IBOutlet QMUIButton *soundButton;

@property (weak, nonatomic) IBOutlet UIView *showView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation YYMapFindViewController

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
    
    self.navigationItem.title = @"地图寻车";
    
    [self initMap];
    

    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self requestOrderInfo];
    
    self.flag = NO;
    self.soundButton.imagePosition = QMUIButtonImagePositionTop;
    // Do any additional setup after loading the view.
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
    
    YYScrollAddressView *addressView = [[YYScrollAddressView alloc] initWithFrame:CGRectMake(0, kScreenHeight + 130, kScreenWidth, 120)];
    [self.view addSubview:addressView];
    [self.view bringSubviewToFront:addressView];
    [self.view bringSubviewToFront:self.showView];
    addressView.imgVLeft.delegate = self;
    addressView.imgVRight.delegate = self;
    addressView.imgVCenter.delegate = self;
    self.addressView = addressView;
}



-(void) requestOrderInfo
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];

    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.annotations = [NSMutableArray array];
            weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
            
            MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
            a1.coordinate = CLLocationCoordinate2DMake(weak_self.rentalModel.lat, weak_self.rentalModel.lon);
            [weak_self.annotations addObject:a1];
            if (weak_self.annotations.count > 0) {
                
                [weak_self.mapView addAnnotations:weak_self.annotations];
                
            }
            [weak_self.mapView setCenterCoordinate:a1.coordinate];
           
            
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.annotations.count > 0) {
        [self.mapView selectAnnotation:self.annotations[0] animated:YES];
    }
}


-(void) showRoute
{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    //navi.requireExtension = YES;
    //navi.strategy = 5;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude
                                           longitude:self.mapView.userLocation.coordinate.longitude];
    
    NSLog(@"11111   %f,%f",self.mapView.userLocation.coordinate.latitude,self.mapView.userLocation.coordinate.longitude);
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    NSLog(@"22222   %f,%f",self.destinationCoordinate.latitude,self.destinationCoordinate.longitude);
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
        
        if(self.rentalModel != nil){
            //1.将两个经纬度点转成投影点
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.rentalModel.lat,self.rentalModel.lon));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude));
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            self.distanceLabel.text = [NSString stringWithFormat:@"%.0f米后",distance];
        }
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
        annotationView.image = [UIImage imageNamed:@"32车辆"];
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
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

- (void)updateTotal
{
    self.totalCourse = self.route.paths.count;
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (!self.flag) {
        return;
    }
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anBasic.toValue = @(self.addressView.center.y + 260);
    anBasic.beginTime = CACurrentMediaTime();
    [anBasic setCompletionBlock:^(POPAnimation *ani,BOOL finish){
        //self.addressView.top += 200;
    }];
    [self.addressView pop_addAnimation:anBasic forKey:@"position"];
    self.flag = NO;
}

-(void)addressView:(YYAddressView *)addressView didClickReturnButton:(UIButton *)returnButton
{
    YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
    orderInfoView.rsid = self.models[self.selectedId].ID;
    orderInfoView.userModel = self.userModel;
    orderInfoView.delegate = self;
    //[orderInfoView requestOrderInfo];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = orderInfoView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
    
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
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        YYReturnBikeRequest *request = [[YYReturnBikeRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kReturnBikeAPI];
        request.rsid = orderView.rsid;
        WEAK_REF(self);
        QMUITips *tips = [QMUITips createTipsToView:self.view];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(100, 100);
        [tips showLoading];
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [tips hideAnimated:YES];
            if (success) {
                weak_self.resultModel = [YYReturnResultModel modelWithDictionary:response];
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(200, 100);
                [tips showSucceed:@"还车成功" hideAfterDelay:2];
                [YYFileCacheManager removeUserDataForkey:KBLEIDKey];
                [weak_self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                YYTips1View *tips1View = [[YYTips1View alloc] init];
                tips1View.delegate = self;
                QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
                modalViewController.contentView = tips1View;
                modalViewController.maximumContentViewWidth = kScreenWidth;
                modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
                [modalViewController showWithAnimated:YES completion:nil];
                weak_self.modalPrentViewController = modalViewController;
            }
        } error:^(NSError *error) {
            [tips hideAnimated:YES];
        }];
    }];
}

-(void)YYTips1View:(YYTips1View *)tipsView didClickCloseButton:(UIButton *)closeButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        
    }];
    
}

-(void)YYTips1View:(YYTips1View *)tipsView didClickReturnButton:(UIButton *)returnButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)gpsButtonClick:(id)sender {
     [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

- (IBAction)soundButtonClick:(id)sender {
    
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFindBikeAPI];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0.5f];//这是透明度。
        animation.autoreverses = YES;
        animation.duration = 0.5;
        animation.repeatCount = 5;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.soundButton.layer addAnimation:animation forKey:nil];
        
    } error:^(NSError *error) {
        
    }];
}


- (IBAction)contractButtonClick:(id)sender {
    
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


- (IBAction)hasFindButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kClickStartButtonNotifaction object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end

