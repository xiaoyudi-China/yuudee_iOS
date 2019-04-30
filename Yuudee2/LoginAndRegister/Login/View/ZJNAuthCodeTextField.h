//
//  ZJNAuthCodeTextField.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicTextField.h"

@interface ZJNAuthCodeTextField : ZJNBasicTextField
-(void)changeAuthImage;
@property (nonatomic ,copy)void (^authResult)(BOOL result);

- (void)testVerifyImageCode:(NSString *)code
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure;
@end
