//
//  ZJNRegisterViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterViewController.h"
#import "AppDelegate.h"
#import "ZJNPhoneTextField.h"
#import "ZJNRegisterAlertView.h"
//输入验证码页面
#import "ZJNRegisterVerifyCodeViewController.h"
//选择手机号归属地
#import "ZJNCityListViewController.h"
//登录页面
#import "ZJNLoginViewController.h"
//用户协议
#import "ZJNProtocolViewController.h"
#import "ZJNRequestModel.h"
@interface ZJNRegisterViewController ()<ZJNRegisterAlertViewDelegate>
//木纹背景图
@property (nonatomic ,strong)UIImageView *bgImageV;
//气泡背景图
@property (nonatomic ,strong)UIImageView *bubbleImageV;
//右上角主页面按钮
@property (nonatomic ,strong)UIButton    *homeBtn;
//logo图片
@property (nonatomic ,strong)UIImageView *logoImageV;
//手机号归属地
@property (nonatomic ,strong)UILabel     *phoneLabel;
//国旗
@property (nonatomic ,strong)UIImageView *flagImageV;
//区号
@property (nonatomic ,strong)UILabel     *areaCodeLabel;
//切换区号按钮
@property (nonatomic ,strong)UIButton    *changeBtn;
//手机号输入框
@property (nonatomic ,strong)ZJNPhoneTextField *phoneTextField;
//用户协议按钮
@property (nonatomic ,strong)UIButton *protocolBtn;
//下一步按钮
@property (nonatomic ,strong)UIButton    *nextBtn;
//点击下一步按钮弹出提示框
@property (nonatomic ,strong)ZJNRegisterAlertView *alertView;
//请求model
@property (nonatomic ,strong)ZJNRequestModel *requestModel;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestModel = [[ZJNRequestModel alloc]init];
    self.requestModel.districe = @"86";
    self.requestModel.districeId = 1;
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
    
    [self.view addSubview:self.logoImageV];
    [self.logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ScreenAdapter(55)+AddNav());
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(76), ScreenAdapter(76)));
    }];
    
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(35));
        make.top.equalTo(self.view).offset(ScreenAdapter(223)+AddNav());
    }];
    
    [self.view addSubview:self.areaCodeLabel];
    [self.areaCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-ScreenAdapter(35));
        make.centerY.equalTo(self.phoneLabel);
    }];
    
    [self.view addSubview:self.flagImageV];
    [self.flagImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.areaCodeLabel.mas_left).offset(-ScreenAdapter(5));
        make.centerY.equalTo(self.phoneLabel);
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(20), ScreenAdapter(20)));
    }];
    
    [self.view addSubview:self.changeBtn];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImageV);
        make.right.equalTo(self.areaCodeLabel);
        make.centerY.equalTo(self.areaCodeLabel);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(ScreenAdapter(21));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(60));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    
    [self.view addSubview:self.protocolBtn];
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nextBtn);
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-AdFloat(10));
        make.width.equalTo(self.nextBtn);
        make.height.mas_equalTo(ScreenAdapter(44));
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
//手机号归属地
-(UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel createLabelWithTitle:@"手机号归属地" textColor:HexColor(textColor()) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _phoneLabel;
}
//区号label
-(UILabel *)areaCodeLabel{
    if (!_areaCodeLabel) {
        _areaCodeLabel = [UILabel createLabelWithTextColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentRight numberOfLines:1];
        self.areaCodeLabel.text = @"中国（+86）";
    }
    return _areaCodeLabel;
}
//国旗图标
-(UIImageView *)flagImageV{
    if (!_flagImageV) {
        _flagImageV = [UIImageView itemWithImage:SetImage(@"china_pic") backColor:[UIColor clearColor] Radius:ScreenAdapter(10)];
    }
    return _flagImageV;
}
-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}
//手机号输入框
-(ZJNPhoneTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[ZJNPhoneTextField alloc]init];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.imageName = @"sign_icon_iphone";
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.areaCode = [NSString stringWithFormat:@"%ld",self.requestModel.districeId];
        __weak typeof(self) weakSelf = self;
        _phoneTextField.inputErrorBlock = ^{
            [weakSelf showHint:@"输入错误"];
        };
        _phoneTextField.phoneBlack = ^(BOOL isValidate) {
            if (isValidate) {
                [weakSelf.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.nextBtn.userInteractionEnabled = YES;
            }else{
                [weakSelf showHint:@"手机号格式输入错误"];
                [weakSelf.nextBtn setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
                weakSelf.nextBtn.userInteractionEnabled = NO;
            }
        };
    }
    return _phoneTextField;
}
//用户协议按钮
-(UIButton *)protocolBtn{
    if (!_protocolBtn) {
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:@"点击下方按钮表示您已经阅读并同意《用户注册协议》"];
        [titleStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){16,8}];
        [titleStr addAttribute:NSForegroundColorAttributeName value:HexColor(0xc06d00) range:NSMakeRange(16, 8)];
        [titleStr addAttribute:NSUnderlineColorAttributeName value:HexColor(0xc06d00) range:NSMakeRange(16, 8)];
        [_protocolBtn setAttributedTitle:titleStr forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = FontSize(12);
        [_protocolBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, -10, 0)];
    }
    return _protocolBtn;
}
//下一步按钮
-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton itemWithTitle:@"下一步" titleColor:HexColor(0xb5ada5) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(nextBtnClick)];
        [_nextBtn setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _nextBtn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _nextBtn.userInteractionEnabled = NO;
    }
    return _nextBtn;
}

