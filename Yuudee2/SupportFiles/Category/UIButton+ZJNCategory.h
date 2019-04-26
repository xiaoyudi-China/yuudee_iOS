//
//  UIButton+ZJNCategory.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchedBlock)(UIButton* sender);
@interface UIButton (ZJNCategory)
/**
 生成Button
 
 @param target target
 @param action select
 @param image 图片（背景图）
 @param highImage 高亮图片（背景图）
 @return button
 */
+ (UIButton *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

+ (UIButton *)itemWithTitle:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font target:(id)target action:(SEL)action;



//为添加埋点准备

+ (UIButton *)itemWithImage:(NSString *)image highImage:(NSString *)highImage touchedBlock:(TouchedBlock) touchedBlock;

+ (UIButton*)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font touchedBlock:(TouchedBlock) touchedBlock;

-(void)editBtn:(CGFloat)spacing;

@end
