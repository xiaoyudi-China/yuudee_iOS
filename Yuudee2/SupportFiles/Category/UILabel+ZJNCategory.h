//
//  UILabel+ZJNCategory.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZJNCategory)
/**
 实例化
 
 @param title text
 @param textColor 字体颜色
 @param font 字体
 @param textAlignment Alignment
 @param numberOfLines 行数
 @return UILabel
 */
+(UILabel *)createLabelWithTitle:(NSString*)title textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines;

/**
 实例化
 
 @param textColor 字体颜色
 @param font 字体
 @param textAlignment Alignment
 @param numberOfLines 行数
 @return UILabel
 */
+(UILabel*)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines;

/**
 实例化
 
 @param textColor 字体颜色
 @param font 字体
 @param numberOfLines 行数
 @return UILabel
 */
+(UILabel*)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines;

/**
 实例化
 
 @param textColor 字体颜色
 @param font 字体
 @return UILabel
 */
+(UILabel*)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font;

/**
 添加复制方法
 */
-(void)addCopy;
@end
