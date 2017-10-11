//
//  YYRemoteReturnViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYRemoteReturnViewController.h"
#import "YYRemoteViewCell.h"
#import "YYAroundSiteRequest.h"
#import "YYReturnBikeRequest.h"
#import "YYSiteModel.h"
#import "YYReturnResultModel.h"
#import "YYOrderInfoView.h"
#import "YYReturnBikeViewController.h"
#import <MapKit/MapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <QMUIKit/QMUIKit.h>

@interface YYRemoteReturnViewController ()<UITableViewDataSource,UITabBarDelegate,RemoteViewCellDelegate,OrderInfoViewDelegate>

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;

@property(nonatomic,strong) AMapLocationManager *locationManager;

@property (nonatomic,strong) NSArray<YYSiteModel *> *models;

@property (nonatomic,strong) YYReturnResultModel *returnResultModel;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) YYSiteModel *selectedModel;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@end

@implementation YYRemoteReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //  定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
 
    [self showEmptyViewWithLoading];
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        [self hideEmptyView];
        NSLog(@"location:%@", location);
        YYAroundSiteRequest *request = [[YYAroundSiteRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAroundSiteAPI];
        request.lat = location.coordinate.latitude;
        request.lng = location.coordinate.longitude;
        
        WEAK_REF(self);
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                weak_self.models = [YYSiteModel modelArrayWithDictArray:response];
             
                [weak_self.tableView reloadData];
                
            }
        } error:^(NSError *error) {
            
        }];
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYRemoteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remoteViewCell"];
    cell.delegate = self;
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)RemoteViewCell:(YYRemoteViewCell *)cell didClickReturnButton:(UIButton *)returnButton
{
    YYOrderInfoView *contentView = [[YYOrderInfoView alloc] init];
    contentView.delegate = self;
    contentView.rsid =  cell.model.ID == 0 ? cell.model.ID : cell.model.ID;
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    //[contentView requestOrderInfo];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.maximumContentViewWidth = kScreenWidth - 20;
    modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
    self.index = contentView.rsid;
    self.selectedModel = cell.model;
}

-(void)orderInfoView:(YYOrderInfoView *)orderView didClickOKButton:(UIButton *)sender
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        YYReturnBikeRequest *request = [[YYReturnBikeRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kReturnBikeAPI];
        request.rsid = self.index;
        WEAK_REF(self);
        QMUITips *tips = [QMUITips createTipsToView:self.view];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(100, 100);
        [tips showLoading];
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [tips hideAnimated:YES];
            if (success) {
                weak_self.returnResultModel = [YYReturnResultModel modelWithDictionary:response];
                if ((weak_self.returnResultModel.price + weak_self.returnResultModel.extPrice) <= 0) {
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

-(void)orderInfoView:(YYOrderInfoView *)orderView didClickNaviButton:(UIButton *)sender
{
    CLLocationCoordinate2D to = CLLocationCoordinate2DMake(self.selectedModel.latitude, self.selectedModel.longitude);
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    
    toLocation.name = @"还车点";
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    YYReturnBikeViewController *returnBikeViewController = (YYReturnBikeViewController *)[segue destinationViewController];
    if (self.returnResultModel != nil) {
        returnBikeViewController.price = self.returnResultModel.price;
        returnBikeViewController.keep = self.returnResultModel.keep;
        returnBikeViewController.extprice = self.returnResultModel.extPrice;
    }else{
        returnBikeViewController.price = self.model.price;
        returnBikeViewController.keep = self.model.keep;
        returnBikeViewController.extprice = 0;
    }
}


@end
