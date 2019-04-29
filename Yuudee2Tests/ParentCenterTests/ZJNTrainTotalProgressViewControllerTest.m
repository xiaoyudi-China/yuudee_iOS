//
//  ZJNTrainTotalProgressViewControllerTest.m
//  Yuudee2Tests
//
//  Created by Anton on 2019/4/26.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZJNTrainTotalProgressViewController.h"

@interface ZJNTrainTotalProgressViewControllerTest : XCTestCase

@end

@implementation ZJNTrainTotalProgressViewControllerTest

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
    ZJNTotalModel *lastModel = [[ZJNTotalModel alloc]init];
    lastModel.id = @"22";
    lastModel.rate_all = @"33";
    lastModel.learning_time = @"44";
    lastModel.score = @"100";
    ZJNTrainTotalProgressViewController *vc = [[ZJNTrainTotalProgressViewController alloc]initWithModelArray:@[lastModel,lastModel,lastModel] progress:1];
    [vc testFunction];
}

@end
