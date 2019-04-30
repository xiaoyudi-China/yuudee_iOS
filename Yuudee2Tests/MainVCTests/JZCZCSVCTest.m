//
//  JZCZCSVCTest.m
//  Yuudee2Tests
//
//  Created by zcy on 2019/4/28.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JZCZCSVC.h"
#import "GZPModel.h"

@interface JZCZCSVCTest : XCTestCase

@end

@implementation JZCZCSVCTest

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
    JZCZCSVC *vc = [[JZCZCSVC alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainVC_mingci" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *testArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary * item in dict[@"nounTest"]) {
        [testArr addObject:[GZPModel setModelWithDic:item]];
    }
    vc.progressNum = 0;
    vc.testArr = testArr;
    [vc testFunction];
    
}

- (void)testRequestServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    JZCZCSVC *vc = [[JZCZCSVC alloc] init];
    [vc testRequestServerToken:@"eGK5ZCXQgxeQ8n3OZxJHA==" success:^(id json) {
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

- (void)testRequestServer1 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    JZCZCSVC *vc = [[JZCZCSVC alloc] init];
    [vc testRequestServer1Token:@"eGK5ZCXQgxeQ8n3OZxJHA==" success:^(id json) {
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
