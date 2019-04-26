//
//  AppDelegate+JPush.m
//  XlabAircraft
//
//  Created by Miao. on 2018/11/20.
//  Copyright © 2018年 Miao.Smile. All rights reserved.
//

#import "AppDelegate.h"
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (JPush)<JPUSHRegisterDelegate,UIAlertViewDelegate>
/**
 配置启动极光推送
 
 @param launchOptions 启动项
 @param appKey        一个JPush 应用必须的,唯一的标识.
 @param channel       发布渠道. 可选.
 @param isProduction  是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 @param advertisingId 广告标识符（IDFA） 如果不需要使用IDFA，传nil.
 */
- (void)configJPushWithLaunchOptions:(NSDictionary *)launchOptions
                              appKey:(NSString *)appKey
                             channel:(NSString *)channel
                    apsForProduction:(BOOL)isProduction
                       advertisingId:(NSString *)advertisingId;
@end
