//
//  UILabel+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "UILabel+ZJNCategory.h"

#import <objc/runtime.h>
static const char * MG_MENUCONTROLLERKEY = "menuController";

@interface UILabel()

@property (nonatomic ,strong) UIMenuController*  menuController;

@end

@implementation UILabel (ZJNCategory)

- (void)setMenuController:(UIMenuController *)menuController{
    objc_setAssociatedObject(self, MG_MENUCONTROLLERKEY, menuController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIMenuController *)menuController{
    UIMenuController* temp = (UIMenuController*)objc_getAssociatedObject(self, MG_MENUCONTROLLERKEY);
    if (!temp) {
        UIMenuController* menuController = [[UIMenuController alloc] init];
        [menuController setTargetRect:CGRectMake(0, 0, self.frame.size.width, 20) inView:self];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction)];
        [menuController setMenuItems:@[copyItem]];
        temp = menuController;
        objc_setAssociatedObject(self, MG_MENUCONTROLLERKEY, temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return temp;
}


+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString*)title textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines{
    UILabel* item = [[UILabel alloc] initWithFrame:frame];
    item.text = title;
    item.textColor = textColor;
    item.font = font ? font : FontSize(15);
    item.textAlignment = textAlignment;
    item.numberOfLines = numberOfLines;
    return item;
}

+ (UILabel *)createLabelWithTitle:(NSString*)title textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines{
    UILabel* item = [self createLabelWithFrame:CGRectZero title:title textColor:textColor font:font textAlignment:textAlignment numberOfLines:numberOfLines];
    
    return item;
}

+(UILabel*)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines{
    return [self createLabelWithTitle:nil textColor:textColor font:font textAlignment:textAlignment numberOfLines:numberOfLines];
}

+(UILabel*)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines{
    return [self createLabelWithTitle:nil textColor:textColor font:font textAlignment:NSTextAlignmentLeft numberOfLines:numberOfLines];
}

+(UILabel*)createLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font{
    return [self createLabelWithTitle:nil textColor:textColor font:font textAlignment:NSTextAlignmentLeft numberOfLines:0];
}


#pragma mark - 重写的方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 自定义方法
-(void)addCopy{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    recognizer.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
    [self addGestureRecognizer:recognizer];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [recognizer.view becomeFirstResponder];
        [self.menuController setMenuVisible:YES animated:YES];
    }
}

-(void)copyAction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
}


@end
