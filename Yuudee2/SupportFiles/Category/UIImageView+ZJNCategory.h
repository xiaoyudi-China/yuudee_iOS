//
//  UIImageView+ZJNCategory.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ImageTouchedBlock)(UIImageView* sender ,UIGestureRecognizerState recognizerState);

@interface UIImageView (ZJNCategory)

/**
 创建
 
 @param image 图片
 @param backColor 背景色
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor;

/**
 创建(有弧度)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius;

/**
 创建(有弧度，有边框)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor*) borderColor;




/**
 创建(有手势)
 
 @param image 图片
 @param backColor 背景色
 @param imageTouchedBlock 手势方法
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock;


/**
 创建(有手势，有弧度)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @param imageTouchedBlock 手势方法
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock;


/**
 创建(有手势，有弧度，有边框)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param imageTouchedBlock 手势方法
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor*) borderColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock;

@end
