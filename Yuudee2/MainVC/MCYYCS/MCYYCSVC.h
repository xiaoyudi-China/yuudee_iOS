//
//  MCCSVC.h
//  Yuudee2
//
//  Created by GZP on 2018/9/29.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  名词YYCSVC

#import "ZJNBasicViewController.h"

@interface MCYYCSVC : ZJNBasicViewController

@property(nonatomic,assign)NSInteger progressNum;
@property(nonatomic,strong)NSMutableArray * yyTestArr;

- (void)testRequestServerToken:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
- (void)testRequestServer1Token:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
@end
