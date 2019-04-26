//
//  ZJNPerfectInfoViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/25.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"

@interface ZJNPerfectInfoViewController : ZJNRegisterBgViewController
@property (nonatomic ,copy)NSString *pushFrom;

- (void)testAddChild:(NSString *)token userName:(NSString *)name
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure;
@end