//提示框
-(ZJNRegisterAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[ZJNRegisterAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenHeight())];
        _alertView.delegate = self;
    }
    return _alertView;
}
#pragma mark-home按钮点击实现方法
-(void)homeButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-下一步按钮点击实现方法
-(void)nextBtnClick{
    //首先判断该手机号是否已经被注册
    self.requestModel.phone = self.phoneTextField.plainPhoneNum;
    NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"districeId":@(self.requestModel.districeId)};
    [[ZJNRequestManager sharedManager] postWithUrlString:PhoneIsRegister parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            if ([[data[@"data"][@"isRegister"] stringValue] isEqualToString:@"0"]) {
                //未注册
                self.alertView.alertType = SliderAlertType;
                [self.phoneTextField resignFirstResponder];
                [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
            }else{
                //已注册
                self.alertView.alertType = ExistAlertType;
                [self.phoneTextField resignFirstResponder];
                [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
            }
        }else{
            //其他情况
            [self showHint:data[@"msg"]];
        }
        if (self.success) {
            self.success(data);
        }
    } failure:^(NSError *error) {
        [self showHint:ErrorInfo];
        if (self.failure) {
            self.failure(error);
        }
    }];
}

#pragma mark-提示框代理-ZJNRegisterAlertViewDelegate
//跳转到设置密码控制器
-(void)zjnRegisterAlertViewVerifySuccess{
    NSDictionary *dic = @{@"phone":self.requestModel.phone,@"districeId":@(self.requestModel.districeId)};
    [[ZJNRequestManager sharedManager] postWithUrlString:RegisterSendCode parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            //发送成功
            ZJNRegisterVerifyCodeViewController *verifyCode = [[ZJNRegisterVerifyCodeViewController alloc]init];
            verifyCode.requestModel = self.requestModel;
            [self.navigationController pushViewController:verifyCode animated:YES];
            [self.alertView removeFromSuperview];
            self.alertView = nil;
        }
        if (self.success) {
            self.success(data);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        if (self.failure) {
            self.failure(error);
        }
    }];
}
//去登录
-(void)zjnRegisterAlertViewGoToLogin{
    ZJNLoginViewController *loginV = [[ZJNLoginViewController alloc]init];
    loginV.registPhone = self.phoneTextField.text;
    [self.navigationController pushViewController:loginV animated:YES];
    [self.alertView removeFromSuperview];
    self.alertView = nil;
}
#pragma mark-切换手机号归属地
-(void)changeBtnClick{
    ZJNCityListViewController *viewC = [[ZJNCityListViewController alloc]init];
    viewC.changeAreaCodeBlock = ^(ZJNCityModel *cityModel) {
        self.areaCodeLabel.text = [NSString stringWithFormat:@"%@ +%@",cityModel.name,cityModel.phonePrefix];
        if (cityModel.logo) {
            [self.flagImageV sd_setImageWithURL:UrlImage(cityModel.logo) placeholderImage:SetImage(nil)];
        }else{
            self.flagImageV.image = nil;
        }
        if ([cityModel.name isEqualToString:@"中国"]) {
            self.flagImageV.image = SetImage(@"china_pic");
        }
        
        self.requestModel.districeId = [cityModel.id integerValue];
        self.requestModel.districe = cityModel.phonePrefix;
        self.phoneTextField.areaCode = cityModel.id;
        self.phoneTextField.text = @"";
        [self.nextBtn setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
    };
    [self.navigationController pushViewController:viewC animated:YES];
}

//协议按钮点击实现方法
-(void)protocolBtnClick{
    ZJNProtocolViewController *vc = [[ZJNProtocolViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testPhoneIsRegister:(NSString *)phoneNum disId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
    self.requestModel.districeId = disId;
    self.phoneTextField.plainPhoneNum = phoneNum;
    [self nextBtnClick];
}

- (void)testRegisterSendCode:(NSString *)phoneNum disId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    self.success = success;
    self.failure = failure;
    self.requestModel.districeId = disId;
    self.requestModel.phone = phoneNum;
    [self zjnRegisterAlertViewVerifySuccess];
    [self protocolBtnClick];
    [self zjnRegisterAlertViewGoToLogin];
}


@end
