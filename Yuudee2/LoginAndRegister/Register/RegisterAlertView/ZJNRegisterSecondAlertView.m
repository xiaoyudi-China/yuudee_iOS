//
//  ZJNRegisterSecondAlertView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterSecondAlertView.h"
#import "ZJNSlider.h"

@interface ZJNRegisterSecondAlertView()

@property (nonatomic ,strong)UIImageView *bgImageV;
@property (nonatomic ,strong)UILabel     *titleLabel;
@property (nonatomic ,strong)UIButton    *closeBtn;
@property (nonatomic ,strong)ZJNSlider   *kSlider;
@end
@implementation ZJNRegisterSecondAlertView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.bgImageV];
        [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(30));
            make.left.equalTo(self).offset(ScreenAdapter(25));
            
        }];
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(20));
            make.right.equalTo(self).offset(-ScreenAdapter(20));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(30), ScreenAdapter(30)));
        }];
        
        [self addSubview:self.kSlider];
        [self.kSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.closeBtn);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(20));
            make.height.mas_equalTo(43);
        }];
    }
    return self;
}

-(UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [UIImageView itemWithImage:SetImage(@"sign_popup_bg") backColor:[UIColor clearColor]];
    }
    return _bgImageV;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTitle:@"请向右滑动滑块验证" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _titleLabel;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton itemWithTarget:self action:@selector(closeBtnClick) image:@"sign_button_close" highImage:nil];
    }
    return _closeBtn;
}
-(ZJNSlider *)kSlider{
    
    if (!_kSlider) {
        _kSlider = [[ZJNSlider alloc]init];
        [_kSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _kSlider;
}
#pragma mark-关闭弹框
-(void)closeBtnClick{
    [[self superview] removeFromSuperview];
}
#pragma mark-滑块验证
-(void)sliderValueChanged:(ZJNSlider *)slider{
    NSLog(@"%f",slider.value);
    if (slider.value<1) {
        [slider setThumbImage:SetImage(@"sign_icon_right") forState:UIControlStateNormal];
        return;
    }else{
        [slider setThumbImage:SetImage(@"sign_state_ok") forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.verifyBlock) {
                self.verifyBlock();
            }
        });
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
