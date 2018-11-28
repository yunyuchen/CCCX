//
//  YYCommonConstant.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/23.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "YYCommonConstant.h"

@implementation YYCommonConstant

NSString *const kNHRequestSuccessNotification = @"kNHRequestSuccessNotification";

NSString *const kLoginSuccessNotification = @"kLoginSuccessNotification";

NSString *const kLogoutSuccessNotification = @"kLogoutSuccessNotification";

NSString *const kPayDesSuccessNotification = @"PayDesSuccessNotification";

NSString *const kWeChatPayNotifacation = @"WeChatPayNotifacation";

NSString *const kReturnSuccessNotification = @"ReturnSuccessNotification";

NSString *const kDirectNotifaction = @"DirectNotifaction";

NSString *const kClickStartButtonNotifaction = @"ClickStartButtonNotifaction";

NSString *const kSelectedCouponNotification = @"SelectedCouponNotification";

NSString *const kAMapKey = @"76ca483fa2be9f4f6a3f81c55831ff7c";

NSString *const kBaseURL = @"http://api.cccx.ltd/";

NSString *const kRegisterAPI = @"get?module=UserService.register";

NSString *const kLoginBytelAPI = @"open/get?module=UserService.loginBytel";

NSString *const kLoginBypwdAPI = @"open/get?module=UserService.loginBypwd";

NSString *const kUserstateAPI = @"get?module=UserService.userstate";

NSString *const kGetTokenAPI = @"open/get?module=CodeService.getToken";

NSString *const kSendCodeAPI = @"open/get?module=CodeService.sendCodeByToken";

NSString *const kAroundSiteAPI = @"open/get?module=SiteService.arroundSite";
NSString *const kArroundBikeAPI = @"open/get?module=SiteService.arroundBike";

NSString *const kGetBikeBysidAPI = @"open/get?module=BikeService.getBikeBysid";

NSString *const kCreatePayDepositAPI = @"get?module=PayService.createPayDeposit";

NSString *const kUserAuthAPI = @"get?module=UserService.userauth";

NSString *const kAcclogAPI = @"get?module=UserService.acclog";

NSString *const kCreateOrderAPI = @"get?module=BikeService.createOrder";

NSString *const kOpratebikeAPI = @"get?module=BikeService.opratebike";

NSString *const kOrderInfoAPI = @"get?module=BikeService.orderInfo";

NSString *const kReturnBikeAPI = @"get?module=BikeService.returnBike";

NSString *const kCreatePayOrderAPI = @"get?module=PayService.createPayOrder";

NSString *const kOrderPriceAPI = @"get?module=BikeService.orderPrice";

NSString *const kRefundAPI = @"get?module=UserService.refund";

NSString *const kOrderListAPI = @"get?module=BikeService.orderList";

NSString *const kFeedBackAPI = @"get?module=UserService.feedback";

NSString *const kGetYBikeBysidAPI = @"open/get?module=BikeService.getYBikeByLat";

NSString *const kGetYBikeBysidAPI1 = @"open/get?module=BikeService.getYBikeBysid";

NSString *const KCreatePayBalanceAPI = @"get?module=PayService.createPayBalance";

NSString *const kFindBikeAPI = @"get?module=BikeService.findbike";

NSString *const kUploadPhotoAPI = @"upload";

NSString *const kActCallbackAPI = @"get?module=UserService.shareActCallback";

NSString *const kPushMsgAPI = @"get?module=UserService.pushmsg";

NSString *const kActListAPI = @"open/get?module=UserService.actlist";

NSString *const kInviteInfoAPI = @"get?module=UserService.inviteinfo";

NSString *const kScanCodeAPI = @"get?module=BikeService.scanCode";

NSString *const kOrderPriceWithoutCheckAPI = @"get?module=BikeService.orderPriceWithoutCheck";

NSString *const kVipListAPI = @"open/get?module=UserService.vipList";

NSString *const kCreatePayVip = @"get?module=PayService.createPayVip";

NSString *const kAppconfigAPI = @"open/get?module=UserService.appconfig";

NSString *const kcollegeAuthAPI = @"get?module=UserService.collegeAuth";

NSString *const kPayParamsAPI = @"get?module=PayService.payParams";

NSString *const kUserinfoAPI = @"get?module=UserService.userinfo";

NSString *const kMyPointAPI = @"get?module=UserService.myPoint";

NSString *const kMyCouponsAPI = @"get?module=UserService.myCoupon";

NSString *const kGetCouponAPI = @"get?module=UserService.getCoupon";

NSString *const kCompanyAuthAPI = @"get?module=UserService.companyAuth";

NSString *const kFeedcfgAPI = @"get?module=UserService.feedcfg";

NSString *const kAppointmentAPI = @"get?module=BikeService.addAppointment";

NSString *const kMyAppointmentAPI = @"get?module=BikeService.myAppointment";

NSString *const kCancelAppointmentAPI = @"get?module=BikeService.cancelAppointment";
@end
