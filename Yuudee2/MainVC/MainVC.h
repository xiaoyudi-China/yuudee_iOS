//
//  MainVC.h
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicViewController.h"

@interface MainVC : ZJNBasicViewController

- (void)testRequestServerToken:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;

- (void)testRequestServer1Token:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
- (void)testRequestServer2Token:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
- (void)testRequestServer3Token:(NSString *)token
                        success:(void (^) (id json))success
                        failure:(void (^)(NSError *error))failure;
- (void)testRequestServer4Token:(NSString *)token
                        success:(void (^) (id json))success
                        failure:(void (^)(NSError *error))failure;
- (void)testRequestServer5Token:(NSString *)token
                        success:(void (^) (id json))success
                        failure:(void (^)(NSError *error))failure;


@end
