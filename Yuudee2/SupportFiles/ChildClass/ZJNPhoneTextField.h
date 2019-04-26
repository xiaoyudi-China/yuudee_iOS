//
//  ZJNPhoneTextField.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 险峰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Placeholder @" "
@interface ZJNPhoneTextField : UITextField
/** 去掉格式的电话号码 */
@property (nonatomic, strong) NSString *plainPhoneNum;

@property (nonatomic, copy)void (^phoneBlack)(BOOL isValidate);
@end
