//
//  ZJNParentCenterViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicViewController.h"
typedef NS_ENUM(NSInteger ,PushType) {
    FormRegister,//注册成功后进入
    FromHomePage//从首页进入
};
@interface ZJNParentCenterViewController : ZJNBasicViewController
@property (nonatomic ,assign)PushType pushType;

- (void)testFunction;

@end
