//
//  ZJNVerifyCodeView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNVerifyCodeView : UIView
@property (nonatomic ,copy)void (^codeBlock)(NSString *verifyCode);
-(void)cleanVerifyCode;

- (void)testFunction;
@end
