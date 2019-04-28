//
//  ZJNParentCenterBottomView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNParentCenterBottomView : UIView
@property (nonatomic ,copy)void (^bottomViewBlock)(NSInteger tag);

- (void)testFunction;

@end
