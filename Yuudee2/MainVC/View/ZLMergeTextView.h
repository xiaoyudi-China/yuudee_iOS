//
//  ZLMergeTextView.h
//  合并文字
//
//  Created by a on 2018/9/26.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZLStartShowBlock)(void);

@interface ZLMergeTextView : UIView

+ (ZLMergeTextView *)MergeTextView;

//视图的rect
+ (CGRect)viewRect;

//右侧显示的文字
@property (nonatomic,copy)NSString *rightText;

//显示文字动画合并
- (void)showLeftText:(NSString *)leftText withAnimationTime:(CGFloat )time;

//合并图片的block
@property (nonatomic,copy)ZLStartShowBlock block;

@end
