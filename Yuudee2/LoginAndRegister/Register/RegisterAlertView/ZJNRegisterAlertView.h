//
//  ZJNRegisterAlertView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,AlertType) {
    ExistAlertType,
    SliderAlertType
};
@protocol ZJNRegisterAlertViewDelegate<NSObject>
//注册成功
-(void)zjnRegisterAlertViewVerifySuccess;
//去登录
-(void)zjnRegisterAlertViewGoToLogin;
@end
@interface ZJNRegisterAlertView : UIView
@property (nonatomic ,weak)id<ZJNRegisterAlertViewDelegate>delegate;
@property (nonatomic ,assign)AlertType alertType;
@property (nonatomic ,strong)NSString *alertStr;
@property (nonatomic ,strong)NSString *rightBtnTitle;
@end
