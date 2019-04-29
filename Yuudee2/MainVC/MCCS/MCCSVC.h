//
//  MCCSVC.h
//  Yuudee2
//
//  Created by GZP on 2018/10/8.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  名词测试

#import "ZJNBasicViewController.h"

@interface MCCSVC : ZJNBasicViewController

@property(nonatomic,assign)NSInteger progressNum;

@property(nonatomic,strong)NSMutableArray * testArr;

@property(nonatomic,assign)NSInteger coinNumber; //UI显示的金币数量
- (void)testRequestServerToken:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
@end
