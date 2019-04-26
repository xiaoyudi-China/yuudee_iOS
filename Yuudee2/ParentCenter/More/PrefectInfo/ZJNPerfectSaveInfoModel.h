//
//  ZJNPerfectSaveInfoModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/30.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJNPerfectSaveInfoModel : NSObject<NSCoding>

//儿童昵称
@property (nonatomic ,copy) NSString * name;
//儿童性别（0：男 1：女）
@property (nonatomic ,copy) NSString * sex;
//儿童出生日期 (yyyy-MM-dd)
@property (nonatomic ,copy) NSString * birthdate;
//长期居住地
@property (nonatomic ,copy) NSString * address;
//医学诊断
@property (nonatomic ,copy) NSString * medical;
//第一语言
@property (nonatomic ,copy) NSString * firstLanguage;
//第二语言
@property (nonatomic ,copy) NSString * secondLanguage;
//父亲文化程度
@property (nonatomic ,copy) NSString * fatherCulture;
//母亲文化程度
@property (nonatomic ,copy) NSString * motherCulture;
//目前训练及疗法
@property (nonatomic ,copy) NSString * trainingMethod;

@end

NS_ASSUME_NONNULL_END
