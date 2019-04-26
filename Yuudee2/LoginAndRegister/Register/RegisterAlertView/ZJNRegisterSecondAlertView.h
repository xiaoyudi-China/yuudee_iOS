//
//  ZJNRegisterSecondAlertView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^VerifyBlock) (void);
@interface ZJNRegisterSecondAlertView : UIView
@property (nonatomic ,copy)VerifyBlock verifyBlock;
@end
