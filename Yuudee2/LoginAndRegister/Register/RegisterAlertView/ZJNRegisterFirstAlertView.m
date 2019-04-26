//
//  ZJNRegisterFirstAlertView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterFirstAlertView.h"

@interface ZJNRegisterFirstAlertView()

@property (nonatomic ,strong)UIImageView *bgImageV;

@end
@implementation ZJNRegisterFirstAlertView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.bgImageV];
        [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.alertLabel];
        [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(13));
            make.right.equalTo(self).offset(-ScreenAdapter(13));
            make.top.equalTo(self).offset(ScreenAdapter(40));
        }];
        
        CGFloat btnWidth = (ScreenAdapter(340) - ScreenAdapter(90))/2;
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(30));
//            make.top.equalTo(self.alertLabel.mas_bottom).offset(22);
            make.bottom.equalTo(self).offset(-22);
            make.size.mas_equalTo(CGSizeMake(btnWidth, ScreenAdapter(37)));
        }];
        
        [self addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ScreenAdapter(30));
//            make.top.equalTo(self.alertLabel.mas_bottom).offset(22);
            make.bottom.equalTo(self).offset(-22);
            make.size.mas_equalTo(CGSizeMake(btnWidth, ScreenAdapter(37)));
        }];
    }
    return self;
}

-(UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [UIImageView itemWithImage:SetImage(@"registerer_popup_bg") backColor:[UIColor clearColor]];
    }
    return _bgImageV;
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [UILabel createLabelWithTitle:@"该手机号已经被注册，验证手机号后可直接登录" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentCenter numberOfLines:2];
    }
    return _alertLabel;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton itemWithTitle:@"取消" titleColor:HexColor(0xfffdec) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(cancelBtnClick)];
        [_cancelBtn setBackgroundImage:SetImage(@"home_button_bg") forState:UIControlStateNormal];
        _cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    }
    return _cancelBtn;
}
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton itemWithTitle:@"去登录" titleColor:HexColor(0xfffdec) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(loginBtnClick)];
        [_loginBtn setBackgroundImage:SetImage(@"home_button_bg") forState:UIControlStateNormal];
        _loginBtn.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    }
    return _loginBtn;
}

#pragma mark-取消按钮点击实现方法
-(void)cancelBtnClick{
    [[self superview] removeFromSuperview];
}

#pragma mark-去登录按钮点击实现方法
-(void)loginBtnClick{
    if (self.goToLoginBlock){
        self.goToLoginBlock();
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
