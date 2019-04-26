//
//  ZLSpreadView.h
//  扩散
//
//  Created by a on 2018/9/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZLSpreadBlock)(void);

@interface ZLSpreadView : UIView

//小手的图片
@property (nonatomic,strong,readonly)UIImageView *handImageView;

//一个圈扩散完成的时间
@property (nonatomic,assign)CGFloat animationTime;

//圈的宽度
@property (nonatomic,assign)CGFloat showViewBorderWidth;

//圈的颜色
@property (nonatomic,strong)UIColor *showViewColor;

//是否重复播放  默认重复
@property (nonatomic,assign)BOOL isRepeat;

//重复间隔时间  默认0
@property (nonatomic,assign)CGFloat repeatWaitTime;

//一次动画完成的block
@property (nonatomic,copy)ZLSpreadBlock finishBlock;

//播放动画  
- (void)show;



@end
