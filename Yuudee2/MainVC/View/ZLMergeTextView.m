//
//  ZLMergeTextView.m
//  合并文字
//
//  Created by a on 2018/9/26.
//  Copyright © 2018年 a. All rights reserved.
//

#import "ZLMergeTextView.h"
#import "UIView+Position.h"

//组合时间
#define KMergeTime 1.5
//变成白色背景间隔时间
#define KWhiteAfterTime 5.2
#define KTextSize 50

@interface ZLMergeTextView ()

@property (nonatomic,strong)UILabel *leftLabel;
@property (nonatomic,strong)UILabel *rightLabel;

@end

@implementation ZLMergeTextView

+ (ZLMergeTextView *)MergeTextView {
    
    ZLMergeTextView *view = [[ZLMergeTextView alloc] initWithFrame:[ZLMergeTextView viewRect]];
    return view;
}

//视图的rect
+ (CGRect)viewRect {
    
    return CGRectMake(0, 0, 60+20+110, 60);
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initSubView];
    }
    return self;
}

- (void)_initSubView {
    
    //110  60
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width-110)*0.5, 0, 110, 60)];
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.font = [UIFont boldSystemFontOfSize:AdFloat(KTextSize)];
    _rightLabel.textColor = [@"92674a" hexStringToColor];
    _rightLabel.layer.masksToBounds = YES;
    _rightLabel.layer.cornerRadius = AdFloat(4);
    _rightLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_rightLabel];
    
}

- (UILabel *)leftLabel {
    
    if (!_leftLabel) {
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.font = [UIFont boldSystemFontOfSize:AdFloat(KTextSize)];
        _leftLabel.textColor = [@"92674a" hexStringToColor];
        _leftLabel.layer.masksToBounds = YES;
        _leftLabel.layer.cornerRadius = AdFloat(4);
        _leftLabel.backgroundColor = [UIColor whiteColor];
    }
    
    return _leftLabel;
}

- (void)setRightText:(NSString *)rightText {
    
    _rightText = rightText;
    
    _rightLabel.text = _rightText;
}

//显示文字动画合并
- (void)showLeftText:(NSString *)leftText withAnimationTime:(CGFloat )time {
    
    [UIView animateWithDuration:time animations:^{
        
        self.rightLabel.right = self.width;
        
    }completion:^(BOOL finished) {
     
        self.leftLabel.text = leftText;
        [self addSubview:self.leftLabel];
        
        //变成白色背景时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KWhiteAfterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGPoint leftCenterPoint = self.leftLabel.center;
            CGPoint rightCenterPoint = self.rightLabel.center;
            
            [self.leftLabel sizeToFit];
            [self.rightLabel sizeToFit];
            
            self.leftLabel.center = leftCenterPoint;
            self.rightLabel.center = rightCenterPoint;
            
            CGFloat textWidth = [[NSString stringWithFormat:@"%@%@",self.leftLabel.text,self.rightLabel.text] sizeWithFont:self.leftLabel.font].width;
            CGFloat textLeft = (self.width-textWidth)*0.5;
            
            if (self.block) {
                self.block();
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:KMergeTime animations:^{
                    
                    self.leftLabel.left = textLeft;
                    self.rightLabel.right = textLeft+textWidth;
                    
                }];
            });
        });
        
        
    }];
    
    
    
    
}













@end
