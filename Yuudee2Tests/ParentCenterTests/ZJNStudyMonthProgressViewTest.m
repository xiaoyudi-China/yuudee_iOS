//
//  ZJNStudyMonthProgressViewTest.m
//  Yuudee2Tests
//
//  Created by Anton on 2019/4/29.
//  Copyright © 2019 北京道口贷科技有限公司. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZJNStudyMonthProgressView.h"

@interface ZJNStudyMonthProgressViewTest : XCTestCase

@end

@implementation ZJNStudyMonthProgressViewTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDayFunction{
    ZJNStudyMonthProgressView *view = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyDayProgressView];
    ZJNDayHistoryModel *dayModel = [[ZJNDayHistoryModel alloc]init];
    dayModel.countTime = @"58";
    dayModel.schedule = @"1";
    DayListModel *listModel = [[DayListModel alloc]init];
    listModel.studyTime = @"12";
    listModel.time = @"1556261005000";
    listModel.dayResultList = @[];
    dayModel.resultList = @[listModel,listModel,listModel,listModel];
    [view testFunctionWithDayModel:dayModel];
}

- (void)testWeekFunction{
    ZJNStudyMonthProgressView *view = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyWeekProgressView];
    ZJNWeekHistoryModel *weekModel = [[ZJNWeekHistoryModel alloc]init];
    weekModel.countTime = @"3299";
    weekModel.schedule = @"1";
    ResultListModel *listModel = [[ResultListModel alloc]init];
    TimeListModel *timeModel = [[TimeListModel alloc]init];
    timeModel.accuracy = @"0";
    timeModel.countTime = @"12";
    timeModel.time = @"019-04-26";
    listModel.timeList = @[timeModel,timeModel,timeModel,timeModel];
    listModel.weekFirstDay = @"1555862400000";
    listModel.weekLastDay = @"1556380800000";
    weekModel.resultList = @[listModel,listModel,listModel,listModel];
    [view testFunctionWithWeekModel:weekModel];
}

- (void)testMonthFunction{
    ZJNStudyMonthProgressView *view = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyMonthProgressView];
    ZJNMonthHistoryModel *model = [[ZJNMonthHistoryModel alloc]init];
    model.countTime = @"7489";
    model.schedule = @"1";
    
    
    ResultListModel *model01 = [[ResultListModel alloc]init];
    model01.weekFirstDay = @"2019-04-29 00:00:00";
    model01.weekLastDay = @"2019-05-01 00:00:00";
    
    AccuracyListModel *model02 = [[AccuracyListModel alloc]init];
    model02.accuracy = @"0.825";
    model02.stayTime = @"739";
    model02.time = @"2019-03-18";
    
    TimeListModel *model03 = [[TimeListModel alloc]init];
    model03.accuracy = @"0.755172";
    model03.countTime = @"4172";
    model03.time = @"2019-03-08";
    
    model01.accuracyList = @[model02];
    model01.timeList = @[model03];
    
    MonthList *list01 = [[MonthList alloc]init];
    list01.month = @"4";
    list01.list = @[model01];

    model.resultList = @[list01];
    
    [view testFunctionWithMonthModel:model];
}

@end
