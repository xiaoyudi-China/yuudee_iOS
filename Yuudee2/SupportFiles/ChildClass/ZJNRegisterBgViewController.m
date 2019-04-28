//
//  ZJNRegisterBgViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/1.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterBgViewController.h"

@interface ZJNRegisterBgViewController ()
//木纹背景图
@property (nonatomic ,strong)UIImageView *bgImageV;
//气泡背景图
@property (nonatomic ,strong)UIImageView *bubbleImageV;
//logo图片
@property (nonatomic ,strong)UIImageView *logoImageV;
@end

@implementation ZJNRegisterBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageV];
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bubbleImageV];
    [self.bubbleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(ScreenAdapter(147)+AddNav(), 0, 0, 0));
    }];
    
    [self.view addSubview:self.homeBtn];
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(22)+AddNav());
        make.right.equalTo(self.view).offset(-ScreenAdapter(22));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(48), ScreenAdapter(51)));
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.homeBtn);
        make.left.equalTo(self.view).offset(ScreenAdapter(22));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(48), ScreenAdapter(51)));
    }];
    
    [self.view addSubview:self.logoImageV];
    [self.logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ScreenAdapter(55)+AddNav());
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(76), ScreenAdapter(76)));
    }];

    // Do any additional setup after loading the view.
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
//返回按钮
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:SetImage(@"left_button") forState:UIControlStateNormal];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}
//主页按钮
-(UIButton *)homeBtn{
    if (!_homeBtn) {
        _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homeBtn setImage:SetImage(@"home_button") forState:UIControlStateNormal];
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

- (void)testFunction{
    [self viewDidLoad];
}

@end
