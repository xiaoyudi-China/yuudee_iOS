//
//  ZJNRegisterSetPasswordViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/1.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"
#import "ZJNRequestModel.h"
@interface ZJNRegisterSetPasswordViewController : ZJNRegisterBgViewController

@property (nonatomic ,strong)ZJNRequestModel *requestModel;

- (void)testRegister:(NSString *)phoneNum disId:(NSInteger )disId psw:(NSString *)psw
             success:(void (^) (id json))success
             failure:(void (^)(NSError *error))failure;
- (void)testGeneralLogin:(NSString *)phoneNum disId:(NSInteger )disId psw:(NSString *)psw
                 success:(void (^) (id json))success
                 failure:(void (^)(NSError *error))failure;
@end
