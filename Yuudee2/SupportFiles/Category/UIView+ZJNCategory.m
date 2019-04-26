//
//  UIView+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "UIView+ZJNCategory.h"

@implementation UIView (ZJNCategory)
- (void)setEx_x:(CGFloat)Ex_x {
    CGRect frame = self.frame;
    frame.origin.x = Ex_x;
    self.frame = frame;
}

- (void)setEx_y:(CGFloat)Ex_y {
    CGRect frame = self.frame;
    frame.origin.y = Ex_y;
    self.frame = frame;
}

- (CGFloat)Ex_x {
    return self.frame.origin.x;
}

- (CGFloat)Ex_y {
    return self.frame.origin.y;
}

- (void)setEx_centerX:(CGFloat)Ex_centerX {
    CGPoint center = self.center;
    center.x = Ex_centerX;
    self.center = center;
}

- (CGFloat)Ex_centerX {
    return self.center.x;
}

- (void)setEx_centerY:(CGFloat)Ex_centerY {
    CGPoint center = self.center;
    center.y = Ex_centerY;
    self.center = center;
}

- (CGFloat)Ex_centerY {
    return self.center.y;
}

- (void)setEx_width:(CGFloat)Ex_width {
    CGRect frame = self.frame;
    frame.size.width = Ex_width;
    self.frame = frame;
}

- (void)setEx_height:(CGFloat)Ex_height {
    CGRect frame = self.frame;
    frame.size.height = Ex_height;
    self.frame = frame;
}

- (CGFloat)Ex_height {
    return self.frame.size.height;
}

- (CGFloat)Ex_width {
    return self.frame.size.width;
}

- (void)setEx_size:(CGSize)Ex_size {
    CGRect frame = self.frame;
    frame.size = Ex_size;
    self.frame = frame;
}

- (CGSize)Ex_size {
    return self.frame.size;
}

- (void)setEx_origin:(CGPoint)Ex_origin {
    CGRect frame = self.frame;
    frame.origin = Ex_origin;
    self.frame = frame;
}

- (CGPoint)Ex_origin {
    return self.frame.origin;
}

- (CGFloat)EX_bottom {
    
    return self.frame.origin.x + self.frame.size.height;
}

- (void)setEX_bottom:(CGFloat)EX_bottom {
    
    self.EX_bottom = EX_bottom;
}

- (void)setEX_right:(CGFloat)EX_right {
    
    self.EX_right = EX_right;
}

- (CGFloat)EX_right {
    
    return self.frame.origin.y + self.frame.size.width;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}


- (CGFloat)bottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

#pragma mark - layer
- (void)rounded:(CGFloat)cornerRadius {
    [self rounded:cornerRadius width:0 color:nil];
}

- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor {
    [self rounded:0 width:borderWidth color:borderColor];
}

- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}


-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset {
    //给Cell设置阴影效果
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}


#pragma mark - base
- (UIViewController *)viewController {
    
    id nextResponder = [self nextResponder];
    while (nextResponder != nil) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            return vc;
        }
        nextResponder = [nextResponder nextResponder];
    }
    return nil;
}

+ (CGFloat)getLabelHeightByWidth:(CGFloat)width Title:(NSString *)title font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
@end
