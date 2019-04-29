//
//  ZJNStudyMonthProgressView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/21.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNParentCenterBasicView.h"
#import "ZJNDayHistoryModel.h"
#import "ZJNWeekHistoryModel.h"
#import "ZJNMonthHistoryModel.h"
typedef enum :NSInteger{
    StudyMonthProgressView,/* 月*/
    StudyWeekProgressView,/* 周*/
    StudyDayProgressView,/* 日*/
}StudyProgressViewType;
@interface ZJNStudyMonthProgressView : UIView
@property (nonatomic ,strong)ZJNDayHistoryModel *dayModel;
@property (nonatomic ,strong)ZJNWeekHistoryModel *weekModel;
@property (nonatomic ,strong)ZJNMonthHistoryModel *monthModel;
-(instancetype)initWithStudyType:(StudyProgressViewType)viewType;

- (void)testFunctionWithDayModel:(ZJNDayHistoryModel *)model;
- (void)testFunctionWithWeekModel:(ZJNWeekHistoryModel *)model;
- (void)testFunctionWithMonthModel:(ZJNMonthHistoryModel *)model;

@end
