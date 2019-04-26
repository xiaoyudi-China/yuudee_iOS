//
//  ZLSpreadView.m
//  扩散
//
//  Created by a on 2018/9/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import "ZLSpreadView.h"

#define KSelfWidth  self.bounds.size.width
#define KSelfHeight  self.bounds.size.height
#define KViewCount  3  //波纹个数
#define KShowViewWidth KSelfWidth*0.3 //波纹宽度
#define KShowViewHeight KSelfHeight*0.3 //波纹高度

#define KHandImageWidthAndHeight 50

@interface ZLSpreadView ()

@property (nonatomic,strong)NSMutableArray *viewArray;
@property (nonatomic,assign)int time; //时间
@property (nonatomic,strong)UIImageView *handImageView;

@end

@implementation ZLSpreadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initSubView];
        [self _setData];
    }
    return self;
}

- (void)_setData {
    
    _animationTime = _viewArray.count*0.5;
    _isRepeat = YES;
    _showViewBorderWidth = 3;
    _showViewColor = [@"00ceff" hexStringToColor];
}

- (void)_initSubView {
    
    _viewArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<KViewCount; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((KSelfWidth-KShowViewWidth)*0.5, (KSelfHeight-KShowViewHeight)*0.5, KShowViewWidth, KShowViewHeight)];
        view.layer.borderWidth = 5;
        view.layer.cornerRadius = view.bounds.size.height*0.5;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        [_viewArray addObject:view];
    }
    
    //小手图片
    _handImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KSelfWidth*0.5-KHandImageWidthAndHeight*1.0/5, KSelfHeight*0.5-KHandImageWidthAndHeight*1.0/5, KHandImageWidthAndHeight, KHandImageWidthAndHeight)];
    _handImageView.image = [UIImage imageNamed:@"hand"];
    [self addSubview:_handImageView];
}

- (void)show {
    
    _time = 0;
    
    for (int i=0; i<_viewArray.count; i++) {
        
        UIView *view = _viewArray[i];
        view.layer.borderColor = _showViewColor.CGColor;
        view.layer.borderWidth = _showViewBorderWidth;
        
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*_animationTime/_viewArray.count * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:_animationTime animations:^{
                
                view.transform = CGAffineTransformScale(view.transform, 3, 3);
                view.alpha = 0;
            } completion:^(BOOL finished) {
                
                _time++;
                
                if (_time == _viewArray.count) {
                    
                    if (_isRepeat) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_repeatWaitTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self show];
                        });
                    }
                    if (_finishBlock) {
                        _finishBlock();
                    }
                }
            }];
        });
    }
    
}







@end
