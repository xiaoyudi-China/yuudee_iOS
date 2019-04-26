//
//  ShiPei.h
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/// 手机类型
typedef enum : NSUInteger {
    
    DeviceTypeIphone5,
    
    DeviceTypeIphone6,
    
    DeviceTypeIphone6p,
    
    DeviceTypeIphoneX,
    
} DeviceType;

/**
 屏幕适配器
 */
@interface ShiPei : NSObject

/**
 设置默认机型 默认是 DeviceTypeIphone6
 */
+ (void) setDeviceType:(DeviceType)type;

+ (CGFloat) screenWidth;

+ (CGFloat) screenHeight;

/**
 屏幕比例
 */
+ (CGFloat) screenRate;

@end


/* Make a float from a. */

CG_INLINE CGFloat AdFloat(CGFloat a);

CG_INLINE CGFloat
AdFloat(CGFloat a)
{
    return a * [ShiPei screenRate];
}


