//
//  AppDelegate.m
//  Yuudee2
//
//  Created by 北京道口贷科技有限公司 on 2018/8/23.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  ATON ./getcov --show

#import "AppDelegate.h"
#import "XHLaunchAd.h"
#import "IQKeyboardManager.h"
#import "ZJNNavigationController.h"
#import "ZJNLoginAndRegisterViewController.h"
//#import "AppDelegate+JPush.h"
#import "AppDelegate+UShare.h"
#import <objc/runtime.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];

    [UMConfigure initWithAppkey:@"5bee6154f1f556bc9e0000e7" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    
    [self sd_Image];
    /*---------------------------------------------------------*/
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    manager.enableAutoToolbar =NO; // 控制是否显示键盘上的工具条
    /*---------------------------------------------------------*/
    //友盟分享
    [self configUShare];
    // 极光推送
//    [self configJPushWithLaunchOptions:launchOptions appKey:kJPushAppKey channel:kJPushChannel apsForProduction:NO advertisingId:nil];
    
    if ([[ZJNTool shareManager] isLogin]) {
        ZJNNavigationController *nav = [[ZJNNavigationController alloc]initWithRootViewController:[MainVC new]];
        self.window.rootViewController = nav;
        
    }else{
        ZJNLoginAndRegisterViewController *viewC = [[ZJNLoginAndRegisterViewController alloc]init];
        ZJNNavigationController *nav = [[ZJNNavigationController alloc]initWithRootViewController:viewC];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    
#warning 临时添加
#if !TARGET_IPHONE_SIMULATOR
    NSArray *PATHS = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [PATHS objectAtIndex:0];
    setenv("GCOV_PREFIX", [documentsDirectory cStringUsingEncoding:NSUTF8StringEncoding], 1);
    setenv("GCOV_PREFIX_STRIP", "13", 1);
    
#endif
    extern void __gcov_flush(void);
    __gcov_flush();
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeActive" object:nil];
}

-(void)sd_Image
{
    NSString*userAgent=@"";
    userAgent=[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)",[[[NSBundle mainBundle]infoDictionary]objectForKey:(__bridge NSString*)kCFBundleExecutableKey]?:[[[NSBundle mainBundle]infoDictionary]objectForKey:(__bridge NSString*)kCFBundleIdentifierKey],[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]?:[[[NSBundle mainBundle]infoDictionary]objectForKey:(__bridge NSString*)kCFBundleVersionKey],[[UIDevice currentDevice]model],[[UIDevice currentDevice]systemVersion],[[UIScreen mainScreen]scale]];if(userAgent){
        if(![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]){NSMutableString*mutableUserAgent=[userAgent mutableCopy];if(CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent),NULL,(__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove",false)){userAgent=mutableUserAgent;}}[[SDWebImageDownloader sharedDownloader]setValue:userAgent forHTTPHeaderField:@"User-Agent"];}
    
    [[YuudeeRequest shareManager] request:Post url:GetLoading paras:@{@"type":@"1"} completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSLog(@"启动页:%@",response[@"data"][@"image"]);
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
            imageAdconfiguration.imageNameOrURLString = response[@"data"][@"image"];
            imageAdconfiguration.duration = 4;
            imageAdconfiguration.skipButtonType = 1;
            imageAdconfiguration.imageOption = XHLaunchAdImageRefreshCached;
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        }
    }];
}

@end
