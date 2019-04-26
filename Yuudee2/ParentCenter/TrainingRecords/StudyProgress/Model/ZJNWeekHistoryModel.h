//
//  ZJNWeekHistoryModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/8.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TimeListModel : NSObject
@property (nonatomic ,copy)NSString *accuracy;
@property (nonatomic ,copy)NSString *countTime;
@property (nonatomic ,copy)NSString *time;
@end

@interface AccuracyListModel : NSObject
@property (nonatomic ,copy)NSString *accuracy;
@property (nonatomic ,copy)NSString *stayTime;
@property (nonatomic ,copy)NSString *time;
@end

@interface ResultListModel : NSObject
@property (nonatomic ,copy)NSArray  <AccuracyListModel *>*accuracyList;
@property (nonatomic ,copy)NSArray  <TimeListModel *>*timeList;
@property (nonatomic ,copy)NSString *weekFirstDay;
@property (nonatomic ,copy)NSString *weekLastDay;
@end

@interface ZJNWeekHistoryModel : NSObject
@property (nonatomic ,copy)NSString *countTime;
@property (nonatomic ,copy)NSString *schedule;
@property (nonatomic ,copy)NSArray  <ResultListModel *>*resultList;
@end

NS_ASSUME_NONNULL_END
