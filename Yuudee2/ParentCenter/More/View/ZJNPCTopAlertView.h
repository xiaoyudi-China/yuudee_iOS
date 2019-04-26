//
//  ZJNPCTopAlertView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/31.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//  当用户未完善儿童信息的时候，家长中心顶部需要有提示框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJNPCTopAlertView : UIView
@property (nonatomic ,strong)UILabel *infoLabel;
@property (nonatomic ,strong)UIButton *leftButton;
@property (nonatomic ,strong)UIButton *rightButton;
@property (nonatomic ,copy)void (^leftButtonBlock)(void);
@property (nonatomic ,copy)void (^rightButtonBlock)(void);
@end

NS_ASSUME_NONNULL_END
