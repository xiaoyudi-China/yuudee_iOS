//
//  ZJNForgetPasswordViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"

@interface ZJNForgetPasswordViewController : ZJNRegisterBgViewController

- (void)testUpdatePhoneIsRegister:(NSString *)phoneNum districeId:(NSInteger )code
                          success:(void (^) (id json))success
                          failure:(void (^)(NSError *error))failure;
- (void)testResetPassword:(NSString *)phoneNum code:(NSString *)code psw:(NSString *)psw
                  success:(void (^) (id json))success
                  failure:(void (^)(NSError *error))failure;
- (void)testSendCode:(NSString *)phoneNum districeId:(NSInteger )code
             success:(void (^) (id json))success
             failure:(void (^)(NSError *error))failure;

@end
