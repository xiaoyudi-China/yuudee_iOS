//
//  DCCSVC.h
//  Yuudee2
//
//  Created by GZP on 2018/10/9.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  动词测试

#import "ZJNBasicViewController.h"

@interface DCCSVC : ZJNBasicViewController

@property(nonatomic,assign)NSInteger progressNum;
@property(nonatomic,assign)NSInteger coinNumber;

@property(nonatomic,strong)NSMutableArray * testArr;
- (void)testRequestServerToken:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
- (void)testRequestServer1Token:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
- (void)testRequestServer2Token:(NSString *)token
                        success:(void (^) (id json))success
                        failure:(void (^)(NSError *error))failure;
@end
