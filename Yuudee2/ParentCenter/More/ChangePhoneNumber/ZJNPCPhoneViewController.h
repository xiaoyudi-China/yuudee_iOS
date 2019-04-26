//
//  ZJNPCPhoneViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"

@interface ZJNPCPhoneViewController : ZJNRegisterBgViewController

- (void)testPhoneIsRegisterPhoneNum:(NSString *)phoneNum districeId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
