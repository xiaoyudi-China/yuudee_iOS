//
//  ZJNUserInfoModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/30.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJNUserInfoModel : NSObject

@property (nonatomic ,copy)NSString * age;
@property (nonatomic ,copy)NSString * childId;
@property (nonatomic ,copy)NSString * city;
@property (nonatomic ,copy)NSString * createTime;
@property (nonatomic ,copy)NSString * id;
@property (nonatomic ,copy)NSString * nickname;
@property (nonatomic ,copy)NSString * password;
@property (nonatomic ,copy)NSString * phoneNumber;
@property (nonatomic ,copy)NSString * phonePrefix;
@property (nonatomic ,copy)NSString * qcellcoreId;
@property (nonatomic ,copy)NSString * sex;
@property (nonatomic ,copy)NSString * status;
@property (nonatomic ,copy)NSString * token;
@property (nonatomic ,copy)NSString * updateTime;
@property (nonatomic ,copy)NSString * photo;//头像
@property (nonatomic ,copy)NSString * childNickName;//儿童昵称
@property (nonatomic ,copy)NSString * IsRemind;//个人信息 1:未完善 2:已完善
@property (nonatomic ,copy)NSString * chilSex;//0男 1女
@property (nonatomic ,copy)NSString * chilName;//儿童昵称
@property (nonatomic ,copy)NSString * chilPhoto;//儿童头像
@end

NS_ASSUME_NONNULL_END
