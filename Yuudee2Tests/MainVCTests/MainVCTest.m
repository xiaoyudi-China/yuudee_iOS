//
//  MainVCTest.m
//  Yuudee2Tests
//
//  Created by zcy on 2019/4/28.
//  Copyright © 2019 险峰科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MainVC.h"

@interface MainVCTest : XCTestCase

@end

@implementation MainVCTest

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
    MainVC *vc = [[MainVC alloc] init];
    [vc testFunction];
    
}

- (void)testRequestServer {
//    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
//    MainVC *vc = [[MainVC alloc] init];
//    [vc testRequestServerToken:@"eGK5ZCXQgxeQ8n3OZxJHA==" success:^(id json) {
//        [expectation fulfill];
//        XCTAssertNotNil(json, @"json 对象不为空");
//        if ([[json[@"code"] stringValue] isEqualToString:@"200"]) {
//            XCTAssertTrue(YES, @"接口请求成功");
//        }else{
//            XCTAssertFalse(NO, @"接口请求失败");
//        }
//    } failure:^(NSError *error) {
//        [expectation fulfill];
//        XCTAssertNotNil(error, @"error 不为空");
//    }];
//
//    [self waitForExpectationsWithTimeout:30.f handler:^(NSError * _Nullable error) {
//        NSLog(@"...");
//    }];
}

@end

/*
 MCTrainArr response[@"nounTraining"]
 [self.MCTrainArr addObject:[GZPModel setModelWithDic:item]];

 <__NSArrayI 0x280751f80>(
 {
 colorPenChar = "\U767d";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/fbac6d62ea71ff4255078ee0b3d02662.mp3";
 createTime = 1552443306000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/50b9cf4edc9df0a4995cfc90f63c5b47.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/69281f4682ceaba2bfdf6e1465eb48bc.mp3";
 groupWord = "\U767d\U5154";
 id = 19;
 states = 1;
 updateTime = 1552443306000;
 wireChar = "\U5154";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/3cba640abd6aabddab15340e70e30a86.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/af944df0e3d129eacfb0b2ec821b158c.mp3";
 },
 {
 colorPenChar = "\U9ec4";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/1c2434fe5ff0f32d3d3a9aac088a0b59.mp3";
 createTime = 1552444007000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/5eef48d000641c84b41f30e3034174b1.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/8ec9de0d5502ecb96dfa96076d8c1254.mp3";
 groupWord = "\U9ec4\U5154";
 id = 20;
 states = 1;
 updateTime = 1552444008000;
 wireChar = "\U5154";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/3cba640abd6aabddab15340e70e30a86.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/af944df0e3d129eacfb0b2ec821b158c.mp3";
 },
 {
 colorPenChar = "\U9ec4";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/1c2434fe5ff0f32d3d3a9aac088a0b59.mp3";
 createTime = 1552443306000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/0805fcb974b009682dedb96bef9f22bc.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/d21a48d4344597cc586323bd5acbe298.mp3";
 groupWord = "\U9ec4\U72d7";
 id = 7;
 states = 1;
 updateTime = 1552443306000;
 wireChar = "\U72d7";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/20e8418a4b5af86ca8604915274f619c.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/7156c916008fcc759ace714372f6b5aa.mp3";
 },
 {
 colorPenChar = "\U7ea2";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/8bb69b1e857f4bc9ee10375f54d8f456.mp3";
 createTime = 1552444883000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/c7263990e2293a0de3c3aad028f18cbd.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/474254e3faa43aeed6156ae1e2e686e2.mp3";
 groupWord = "\U7ea2\U6c7d\U8f66";
 id = 46;
 states = 1;
 updateTime = 1552444883000;
 wireChar = "\U6c7d\U8f66";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/b6cbd99d7e80b846e5cb5095b01e6ec9.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/53a5f7ab65097961299bd564420c6d32.mp3";
 },
 {
 colorPenChar = "\U767d";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/fbac6d62ea71ff4255078ee0b3d02662.mp3";
 createTime = 1553775955000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/dae357d49aa29668dc82129d4e175d29.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/6f78c0d71ec5fe6911a9ba2ca4167dfd.mp3";
 groupWord = "\U767d\U9e1f";
 id = 10;
 states = 1;
 updateTime = 1553775955000;
 wireChar = "\U9e1f";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/29eb65fbfd883a7a767e38302448fd68.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/96eac3c67022bb62132a18c5683b21bb.mp3";
 },
 {
 colorPenChar = "\U84dd";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/a9ef9e501cd3f938a07adc3a898e081f.mp3";
 createTime = 1552443306000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/0537f441421ccf5c28c81a67db98fbf6.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/4e46d1578df2d388030415482d7adf21.mp3";
 groupWord = "\U84dd\U8863\U670d";
 id = 57;
 states = 1;
 updateTime = 1552443306000;
 wireChar = "\U8863\U670d";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/9ce628e2e43f7831f0e83847be55f847.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/e068561380c84f299e050fe177d9cb88.mp3";
 },
 {
 colorPenChar = "\U7070";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/431bc2c1aefb1ce4f7f8d7b1e0ce6221.mp3";
 createTime = 1552443306000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/ef72f494922f180ade06356147c7a268.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/9cb1c615631f68b4dc98cca0d00fc3db.mp3";
 groupWord = "\U7070\U732b";
 id = 4;
 states = 1;
 updateTime = 1552443306000;
 wireChar = "\U732b";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/fa3bdde9152b63fbc317298242a0ab5d.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/4cf41ae09244e753963ca108955d041d.mp3";
 },
 {
 colorPenChar = "\U9ed1";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/55d69cc18b4f27af501a4fbb50dbc755.mp3";
 createTime = 1552444939000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/a350221799a97f51c7b76aac9accdfb3.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/24b4cb022457d73e0e8962ecdada84d4.mp3";
 groupWord = "\U9ed1\U8863\U670d";
 id = 53;
 states = 1;
 updateTime = 1552444939000;
 wireChar = "\U8863\U670d";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/9ce628e2e43f7831f0e83847be55f847.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/e068561380c84f299e050fe177d9cb88.mp3";
 },
 {
 colorPenChar = "\U7ea2";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/8bb69b1e857f4bc9ee10375f54d8f456.mp3";
 createTime = 1553776015000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/d1f654156c4f9a898924dd9e38fcb2a1.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/415e83c3b5791c0029b77dc4a50f0768.mp3";
 groupWord = "\U7ea2\U9e1f";
 id = 14;
 states = 1;
 updateTime = 1553776015000;
 wireChar = "\U9e1f";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/29eb65fbfd883a7a767e38302448fd68.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/96eac3c67022bb62132a18c5683b21bb.mp3";
 },
 {
 colorPenChar = "\U7ea2";
 colorPenRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/8bb69b1e857f4bc9ee10375f54d8f456.mp3";
 createTime = 1552443306000;
 groupImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/7862fc359f3d44a817df07e4a599c224.png";
 groupRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/f644a7e0d5fedb53c512b92495ed97ef.mp3";
 groupWord = "\U7ea2\U8863\U670d";
 id = 58;
 states = 1;
 updateTime = 1552443306000;
 wireChar = "\U8863\U670d";
 wireImage = "http://yuudee.oss-cn-beijing.aliyuncs.com/9ce628e2e43f7831f0e83847be55f847.png";
 wireRecord = "http://yuudee.oss-cn-beijing.aliyuncs.com/e068561380c84f299e050fe177d9cb88.mp3";
 }
 )
 
 ************************************************************
 
 
 
 */
