//
//  AppDelegate+UShare.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/22.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "AppDelegate+UShare.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
@implementation AppDelegate (UShare)
-(void)configUShare{
    [UMConfigure initWithAppkey:@"" channel:@"App Store"];
    //当前只可访问https url，如需访问http图片请参考文档说明后设置参数：[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    [self confitUShareSettings];
    [self configUSharePlatforms];
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"" appSecret:@"" redirectURL:nil];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@""/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

@end
