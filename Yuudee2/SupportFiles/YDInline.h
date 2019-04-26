//
//  YDInline.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/23.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef YDInline_h
#define YDInline_h

/**
 屏幕宽

 @return 屏幕宽
 */
NS_INLINE CGFloat ScreenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}

/**
 屏幕高

 @return 屏幕高
 */
NS_INLINE CGFloat ScreenHeight() {
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 根据比率生成宽高

 @param value 转换前的值
 @return 根据比率转换后的值
 */
NS_INLINE CGFloat ScreenAdapter(CGFloat value) {
    return value * ScreenWidth() / 375;
}

/**
 根据比率确定字体大小

 @param size 转换前的字体大小
 @return 根据比率转换后的字体大小
 */
NS_INLINE UIFont *FontSize(CGFloat size) {
    return [UIFont systemFontOfSize:ScreenAdapter(size)];
}

/**
 设置字体名称和大小

 @param name 字体名称
 @param size text大小
 @return 返回后的字体大小
 */
NS_INLINE UIFont *FontName(NSString *name ,CGFloat size) {
    return [UIFont fontWithName:name size:ScreenAdapter(size)];
}

/**
 设置字体weight

 @param size 字体大小
 @param weight weight
 @return 返回Font
 */
NS_INLINE UIFont *FontWeight(CGFloat size ,UIFontWeight weight) {
    return [UIFont systemFontOfSize:ScreenAdapter(size) weight:weight];
}
/**
 判断当前设备是否是iPhoneX

 @return 判断当前设备是否是iPhoneX
 */
NS_INLINE BOOL iPhoneX() {
    // 是否是iPhone X系列
    /*
#define IS_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
    */
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *keywindow = [[UIApplication sharedApplication] delegate].window;
        CGFloat bottomSafeInset = keywindow.safeAreaInsets.bottom;
        if (bottomSafeInset>0) {
            return YES;
        }
    }
    return NO;
}

/**
 导航栏高度

 @return 导航栏高度
 */
NS_INLINE CGFloat NavHeight() {
    return iPhoneX()?88:64;
}

/**
 获取导航栏增加高度

 @return 增加的高度
 */
NS_INLINE CGFloat AddNav() {
    return iPhoneX()?24:0;
}
/**
 tabBar高度

 @return tabBar高度
 */
NS_INLINE CGFloat TabHeight() {
    return iPhoneX()?83:49;
}

/**
 rgb颜色设置

 @param red 红色
 @param green 绿色
 @param blue 蓝色
 @param alpha 透明度
 @return 颜色
 */
NS_INLINE UIColor *RGBColor(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha) {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

/**
 hex设置颜色

 @param hex 色值
 @return 返回颜色
 */
NS_INLINE UIColor *HexColor(unsigned int hex) {
    return [UIColor colorWithHex:hex];
}

/**
 设置image

 @param imageName 图片名称
 @return image
 */
NS_INLINE UIImage *SetImage(NSString *imageName) {
    return [UIImage imageNamed:imageName];
}

/**
 返回图片URL

 @param imagePath 服务器返回的地址
 @return 图片URL
 */
NS_INLINE NSURL *UrlImage(NSString *imagePath) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,imagePath]];
}

/**
 替换空字符串

 @param string 待判断字符串
 @return 返回字符串
 */
NS_INLINE NSString *SetStr(NSString *string) {
    return [NSString isEmpty:string]?@"":string;
}

/**
 系统黄色

 @return 黄色
 */
NS_INLINE CGFloat yellowColor() {
    return 0xc06d00;
}

/**
 主要字体颜色

 @return 字体颜色
 */
NS_INLINE CGFloat textColor() {
    return 0x14101e;
}


#endif /* YDInline_h */
