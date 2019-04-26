//
//  UIViewController+HUD.h
//  XuanMiLaywer
//
//  Created by MAC on 14-9-23.
//  Copyright (c) 2014年 许鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)
-(void)showHudInView:(UIView *)view hint:(NSString *)hint;

-(void)hideHud;

-(void)showHint:(NSString *)hint inView:(UIView *)view;
-(void)showProgressImageViewInView:(UIView *)view;
-(void)showHint:(NSString *)hint;

-(void)showHint:(NSString *)hint yOffset:(float)yOffset;

// 没有数据的时时候显示
-(void)ShowNoDataViewWithStr:(NSString *) ShowStr yOffset:(float)yOffset;
-(void) hintNodataView;
//需要有黑色半透明背景的调用此方法
-(void)showBlackView;
-(void)hideBlackView;
@end
