//
//  QHWVCTest.m
//  Yuudee2Tests
//
//  Created by zcy on 2019/4/29.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QHWVC.h"

@interface QHWVCTest : XCTestCase

@end

@implementation QHWVCTest

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

- (void)testMainVC {
    QHWVC *vc = [[QHWVC alloc] init];
    vc.isPass = 1;
    vc.isAgainPass = NO;
    vc.type = 1;
    [vc testFunction];
}

@end
