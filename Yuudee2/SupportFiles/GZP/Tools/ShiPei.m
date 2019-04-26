//
//  ShiPei.m
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ShiPei.h"

// 默认机型
static DeviceType deviceType = DeviceTypeIphone6;

@implementation ShiPei

+ (void) setDeviceType:(DeviceType)type {
    
    deviceType = type;
}

+ (CGFloat) screenWidth {
    
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat) screenHeight {
    
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 屏幕比例
 */
+ (CGFloat) screenRate {
    
    CGFloat height = 0.0;
    
    CGFloat width = 0.0;
    
    switch (deviceType) {// 默认是按竖屏获取
            
        case DeviceTypeIphone5:
        {
            height = 568.0 * 2;
            
            width = 320.0 * 2;
            
        }
            break;
            
        case DeviceTypeIphone6:
        {
            height = 667.0 * 2;
            
            width = 375.0 * 2;
            
        }
            break;
            
        case DeviceTypeIphone6p:
        {
            height = 736.0 * 2;
            
            width = 414.0 * 2;
            
        }
            break;
            
        case DeviceTypeIphoneX:
        {
            height = 812.0 * 2;
            
            width = 375.0 * 2;
            
        }
            break;
    }
    
    return [self rateWithWidth:width height:height];
}

/**
 根据屏幕方向获取比例
 
 @param width 需要修改的宽度
 @param height 需要修改的高度
 @return 比例
 */

+ (CGFloat) rateWithWidth:(CGFloat)width height:(CGFloat)height {
    
    CGFloat rate = 0.5;
    
    CGFloat screen_width = MIN([self screenWidth], [self screenHeight]);
    
    CGFloat screen_height = MAX([self screenWidth], [self screenHeight]);
    
    CGFloat rate_width = screen_width / width;
    
    CGFloat rate_height = screen_height / height;
    
    if (screen_width * 2 > width) { // 放大
        
        rate = MIN(rate_width, rate_height);
        
    } else if (screen_width * 2 < width) { // 缩小
        
        rate = MAX(rate_width, rate_height);
    }
    
    return rate;
}

@end

