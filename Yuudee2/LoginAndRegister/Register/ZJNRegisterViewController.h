//
//  ZJNRegisterViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicViewController.h"

@interface ZJNRegisterViewController : ZJNBasicViewController

- (void)testPhoneIsRegister:(NSString *)phoneNum disId:(NSInteger )disId
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure;
- (void)testRegisterSendCode:(NSString *)phoneNum disId:(NSInteger )disId
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure;

@end
