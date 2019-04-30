//
//  QHWVC.h
//  Yuudee2
//
//  Created by GZP on 2018/10/11.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//  强化物页面

#import "ZJNBasicViewController.h"

@interface QHWVC : ZJNBasicViewController

@property(nonatomic,assign)NSInteger isPass; //是否通关进入的,1通关进入页面
@property(nonatomic,assign)NSInteger isAgainPass; //是否是再次通关

@property(nonatomic,assign)NSInteger type; //1名词,2,3,4

- (void)testRequestServerToken:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure;
@end
