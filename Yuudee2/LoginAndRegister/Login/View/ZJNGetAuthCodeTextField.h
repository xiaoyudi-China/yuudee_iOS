//
//  ZJNGetAuthCodeTextField.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicTextField.h"

@interface ZJNGetAuthCodeTextField : ZJNBasicTextField
@property (nonatomic ,strong)NSString *begin;
@property (nonatomic ,strong)NSString *timer;
@property (nonatomic ,copy)void (^getAutnCodeBlock)(void);

- (void)testFunction;
@end
