//
//  ZJNDayHistoryModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/7.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZJNStudyModel : NSObject
//
@property (nonatomic ,copy)NSString *accuracy;
//
@property (nonatomic ,copy)NSString *createTime;
//
@property (nonatomic ,copy)NSString *endTime;
//
@property (nonatomic ,copy)NSString *id;
//
@property (nonatomic ,copy)NSString *countTime;
//
@property (nonatomic ,copy)NSString *module;
//
@property (nonatomic ,copy)NSString *pass;
//
@property (nonatomic ,copy)NSString *scene;
//
@property (nonatomic ,copy)NSString *startTime;
//
@property (nonatomic ,copy)NSString *states;
//
@property (nonatomic ,copy)NSString *stayTime;
//
@property (nonatomic ,copy)NSString *trainingIdlist;
//
@property (nonatomic ,copy)NSString *updateTime;
//
@property (nonatomic ,copy)NSString *userId;
//
@property (nonatomic ,copy)NSString *valid;
@end

@interface DayListModel : NSObject
@property (nonatomic ,copy)NSString *studyTime;
@property (nonatomic ,copy)NSString *time;
@property (nonatomic ,copy)NSArray <ZJNStudyModel *>*dayResultList;

@end

@interface ZJNDayHistoryModel : NSObject
//学习时长
@property (nonatomic ,copy)NSString *countTime;
//学习进度
@property (nonatomic ,copy)NSString *schedule;
//学习记录
@property (nonatomic ,copy)NSArray <DayListModel *>*resultList;
@end

NS_ASSUME_NONNULL_END
