//
//  ZJNRegisterFirstAlertView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNRegisterFirstAlertView : UIView
@property (nonatomic ,strong)UIButton *cancelBtn;
@property (nonatomic ,strong)UIButton *loginBtn;
@property (nonatomic ,strong)UILabel  *alertLabel;
//去登录
@property (nonatomic ,copy)void (^goToLoginBlock)(void);
@end
