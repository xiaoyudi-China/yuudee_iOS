//
//  ZJNCPPutAuthCodeViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"

@interface ZJNCPPutAuthCodeViewController : ZJNRegisterBgViewController
@property (nonatomic ,copy)NSString *phone;
@property (nonatomic ,assign)NSInteger qcellcoreId;

- (void)testUpdatePhoneWithVerifyCode:(NSString *)verifyCode phoneNum:(NSString *)phone districeId:(NSInteger)disId
     success:(void (^) (id json))success
     failure:(void (^)(NSError *error))failure;

@end
