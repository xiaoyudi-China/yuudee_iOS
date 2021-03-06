//
//  GuoDuVCTest.m
//  Yuudee2Tests
//
//  Created by zcy on 2019/4/28.
//  Copyright © 2019 北京道口贷科技有限公司. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GuoDuVC.h"
#import "GZPModel.h"

@interface GuoDuVCTest : XCTestCase

@end

@implementation GuoDuVCTest

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
    GuoDuVC *vc = [[GuoDuVC alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainVC_mingci" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *testArr = [NSMutableArray array];
    NSMutableArray *yyTestArr = [NSMutableArray array];

    for (NSDictionary * item in dict[@"nounTest"]) {
        [testArr addObject:[GZPModel setModelWithDic:item]];
    }
    for (NSDictionary * item in dict[@"nounSense"]) {
        [yyTestArr addObject:[GZPModel setModelWithDic:item]];
    }
    vc.type = 0;
    vc.testArr = testArr;
    vc.yyTestArr = yyTestArr;
    [vc testFunction];
}

@end
