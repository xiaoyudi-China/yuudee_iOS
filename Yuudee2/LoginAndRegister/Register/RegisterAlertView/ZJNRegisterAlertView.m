//
//  ZJNRegisterAlertView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterAlertView.h"
#import "ZJNRegisterFirstAlertView.h"
#import "ZJNRegisterSecondAlertView.h"
@interface ZJNRegisterAlertView()
//木纹背景图
@property (nonatomic ,strong)UIImageView *bgImageV;
//气泡背景图
@property (nonatomic ,strong)UIImageView *bubbleImageV;
//右上角主页面按钮
@property (nonatomic ,strong)UIButton    *homeBtn;
//logo图片
@property (nonatomic ,strong)UIImageView *logoImageV;
//半透明背景
@property (nonatomic ,strong)UIView      *alphaView;
//电话号已注册弹窗
@property (nonatomic ,strong)ZJNRegisterFirstAlertView *firstAlertView;
//电话号未注册弹窗
@property (nonatomic ,strong)ZJNRegisterSecondAlertView *secondAlertView;
@end
@implementation ZJNRegisterAlertView
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
        
        [self addSubview:self.homeBtn];
        [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(22)+AddNav());
            make.right.equalTo(self).offset(-ScreenAdapter(22));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(48), ScreenAdapter(51)));
        }];
        
        [self addSubview:self.logoImageV];
        [self.logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(ScreenAdapter(55)+AddNav());
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(76), ScreenAdapter(76)));
        }];
        
        [self addSubview:self.alphaView];
        [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
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
//主页按钮
-(UIButton *)homeBtn{
    if (!_homeBtn) {
        _homeBtn = [UIButton itemWithTarget:self action:@selector(homeButtonClick) image:@"home_button" highImage:nil];
    }
    return _homeBtn;
}
//logo
-(UIImageView *)logoImageV{
    if (!_logoImageV) {
        _logoImageV = [UIImageView itemWithImage:SetImage(@"yuudee") backColor:[UIColor clearColor]];
    }
    return _logoImageV;
}
//半透明背景
-(UIView *)alphaView{
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = RGBColor(0, 0, 0, 0.7);
    }
    return _alphaView;
}
-(ZJNRegisterFirstAlertView *)firstAlertView{
    if (!_firstAlertView) {
        _firstAlertView = [[ZJNRegisterFirstAlertView alloc]init];
        __weak typeof(self) weakSelf = self;
        _firstAlertView.goToLoginBlock = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(zjnRegisterAlertViewGoToLogin)]) {
                [weakSelf.delegate zjnRegisterAlertViewGoToLogin];
            }
        };
    }
    return _firstAlertView;
}

-(ZJNRegisterSecondAlertView *)secondAlertView{
    if (!_secondAlertView) {
        _secondAlertView = [[ZJNRegisterSecondAlertView alloc]init];
        __weak typeof(self) weakSelf = self;
        _secondAlertView.verifyBlock = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(zjnRegisterAlertViewVerifySuccess)]) {
                [weakSelf.delegate zjnRegisterAlertViewVerifySuccess];
            }
        };
    }
    return _secondAlertView;
}

//
-(void)homeButtonClick{
    
}

-(void)setAlertType:(AlertType)alertType{
    if (alertType == ExistAlertType) {
        [self addSubview:self.firstAlertView];
        [self.firstAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(340), ScreenAdapter(146)));
        }];
    }else{
        [self addSubview:self.secondAlertView];
        [self.secondAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(340), ScreenAdapter(146)));
        }];
    }
}
-(void)setAlertStr:(NSString *)alertStr{
    self.firstAlertView.alertLabel.text = alertStr;
}
-(void)setRightBtnTitle:(NSString *)rightBtnTitle{
    
    [self.firstAlertView.loginBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
