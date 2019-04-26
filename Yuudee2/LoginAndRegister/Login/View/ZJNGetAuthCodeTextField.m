//
//  ZJNGetAuthCodeTextField.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNGetAuthCodeTextField.h"
@interface ZJNGetAuthCodeTextField()
@property (nonatomic ,strong)UIButton *button;
@end
@implementation ZJNGetAuthCodeTextField

-(instancetype)init{
    self = [super init];
    if (self) {
        self.rightView = self.button;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}
-(UIButton *)button{
    if (!_button) {
        _button = [UIButton itemWithTitle:@"获取验证码" titleColor:HexColor(yellowColor()) font:FontSize(14) target:self action:@selector(buttonClick)];
        _button.frame = CGRectMake(0, 0, ScreenAdapter(140), ScreenAdapter(43));
    }
    return _button;
}

#pragma mark-获取验证码
-(void)buttonClick{
    [self timerBegin];
    if (self.getAutnCodeBlock) {
        self.getAutnCodeBlock();
    }
}
-(void)timerBegin{
    __weak typeof(self) weakSelf = self;
    __block NSInteger time = 59; //倒计时时间
    //全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [weakSelf.button setTitle:@"重新发送验证码" forState:UIControlStateNormal];
                [weakSelf.button setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
                weakSelf.button.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [weakSelf.button setTitle:[NSString stringWithFormat:@"%.2ds后重新获取", seconds] forState:UIControlStateNormal];
                [weakSelf.button setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
                weakSelf.button.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
-(void)setBegin:(NSString *)begin{
    [self timerBegin];
}
-(void)setTimer:(NSString *)timer{
    [self buttonClick];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
