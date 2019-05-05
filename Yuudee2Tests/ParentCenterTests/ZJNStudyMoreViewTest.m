//
//  ZJNStudyMoreViewTest.m
//  Yuudee2Tests
//
//  Created by Anton on 2019/4/29.
//  Copyright © 2019 北京道口贷科技有限公司. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZJNStudyMoreView.h"

@interface ZJNStudyMoreViewTest : XCTestCase

@end

@implementation ZJNStudyMoreViewTest

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

- (void)testFunction{
    ZJNStudyMoreView *view = [[ZJNStudyMoreView alloc] initWithFrame:CGRectZero];
    ZJNStudyModel *model = [[ZJNStudyModel alloc]init];
    model.accuracy = @"2222";
    model.createTime = @"13678977700";
    model.endTime = @"18878977700";
    model.id = @"1";
    model.countTime = @"18878977700";
    model.module = @"32";
    model.pass = @"33";
    model.startTime =@"18878977700";
    model.states = @"2222";
    model.stayTime= @"18878977700";
    model.trainingIdlist = @"22";
    model.updateTime = @"18878977700";
    model.userId= @"36";
    model.valid = @"39";
    [view testFunctionWithModel:model];
}

@end
