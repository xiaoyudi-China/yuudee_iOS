//
//  XLAgainVCTest.m
//  Yuudee2Tests
//
//  Created by zcy on 2019/4/29.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XLAgainVC.h"
#import "GZPModel.h"

@interface XLAgainVCTest : XCTestCase

@end

@implementation XLAgainVCTest

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
    XLAgainVC *vc = [[XLAgainVC alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainVC_mingci" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *helpTimes = [NSMutableArray array];
    NSMutableArray *trainArr = [NSMutableArray array];
    NSMutableArray *testArr = [NSMutableArray array];
    NSMutableArray *yyTestArr = [NSMutableArray array];

    for (NSDictionary * item in dict[@"nounTraining"]) {
        [trainArr addObject:[GZPModel setModelWithDic:item]];
    }
    for (NSDictionary * item in dict[@"nounTest"]) {
        [testArr addObject:[GZPModel setModelWithDic:item]];
    }
    for (NSDictionary * item in dict[@"nounSense"]) {
        [yyTestArr addObject:[GZPModel setModelWithDic:item]];
    }
    [helpTimes addObject:[NSString stringWithFormat:@"%@",dict[@"time"][@"helpTime"]]];

    vc.type = 0;
    vc.helpTime = helpTimes;
    vc.trainArr = trainArr;
    vc.testArr = testArr;
    [vc testFunction];
}

@end
