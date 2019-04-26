//
//  ZLTimingView.h
//  圆圈计时器
//
//  Created by a on 2018/10/8.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLTimingView : UIView

/*!
 *圆圈加载颜色
 */
@property (nonatomic,strong)UIColor *runColor;

/*!
 *动画时间
 */
@property (nonatomic,assign)CGFloat animationTime;

/*!
 *动画开始
 */
- (void)start;

/*!
 *停止动画
 */
- (CGFloat)stop;






@end
