//
//  ZJNRegisterVerifyCodeViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"
#import "ZJNRequestModel.h"
@interface ZJNRegisterVerifyCodeViewController : ZJNRegisterBgViewController

@property (nonatomic ,strong)ZJNRequestModel *requestModel;

- (void)testRegisterSendCode:(NSString *)phoneNum disId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (void)testRegisterCodeverify:(NSString *)phoneNum disId:(NSInteger)disId verifyCode:(NSString *)code success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
