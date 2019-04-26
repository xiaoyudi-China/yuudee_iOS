//
//  ZJNCPChangeSuccessViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNCPChangeSuccessViewController.h"
#import "ZJNLoginViewController.h"
@interface ZJNCPChangeSuccessViewController ()
//
@property (nonatomic ,strong)UIButton    *showBtn;

//OK按钮
@property (nonatomic ,strong)UIButton    *OKButton;
@end

@implementation ZJNCPChangeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.showBtn];
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(245)+AddNav());
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ScreenAdapter(45));
    }];
    
    [self.view addSubview:self.OKButton];
    [self.OKButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.showBtn.mas_bottom).offset(ScreenAdapter(55));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    // Do any additional setup after loading the view.
}
//
-(UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitle:@"恭喜您，更换手机号码成功" forState:UIControlStateNormal];
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
        _OKButton = [UIButton itemWithTitle:@"重新登录" titleColor:[UIColor whiteColor] font:FontSize(16) target:self action:@selector(OKButtonClick)];
        [_OKButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _OKButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
    }
    return _OKButton;
}
#pragma mark-OKButtonClick
-(void)OKButtonClick{
    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[ZJNLoginViewController new]];
}

- (void)testFunction{
    [self viewDidLoad];
    [self OKButtonClick];
}

@end
