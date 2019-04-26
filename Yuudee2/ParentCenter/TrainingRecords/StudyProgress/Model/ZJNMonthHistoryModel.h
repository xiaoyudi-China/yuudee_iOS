//
//  ZJNMonthHistoryModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/8.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJNWeekHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MonthList : NSObject
@property (nonatomic ,copy)NSString *month;
@property (nonatomic ,copy)NSArray  <ResultListModel*>*list;
@end

@interface ZJNMonthHistoryModel : NSObject
@property (nonatomic ,copy)NSString *schedule;
@property (nonatomic ,copy)NSString *countTime;
@property (nonatomic ,copy)NSArray  <MonthList*>*resultList;
@end

NS_ASSUME_NONNULL_END
