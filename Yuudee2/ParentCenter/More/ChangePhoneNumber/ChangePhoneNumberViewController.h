//
//  ChangePhoneNumberViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"

@interface ChangePhoneNumberViewController : ZJNRegisterBgViewController
@property (nonatomic ,copy)NSString *currentPhone;

- (void)testSendCode:(NSString *)phoneNum phoneCode:(NSInteger )code
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure;

@end
