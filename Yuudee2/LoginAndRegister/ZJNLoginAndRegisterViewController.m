//
//  ZJNLoginAndRegisterViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNLoginAndRegisterViewController.h"
#import "ProductVC.h"
//注册页面
#import "ZJNRegisterViewController.h"
//登录页面
#import "ZJNLoginViewController.h"
@interface ZJNLoginAndRegisterViewController ()
@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)UIButton    *loginBtn;
@property (nonatomic ,strong)UIButton    *registBtn;
@property (nonatomic ,strong)UIButton    *moreBtn;
@property (nonatomic ,strong)UILabel     *moreLabel;
@property (nonatomic ,strong)UIImageView *nextImageV;
@end

@implementation ZJNLoginAndRegisterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.nextImageV];
    [self.nextImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-ScreenAdapter(30));
        make.bottom.equalTo(self.view).offset(-ScreenAdapter(27));
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.view addSubview:self.moreLabel];
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextImageV.mas_left).offset(-ScreenAdapter(10));
        make.centerY.equalTo(self.nextImageV);
        make.left.equalTo(self.view);
    }];
    
    [self.view addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-ScreenAdapter(22));
        make.size.mas_equalTo(CGSizeMake(150, 44));
    }];
    
    CGFloat btnWidth = (ScreenWidth()-ScreenAdapter(64))/2.0;
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-ScreenAdapter(22));
        make.size.mas_equalTo(CGSizeMake(btnWidth, ScreenAdapter(56)));
        make.bottom.equalTo(self.moreLabel.mas_top).offset(-ScreenAdapter(7.5));
    }];
    
    [self.view addSubview:self.registBtn];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(22));
        make.size.mas_equalTo(CGSizeMake(btnWidth, ScreenAdapter(56)));
        make.bottom.equalTo(self.loginBtn);
    }];
    // Do any additional setup after loading the view.
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView itemWithImage:SetImage(@"home_no-login_bg") backColor:[UIColor whiteColor]];
        
    }
    return _bgImageView;
}
-(UIImageView *)nextImageV{
    if (!_nextImageV) {
        _nextImageV = [UIImageView itemWithImage:SetImage(@"home_button_right") backColor:[UIColor clearColor]];
    }
    return _nextImageV;
}
-(UILabel *)moreLabel{
    if (!_moreLabel) {
        _moreLabel = [UILabel createLabelWithTitle:@"了解产品详情" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentRight numberOfLines:1];
    }
    return _moreLabel;
}
-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton itemWithTarget:self action:@selector(moreBtnClick) image:nil highImage:nil];
    }
    return _moreBtn;
}
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton itemWithTarget:self action:@selector(loginBtnClick) image:@"home_button_bg" highImage:nil];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = FontWeight(16, UIFontWeightBlack);
        [_loginBtn setTitleColor:HexColor(0xfffdec) forState:UIControlStateNormal];
        _loginBtn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
    }
    return _loginBtn;
}
-(UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [UIButton itemWithTarget:self action:@selector(registBtnClick) image:@"home_button_bg" highImage:nil];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registBtn.titleLabel.font = FontWeight(16, UIFontWeightBlack);
        [_registBtn setTitleColor:HexColor(0xfffdec) forState:UIControlStateNormal];
        _registBtn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
    }
    return _registBtn;
}

#pragma 按钮点击事件
//了解更多
-(void)moreBtnClick{
    ProductVC * vc = [ProductVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
//登陆
-(void)loginBtnClick{
    ZJNLoginViewController *viewC = [[ZJNLoginViewController alloc]init];
    [self.navigationController pushViewController:viewC animated:YES];
}
//注册
-(void)registBtnClick{
    ZJNRegisterViewController *viewC = [[ZJNRegisterViewController alloc]init];
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)testFunction{
    [self viewDidLoad];
    [self viewWillAppear:YES];
    [self registBtnClick];
    [self loginBtnClick];
    [self moreBtnClick];
}

@end
