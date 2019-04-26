//
//  UIColor+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "UIColor+ZJNCategory.h"

@implementation UIColor (ZJNCategory)
+ (id)colorWithHex:(unsigned int)hex {
    return [UIColor colorWithHex:hex alpha:1.0];
}

+ (id)colorWithHex:(unsigned int)hex alpha:(float)alpha {
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:alpha];
    
}
@end
