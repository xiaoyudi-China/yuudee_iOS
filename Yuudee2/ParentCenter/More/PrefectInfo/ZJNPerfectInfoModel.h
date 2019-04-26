//
//  ZJNPerfectInfoModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/1.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 
 medical：0 “自闭症”, 1 “语言发育迟缓（其他正常）”, 2 “单纯性智力低下（无自闭症）”, 3 “其他诊断”, 4 “正常”,
 medicalState：0：轻 1：中 2：重 3：不清楚 （当medical为0时才传）
 firstLanguage：0:普通话 1: 方言 10：其他语言
 secondLanguage：0:普通话 1: 方言 10：其他语言
 fatherCulture与motherCulture：0：小学-:高中 1：硕士研究生 2：博士或类似
 trainingMethod：1:ABA 2:其他训练疗法 3：无训练
 
 */
@interface ZJNPerfectInfoModel : NSObject<NSCoding>

//儿童昵称
@property (nonatomic ,copy) NSString * name;
//儿童性别（0：男 1：女）
@property (nonatomic ,copy) NSString * sex;
//儿童出生日期 (yyyy-MM-dd)
@property (nonatomic ,copy) NSString * birthdate;
//医学诊断类型
@property (nonatomic ,copy) NSString * medical;
//医学诊断程度
@property (nonatomic ,copy) NSString * medicalState;
//第一语言
@property (nonatomic ,copy) NSString * firstLanguage;
//其他语言
@property (nonatomic ,copy) NSString * firstRests;
//第二语言
@property (nonatomic ,copy) NSString * secondLanguage;
//其他语言
@property (nonatomic ,copy) NSString * secondRests;
//父亲文化程度
@property (nonatomic ,copy) NSString * fatherCulture;
//母亲文化程度
@property (nonatomic ,copy) NSString * motherCulture;
//目前训练及疗法
@property (nonatomic ,copy) NSString * trainingMethod;
//其他训练疗法
@property (nonatomic ,copy) NSString * trainingRests;
//是否完善（0 否 1是）
@property (nonatomic ,copy) NSString * states;
//长期居住地
@property (nonatomic ,copy) NSString * address;
@property (nonatomic ,copy) NSString * countiyId;
@property (nonatomic ,copy) NSString * provinceId;
@property (nonatomic ,copy) NSString * cityId;
@end

NS_ASSUME_NONNULL_END
