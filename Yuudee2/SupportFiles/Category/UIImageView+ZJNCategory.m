//
//  UIImageView+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "UIImageView+ZJNCategory.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <objc/runtime.h>
static const void *ImageBlockKey = &ImageBlockKey;
@implementation UIImageView (ZJNCategory)
+(UIImageView*)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = backColor?backColor:[UIColor clearColor];
    imageView.clipsToBounds = YES;
    return imageView;
}

+(UIImageView*)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor Radius:(CGFloat)radius
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor];
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:radius];
    return imageView;
}

+(UIImageView*)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor Radius:radius];
    [imageView.layer setBorderWidth:borderWidth];
    [imageView.layer setBorderColor:borderColor.CGColor];
    return imageView;
}

+ (UIImageView *)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor];
    
    objc_setAssociatedObject(imageView, ImageBlockKey, imageTouchedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (imageTouchedBlock) {
        imageView.userInteractionEnabled = YES;
        //创建手势对象
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:imageView action:@selector(tapAction:)];
        //轻拍次数
        tap.numberOfTapsRequired =1;
        //轻拍手指个数
        tap.numberOfTouchesRequired =1;
        //讲手势添加到指定的视图上
        [imageView addGestureRecognizer:tap];
    }
    
    return imageView;
}

+ (UIImageView *)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor Radius:(CGFloat)radius imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor imageTouchedBlock:imageTouchedBlock];
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:radius];
    return imageView;
}

+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor*) borderColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor Radius:radius imageTouchedBlock:imageTouchedBlock];
    [imageView.layer setBorderWidth:borderWidth];
    [imageView.layer setBorderColor:borderColor.CGColor];
    return imageView;
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    ImageTouchedBlock block = objc_getAssociatedObject(self, ImageBlockKey);
    if (block) {
        block(self,tap.state);
    }
}

@end
