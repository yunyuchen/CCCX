//
//  YYCommonConstant.h
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/23.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCommonConstant : NSObject

//请求成功通知
UIKIT_EXTERN NSString *const kNHRequestSuccessNotification;
//登录成功通知
UIKIT_EXTERN NSString *const kLoginSuccessNotification;
//登出成功通知
UIKIT_EXTERN NSString *const kLogoutSuccessNotification;
//支付成功的通知
UIKIT_EXTERN NSString *const kPayDesSuccessNotification;
//微信支付结果的通知
UIKIT_EXTERN NSString *const kWeChatPayNotifacation;
//还车成功的通知
UIKIT_EXTERN NSString *const kReturnSuccessNotification;
//跳转导航通知
UIKIT_EXTERN NSString *const kDirectNotifaction;
//地图寻车
UIKIT_EXTERN NSString *const kClickStartButtonNotifaction;

UIKIT_EXTERN NSString *const kSelectedCouponNotification;

//高德地图API开发者ID
UIKIT_EXTERN NSString *const kAMapKey;
/** 基础URL*/
UIKIT_EXTERN NSString *const kBaseURL;
//注册, 暂时没用
UIKIT_EXTERN NSString *const kRegisterAPI;
//登录-手机号
UIKIT_EXTERN NSString *const kLoginBytelAPI;
//登录-密码
UIKIT_EXTERN NSString *const kLoginBypwdAPI;
//用户状态
UIKIT_EXTERN NSString *const kUserstateAPI;
//获取token
UIKIT_EXTERN NSString *const kGetTokenAPI;
//发送手机验证码
UIKIT_EXTERN NSString *const kSendCodeAPI;
//周边站点
UIKIT_EXTERN NSString *const kAroundSiteAPI;
UIKIT_EXTERN NSString *const kArroundBikeAPI;
//获取站点车辆信息
UIKIT_EXTERN NSString *const kGetBikeBysidAPI;
//创建押金付款订单
UIKIT_EXTERN NSString *const kCreatePayDepositAPI;
//用户认证
UIKIT_EXTERN NSString *const kUserAuthAPI;
//交易记录
UIKIT_EXTERN NSString *const kAcclogAPI;
//创建租车订单
UIKIT_EXTERN NSString *const kCreateOrderAPI;
//操作车辆
UIKIT_EXTERN NSString *const kOpratebikeAPI;
//租车信息
UIKIT_EXTERN NSString *const kOrderInfoAPI;
//还车
UIKIT_EXTERN NSString *const kReturnBikeAPI;
//创建支付订单
UIKIT_EXTERN NSString *const kCreatePayOrderAPI;
//订单金额
UIKIT_EXTERN NSString *const kOrderPriceAPI;
//申请退款
UIKIT_EXTERN NSString *const kRefundAPI;
//行程信息
UIKIT_EXTERN NSString *const kOrderListAPI;
//反馈信息
UIKIT_EXTERN NSString *const kFeedBackAPI;
//根据点获取电量最多的车辆
UIKIT_EXTERN NSString *const kGetYBikeBysidAPI;

UIKIT_EXTERN NSString *const kGetYBikeBysidAPI1;
//充值
UIKIT_EXTERN NSString *const KCreatePayBalanceAPI;
//声音寻车
UIKIT_EXTERN NSString *const kFindBikeAPI;
/** 上传头像API*/
UIKIT_EXTERN NSString *const kUploadPhotoAPI;
//调用红包API
UIKIT_EXTERN NSString *const kActCallbackAPI;
//消息API
UIKIT_EXTERN NSString *const kPushMsgAPI;
//活动列表API
UIKIT_EXTERN NSString *const kActListAPI;
//邀请明细API
UIKIT_EXTERN NSString *const kInviteInfoAPI;
//获取车辆信息API
UIKIT_EXTERN NSString *const kScanCodeAPI;
//异常还车API
UIKIT_EXTERN NSString *const kOrderPriceWithoutCheckAPI;
//卡列表
UIKIT_EXTERN NSString *const kVipListAPI;
//创建VIP卡付款订单
UIKIT_EXTERN NSString *const kCreatePayVip;
//配置信息
UIKIT_EXTERN NSString *const kAppconfigAPI;
//学生认证
UIKIT_EXTERN NSString *const kcollegeAuthAPI;
//充值金额
UIKIT_EXTERN NSString *const kPayParamsAPI;
//用户信息
UIKIT_EXTERN NSString *const kUserinfoAPI;
//我的积分
UIKIT_EXTERN NSString *const kMyPointAPI;
//我的优惠券
UIKIT_EXTERN NSString *const kMyCouponsAPI;
UIKIT_EXTERN NSString *const kGetCouponAPI;
UIKIT_EXTERN NSString *const kCompanyAuthAPI;
UIKIT_EXTERN NSString *const kFeedcfgAPI;
//预约车辆
UIKIT_EXTERN NSString *const kAppointmentAPI;
//取消预约车辆
UIKIT_EXTERN NSString *const kCancelAppointmentAPI;
//我的预约车辆
UIKIT_EXTERN NSString *const kMyAppointmentAPI;
//资讯
UIKIT_EXTERN NSString *const kInformationAPI;
//通知
UIKIT_EXTERN NSString *const kNotificationAPI;
//签到
UIKIT_EXTERN NSString *const kSignAPI;

UIKIT_EXTERN NSString *const kFindBikeAPI1;

//上报客户端信息
UIKIT_EXTERN NSString *const kClientInfoAPI;

UIKIT_EXTERN NSString *const kUseAreaAPI;
UIKIT_EXTERN NSString *const kCalendarAPI;
@end
