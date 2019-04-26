//
//  AppDelegate+JPush.m
//  XlabAircraft
//
//  Created by Miao. on 2018/11/20.
//  Copyright © 2018年 Miao.Smile. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "ZJNParentCenterViewController.h"
#import "MainVC.h"
#import "ZJNMainAssessmentReviewController.h"
@implementation AppDelegate (JPush)

- (void)configJPushWithLaunchOptions:(NSDictionary *)launchOptions appKey:(NSString *)appKey channel:(NSString *)channel apsForProduction:(BOOL)isProduction advertisingId:(NSString *)advertisingId
{
    // 极光3.0.0及以后版本注册
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];

    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:kJpushRegistrationID];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);

    NSDictionary *apsDic = userInfo[@"aps"];

    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {

        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {  //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"推送消息" message:apsDic[@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"alertUserInfo"];
                [self disposeOfJumpWithUserInfo:userInfo];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alertUserInfo"];
            }]];
            
            [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
        }
        [self disposeOfJumpWithUserInfo:userInfo]; //后台收到推送

    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//收到的推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)){

    NSDictionary * userInfo = notification.request.content.userInfo;

    // 收到推送的请求
    UNNotificationRequest *request = notification.request;
    //     收到推送的消息内容
    UNNotificationContent *content = request.content;
    // 推送消息的角标
    NSNumber *badge = content.badge;
    // 推送消息体
    NSString *body = content.body;
    // 推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    completionHandler(UNNotificationPresentationOptionAlert);
}

//推送的点击事件
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    // 收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    // 收到推送的消息内容
    UNNotificationContent *content = request.content;
    // 推送消息的角标
    NSNumber *badge = content.badge;
    // 推送消息体
    NSString *body = content.body;
    // 推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);

        [self disposeOfJumpWithUserInfo:userInfo];
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }

    completionHandler();  // 系统要求执行这个方法
}
#endif
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =[NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}
//APP进入前台时把角标设置为0
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];//APP进入前台时把角标设置为0
    [JPUSHService resetBadge];  //极光所记录角标设置为0
    [application cancelAllLocalNotifications];//取消所有的本地通知
}

#pragma mark - 处理逻辑跳转
- (void)disposeOfJumpWithUserInfo:(NSDictionary *)userInfo
{
    UIViewController *rootViewController = [self getCurrentVC];
    ZJNMainAssessmentReviewController *viewC = [[ZJNMainAssessmentReviewController alloc]init];
    [rootViewController.navigationController pushViewController:viewC animated:YES];
//    if ([rootViewController isKindOfClass:[ZJNParentCenterViewController class]]) {
//
//    }else{
//        NSLog(@"训练页面");
//        ZJNParentCenterViewController *viewC = [[ZJNParentCenterViewController alloc]init];
//        viewC.pushType = FromHomePage;
//        [rootViewController.navigationController pushViewController:viewC animated:YES];
//    }

}
// 获取当前屏幕显示的viewcontroller
-(UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

// 获取根视图
-(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController])
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    
    if ([rootVC isKindOfClass:[UITabBarController class]])
    {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }
    else
    {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1 && alertView.tag == 9876) {
//        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"alertUserInfo"];
//        [self disposeOfJumpWithUserInfo:userInfo];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alertUserInfo"];
//
//    }
//}

@end
