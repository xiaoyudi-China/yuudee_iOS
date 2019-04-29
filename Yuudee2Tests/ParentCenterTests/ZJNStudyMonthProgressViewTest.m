//
//  ZJNStudyMonthProgressViewTest.m
//  Yuudee2Tests
//
//  Created by Anton on 2019/4/29.
//  Copyright © 2019 险峰科技. All rights reserved.
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
    dayModel.countTime = @"7489";
    dayModel.schedule = @"1";
    DayListModel *listModel = [[DayListModel alloc]init];
    listModel.studyTime = @"12";
    listModel.time = @"1556261005000";
    listModel.dayResultList = @[];
    dayModel.resultList = @[listModel];
    [view testFunctionWithDayModel:dayModel];
}

- (void)testWeekFunction{
    ZJNStudyMonthProgressView *view = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyWeekProgressView];
    ZJNWeekHistoryModel *weekModel = [[ZJNWeekHistoryModel alloc]init];
    weekModel.countTime = @"7489";
    weekModel.schedule = @"1";
    ResultListModel *listModel = [[ResultListModel alloc]init];
    TimeListModel *timeModel = [[TimeListModel alloc]init];
    timeModel.accuracy = @"0";
    timeModel.countTime = @"12";
    timeModel.time = @"019-04-26";
    listModel.timeList = @[timeModel];
    listModel.weekFirstDay = @"1555862400000";
    listModel.weekLastDay = @"1556380800000";
    weekModel.resultList = @[listModel];
    [view testFunctionWithWeekModel:weekModel];
}

- (void)testMonthFunction{
    ZJNStudyMonthProgressView *view = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyDayProgressView];
    ZJNMonthHistoryModel *model = [[ZJNMonthHistoryModel alloc]init];
    model.countTime = @"7489";
    model.schedule = @"1";
    model.resultList = @[];
    [view testFunctionWithMonthModel:model];
}


@end
