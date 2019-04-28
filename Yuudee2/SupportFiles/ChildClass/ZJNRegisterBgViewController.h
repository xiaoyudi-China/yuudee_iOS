//
//  ZJNRegisterBgViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/1.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  注册模块背景都一样，所以创建一个父类控制器

#import "ZJNBasicViewController.h"

@interface ZJNRegisterBgViewController : ZJNBasicViewController
//返回按钮
@property (nonatomic ,strong)UIButton *backBtn;
//右上角主页面按钮
@property (nonatomic ,strong)UIButton *homeBtn;

- (void)testFunction;
@end
