//
//  ZJNRegisterSuccessAlertView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/7.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterSuccessAlertView.h"

@interface ZJNRegisterSuccessAlertView()
//木纹背景图
@property (nonatomic ,strong)UIImageView *bgImageV;

//气泡背景图
@property (nonatomic ,strong)UIImageView *bubbleImageV;

//logo图片
@property (nonatomic ,strong)UIImageView *logoImageV;

//
@property (nonatomic ,strong)UIButton    *showBtn;

//OK按钮
@property (nonatomic ,strong)UIButton    *OKButton;

@end

@implementation ZJNRegisterSuccessAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bgImageV];
        [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.bubbleImageV];
        [self.bubbleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(ScreenAdapter(147)+AddNav(), 0, 0, 0));
        }];
        
        [self addSubview:self.logoImageV];
        [self.logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(ScreenAdapter(55)+AddNav());
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(76), ScreenAdapter(76)));
        }];
        
        [self addSubview:self.showBtn];
        [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(245)+AddNav());
            make.left.right.equalTo(self);
            make.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.OKButton];
        [self.OKButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.showBtn.mas_bottom).offset(ScreenAdapter(55));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
        }];
    }
    return self;
}
//木纹背景
-(UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [UIImageView itemWithImage:SetImage(@"wood_bg") backColor:[UIColor whiteColor]];
    }
    return _bgImageV;
}
//气泡背景
-(UIImageView *)bubbleImageV{
    if (!_bubbleImageV) {
        _bubbleImageV = [UIImageView itemWithImage:SetImage(@"bg") backColor:[UIColor clearColor]];
    }
    return _bubbleImageV;
}

//logo
-(UIImageView *)logoImageV{
    if (!_logoImageV) {
        _logoImageV = [UIImageView itemWithImage:SetImage(@"yuudee") backColor:[UIColor clearColor]];
    }
    return _logoImageV;
}
//
-(UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitle:@"恭喜您，注册成功" forState:UIControlStateNormal];
        [_showBtn setTitleColor:RGBColor(19, 16, 29, 1) forState:UIControlStateNormal];
        [_showBtn setImage:SetImage(@"sign_state_ok") forState:UIControlStateNormal];
        _showBtn.titleLabel.font = FontSize(16);
        _showBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _showBtn;
}
//OKButton
-(UIButton *)OKButton{
    if (!_OKButton) {
        _OKButton = [UIButton itemWithTitle:@"OK" titleColor:[UIColor whiteColor] font:FontSize(16) target:self action:@selector(OKButtonClick)];
        [_OKButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _OKButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
    }
    return _OKButton;
}

#pragma mark-OKButtonClick
-(void)OKButtonClick{
    if (self.perfectChildInfoBlock) {
        self.perfectChildInfoBlock();
    }
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
