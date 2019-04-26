//
//  ZJNCPGetAuthCodeViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"

@interface ZJNCPGetAuthCodeViewController : ZJNRegisterBgViewController
@property (nonatomic ,copy)NSString *phone;
@property (nonatomic ,assign)NSInteger phoneCode;
@property (nonatomic ,copy)NSString *areaCode;

- (void)testEfficacyPhoneNum:(NSString *)phoneNum phoneCode:(NSString *)code districeId:(NSInteger)disId
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure;
@end
