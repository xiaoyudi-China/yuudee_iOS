//
//  ZJNAreaPhoneTextField.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/11.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Placeholder @" "
@interface ZJNAreaPhoneTextField : UITextField
@property (nonatomic ,strong)UIButton *leftButton;
@property (nonatomic, copy)NSString *areaCode;
/** 去掉格式的电话号码 */
@property (nonatomic, strong) NSString *plainPhoneNum;
@property (nonatomic, copy)void (^phoneBlack)(BOOL isValidate);
@property (nonatomic, copy)void (^areaBtnClickBlock)(void);
@end
