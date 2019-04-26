//
//  UIButton+Swizzling.h
//  classonline
//
//  Created by Miao. on 2018/1/5.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import <UIKit/UIKit.h>
//默认时间间隔
#define defaultInterval 1
@interface UIButton (Swizzling)
//点击间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
//用于设置单个按钮不需要被hook
@property (nonatomic, assign) BOOL isIgnore;
@end
