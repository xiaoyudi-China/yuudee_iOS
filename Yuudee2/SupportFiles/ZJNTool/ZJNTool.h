//
//  ZJNTool.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/30.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJNUserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZJNTool : NSObject
+(ZJNTool *)shareManager;
//userId的存取
-(NSString *)getUserId;
//token的存取
-(NSString *)getToken;
//判断登陆
-(void)loginWithModel:(ZJNUserInfoModel *)model;
-(void)logout;
-(BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
