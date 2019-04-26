//
//  ZJNFMDBManager.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/30.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJNUserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZJNFMDBManager : NSObject

+(ZJNFMDBManager *)shareManager;

/*————————————————————个人信息相关————————————————————*/
/* 增**/
-(void)addCurrentUserInfoWithModel:(ZJNUserInfoModel *)infoModel;
/* 删**/
-(void)deleteCurrentUserInfoWithUserId:(NSString *)userId;
/* 改**/
-(void)updateCurrentUserInfoWithModel:(ZJNUserInfoModel *)infoModel;
/* 查**/
-(ZJNUserInfoModel *)searchCurrentUserInfoWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
