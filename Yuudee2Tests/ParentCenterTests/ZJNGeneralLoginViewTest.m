//
//  ZJNGeneralLoginViewTest.m
//  Yuudee2Tests
//
//  Created by Anton on 2019/4/29.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZJNGeneralLoginView.h"

@interface ZJNGeneralLoginViewTest : XCTestCase

@end

@implementation ZJNGeneralLoginViewTest

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
    ZJNGeneralLoginView *view = [[ZJNGeneralLoginView alloc]init];
    [view testFunction];
}

- (void)testFunction1{
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    ZJNGeneralLoginView *view = [[ZJNGeneralLoginView alloc]init];
    [view testGeneralLogin:1 phone:@"13661316354" psw:@"123456" success:^(id json) {
        [expectation fulfill];
        XCTAssertNotNil(json, @"json 对象不为空");
        if ([[json[@"code"] stringValue] isEqualToString:@"200"]) {
            XCTAssertTrue(YES, @"接口请求成功");
        }else{
            XCTAssertFalse(NO, @"接口请求失败");
        }
    } failure:^(NSError *error) {
        [expectation fulfill];
        XCTAssertNotNil(error, @"error 不为空");
    }];
    
    [self waitForExpectationsWithTimeout:30.f handler:^(NSError * _Nullable error) {
        NSLog(@"...");
    }];
}

@end
