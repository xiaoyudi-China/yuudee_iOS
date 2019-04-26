//
//  ZJNPhoneTextField.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicTextField.h"
#define Placeholder @" "

@interface ZJNPhoneTextField : ZJNBasicTextField


@property (nonatomic, copy)NSString *areaCode;
/** 去掉格式的电话号码 */
@property (nonatomic, copy)NSString *plainPhoneNum;
@property (nonatomic, copy)void (^phoneBlack)(BOOL isValidate);
@property (nonatomic, copy)void (^inputErrorBlock)(void);
@end
