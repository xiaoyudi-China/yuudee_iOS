//
//  ZJNParentCenterViewControllerTest.m
//  Yuudee2Tests
//
//  Created by Anton on 2019/4/26.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZJNParentCenterViewController.h"

@interface ZJNParentCenterViewControllerTest : XCTestCase

@end

@implementation ZJNParentCenterViewControllerTest

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
    ZJNParentCenterViewController *vc = [[ZJNParentCenterViewController alloc]init];
    [vc testFunction];
}

@end
