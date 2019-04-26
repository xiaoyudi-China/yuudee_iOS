//
//  UIButton+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "UIButton+ZJNCategory.h"
#import <objc/runtime.h>

static const void *ButtonBlockKey = &ButtonBlockKey;
@implementation UIButton (ZJNCategory)
+ (UIButton *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target != nil) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    return btn;
}



+ (UIButton *)itemWithTitle:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target != nil) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    return btn;
}

+(UIButton*)itemWithImage:(NSString *)image highImage:(NSString *)highImage touchedBlock:(TouchedBlock)touchedBlock
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(btn, ButtonBlockKey, touchedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:btn action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(UIButton*)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font touchedBlock:(TouchedBlock)touchedBlock
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(btn, ButtonBlockKey, touchedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [btn addTarget:btn action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    return btn;
}

-(void)actionClicked:(UIButton*)sender
{
    
    TouchedBlock block = objc_getAssociatedObject(self, ButtonBlockKey);
    if (block) {
        sender.userInteractionEnabled = NO;
        block(sender);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = YES;
        });
    }
}

-(void)editBtn:(CGFloat)spacing{
    // button标题的偏移量
    CGFloat avg = spacing / 2;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.width - avg, 0, self.imageView.width + avg);
    // button图片的偏移量
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.width + avg, 0, -self.titleLabel.width - avg);
}

@end
