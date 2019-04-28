//
//  AppDelegate.m
//  Yuudee2
//
//  Created by 北京道口贷科技有限公司 on 2018/8/23.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  ATON

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
    
//    NSArray *array = [self getAllProperties];
//
//    NSLog(@"%@",array);
    // Override point for customization after application launch.
    return YES;
}

/* 获取对象的所有属性 */
-(NSArray *)getAllProperties
{
    u_int count;
    // 传递count的地址过去 &count
    Ivar *ivars = class_copyIvarList([UISlider class], &count);
    //arrayWithCapacity的效率稍微高那么一丢丢
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        //此刻得到的propertyName为c语言的字符串
        const char* ivarName = ivar_getName(ivars[i]);
        //此步骤把c语言的字符串转换为OC的NSString
        [propertiesArray addObject: [NSString stringWithUTF8String: ivarName]];
    }
    //class_copyPropertyList底层为C语言，所以我们一定要记得释放properties
    // You must free the array with free().
    free(ivars);
    
    return propertiesArray;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeActive" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
