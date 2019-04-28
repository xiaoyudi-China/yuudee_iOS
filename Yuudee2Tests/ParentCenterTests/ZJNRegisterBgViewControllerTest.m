//
//  ZJNRegisterBgViewControllerTest.m
//  Yuudee2Tests
//
//  Created by Anton on 2019/4/28.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZJNRegisterBgViewController.h"

@interface ZJNRegisterBgViewControllerTest : XCTestCase

@end

@implementation ZJNRegisterBgViewControllerTest

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
    ZJNRegisterBgViewController *vc = [[ZJNRegisterBgViewController alloc]init];
    [vc testFunction];
}

@end
