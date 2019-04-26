//
//  ZJNPersonSecondInfoView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/17.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPersonSecondInfoView.h"
#import "ZJNPersonCircleView.h"

@interface ZJNPersonSecondInfoView()
@property (nonatomic ,strong)ZJNPersonCircleView *leftCView;
@property (nonatomic ,strong)ZJNPersonCircleView *middleCView;
@property (nonatomic ,strong)ZJNPersonCircleView *rightCView;
@end

@implementation ZJNPersonSecondInfoView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = RGBColor(19, 16, 29, 1);
        dotView.layer.cornerRadius = ScreenAdapter(2.5);
        dotView.layer.masksToBounds = YES;
        [self addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(30));
            make.left.equalTo(self).offset(ScreenAdapter(35));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(5), ScreenAdapter(5)));
        }];
        
        UILabel *titleLabel = [UILabel createLabelWithTextColor:RGBColor(19, 16, 29, 1) font:FontSize(15)];
        titleLabel.text = @"个人信息";
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dotView);
            make.left.equalTo(dotView.mas_right).offset(ScreenAdapter(10));
        }];
        
        [self addSubview:self.middleCView];
        [self.middleCView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(88), ScreenAdapter(134)));
            make.top.equalTo(titleLabel.mas_bottom).offset(ScreenAdapter(16));
        }];
        
        [self addSubview:self.leftCView];
        [self.leftCView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.middleCView);
            make.size.equalTo(self.middleCView);
            make.right.equalTo(self.middleCView.mas_left).offset(-ScreenAdapter(18));
        }];
        
        [self addSubview:self.rightCView];
        [self.rightCView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.middleCView);
            make.size.equalTo(self.middleCView);
            make.left.equalTo(self.middleCView.mas_right).offset(ScreenAdapter(18));
        }];
    }
    return self;
}

-(ZJNPersonCircleView *)middleCView{
    if (!_middleCView) {
        _middleCView = [[ZJNPersonCircleView alloc]init];
        _middleCView.topLabel.text = @"******";
        _middleCView.bottomLabel.text = @"账号密码";
        [_middleCView.changeBtn addTarget:self action:@selector(middleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleCView;
}

-(ZJNPersonCircleView *)leftCView{
    if (!_leftCView) {
        _leftCView = [[ZJNPersonCircleView alloc]init];
        _leftCView.topLabel.text = @"";
        _leftCView.bottomLabel.text = @"儿童昵称";
        [_leftCView.changeBtn addTarget:self action:@selector(leftCViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftCView;
}

-(ZJNPersonCircleView *)rightCView{
    if (!_rightCView) {
        _rightCView = [[ZJNPersonCircleView alloc]init];
        _rightCView.topLabel.text = @"";
        _rightCView.bottomLabel.text = @"手机号";
        [_rightCView.changeBtn addTarget:self action:@selector(rightCViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightCView;
}

//账号密码
-(void)middleButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personSecondInfoViewChangeInfoWithType:)]) {
        [self.delegate personSecondInfoViewChangeInfoWithType:0];
    }
}
//儿童昵称
-(void)leftCViewButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personSecondInfoViewChangeInfoWithType:)]) {
        [self.delegate personSecondInfoViewChangeInfoWithType:1];
    }
}
//手机号
-(void)rightCViewButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personSecondInfoViewChangeInfoWithType:)]) {
        [self.delegate personSecondInfoViewChangeInfoWithType:2];
    }
}

-(void)setInfoModel:(ZJNUserInfoModel *)infoModel{
    _infoModel = infoModel;
    self.leftCView.topLabel.text = SetStr(self.infoModel.chilName);
    self.rightCView.topLabel.text = [NSString changePhontNumber:self.infoModel.phoneNumber];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
