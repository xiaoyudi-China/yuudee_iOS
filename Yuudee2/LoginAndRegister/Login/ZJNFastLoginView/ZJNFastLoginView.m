//
//  ZJNFastLoginView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/7.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNFastLoginView.h"
#import "ZJNAreaPhoneTextField.h"
#import "ZJNAuthCodeTextField.h"
#import "ZJNGetAuthCodeTextField.h"
#import "ZJNRegisterViewController.h"
//切换手机号归属地
#import "ZJNCityListViewController.h"
#import <JPUSHService.h>
@interface ZJNFastLoginView()<UITextFieldDelegate>
@property (nonatomic ,strong)ZJNAreaPhoneTextField *phoneTextField;
@property (nonatomic ,strong)ZJNAuthCodeTextField *authCodeTextField;
@property (nonatomic ,strong)ZJNGetAuthCodeTextField *getCodeTextField;
@property (nonatomic ,strong)UIButton *loginButton;
@property (nonatomic ,strong)UIButton *registerButton;
@property (nonatomic ,assign)NSInteger areaId;
@property (nonatomic ,strong)NSString *authCode;

@end
@implementation ZJNFastLoginView
-(instancetype)init{
    self = [super init];
    if (self) {
        _areaId = 1;
        [self addSubview:self.phoneTextField];
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(27));
            make.right.equalTo(self).offset(-ScreenAdapter(27));
            make.top.equalTo(self).offset(ScreenAdapter(37));
            make.height.mas_equalTo(ScreenAdapter(43));
        }];
        
        [self addSubview:self.authCodeTextField];
        [self.authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(20)); make.left.equalTo(self).offset(ScreenAdapter(27));
            make.right.equalTo(self).offset(-ScreenAdapter(27));
            
            make.height.mas_equalTo(ScreenAdapter(43));
        }];
        
        [self addSubview:self.getCodeTextField];
        [self.getCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(20));
            make.left.equalTo(self.authCodeTextField.mas_right).offset(ScreenAdapter(54)).with.priority(300);
            make.left.equalTo(self).offset(ScreenAdapter(27)).with.priority(250);
            make.width.mas_equalTo(ScreenWidth()-ScreenAdapter(54));
            make.height.mas_equalTo(ScreenAdapter(43));
        }];
        
        [self addSubview:self.loginButton];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.getCodeTextField.mas_bottom).offset(ScreenAdapter(100));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
        }];
        
        [self addSubview:self.registerButton];
        [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.loginButton.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(80), ScreenAdapter(30)));
        }];
    }
    return self;
}
-(ZJNAreaPhoneTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[ZJNAreaPhoneTextField alloc]init];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.areaCode = [NSString stringWithFormat:@"%ld",self.areaId];
        __weak typeof(self) weakSelf = self;
        _phoneTextField.phoneBlack = ^(BOOL isValidate) {
            if (isValidate) {
                [weakSelf isRegistedPhone:weakSelf.phoneTextField.plainPhoneNum];
            }else{
                [weakSelf.viewController showHint:@"手机号格式错误"];
                [weakSelf.loginButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
                weakSelf.loginButton.userInteractionEnabled = NO;
            }
        };
        _phoneTextField.areaBtnClickBlock = ^{
            [weakSelf leftButtonClick];
        };
        
//        [_phoneTextField.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneTextField;
}

-(ZJNAuthCodeTextField *)authCodeTextField{
    if (!_authCodeTextField) {
        _authCodeTextField = [[ZJNAuthCodeTextField alloc]init];
        _authCodeTextField.imageName = @"验证码";
        _authCodeTextField.placeholder = @"请输入验证码";
        _authCodeTextField.delegate = self;
        __weak typeof(self)weakSelf = self;
        _authCodeTextField.authResult = ^(BOOL result) {
            if (result) {
                if (weakSelf.phoneTextField.text.length == 0) {
                    [weakSelf.viewController showHint:@"请输入手机号"];
                }else{
                    [weakSelf getAuthCode];
                }
            }
        };
    }
    return _authCodeTextField;
}

-(ZJNGetAuthCodeTextField *)getCodeTextField{
    if (!_getCodeTextField) {
        _getCodeTextField = [[ZJNGetAuthCodeTextField alloc]init];
        _getCodeTextField.imageName = @"验证码";
        _getCodeTextField.placeholder = @"请输入短信验证码";
        if (@available(iOS 12.0, *)) {
            //Xcode 10 适配
            _getCodeTextField.textContentType = UITextContentTypeOneTimeCode;
            //非Xcode 10 适配
            _getCodeTextField.textContentType = @"one-time-code";
        }
        _getCodeTextField.delegate = self;
        __weak typeof(self) weakSelf = self;
        _getCodeTextField.getAutnCodeBlock = ^{
            [weakSelf getAuthCode];
        };
    }
    return _getCodeTextField;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton itemWithTitle:@"登录" titleColor:HexColor(0xb5ada5) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(loginBtnClick)];
        [_loginButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _loginButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _loginButton.userInteractionEnabled = NO;
    }
    return _loginButton;
}

-(UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [UIButton itemWithTitle:@"立即注册" titleColor:HexColor(yellowColor()) font:FontSize(14) target:self action:@selector(registerButtonClick)];
    }
    return _registerButton;
}
#pragma mark-判断手机号是否未注册
-(void)isRegistedPhone:(NSString *)phone{
    //首先判断该手机号是否已经被注册
    [self.viewController showHudInView:self hint:nil];
    NSDictionary *dic = @{@"phone":phone,@"districeId":@(self.areaId)};
    [[ZJNRequestManager sharedManager] postWithUrlString:PhoneIsRegister parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            if ([[data[@"data"][@"isRegister"] stringValue] isEqualToString:@"0"]) {
                //未注册
                [self.viewController showHint:@"用户不存在，请先注册"];
            }
            [self.phoneTextField resignFirstResponder];
        }else{
            //其他情况
            [self.viewController showHint:data[@"msg"]];
        }
        [self.viewController hideHud];
    } failure:^(NSError *error) {
        [self.phoneTextField resignFirstResponder];
        [self.viewController showHint:ErrorInfo];
        [self.viewController hideHud];
    }];
    
}
#pragma mark-登录按钮
-(void)loginBtnClick{
    if (self.phoneTextField.text.length == 0) {
        [[self viewController] showHint:@"请输入您的手机号码"];
        return;
    }else if (self.authCodeTextField.text.length == 0){
        [[self viewController] showHint:@"请输入手机号验证码"];
        return;
    }
    NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"code":self.getCodeTextField.text,@"qcellcoreId":@(self.areaId)};
    [[ZJNRequestManager sharedManager] postWithUrlString:ShortCutLogin parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            
            ZJNUserInfoModel *model = [ZJNUserInfoModel yy_modelWithJSON:data[@"data"][@"parents"]];
            model.IsRemind = data[@"data"][@"IsRemind"];
            model.chilSex = data[@"data"][@"chilSex"];
            model.chilName = data[@"data"][@"chilName"];
            model.chilPhoto = data[@"data"][@"chilPhoto"];
            [[ZJNTool shareManager] loginWithModel:model];
            [[ZJNFMDBManager shareManager] addCurrentUserInfoWithModel:model];
            [JPUSHService setAlias:model.id completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
            } seq:0];
            AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = [[ZJNNavigationController alloc]initWithRootViewController:[MainVC new]];
            
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        [[self viewController] showHint:ErrorInfo];
    }];
    
}
#pragma mark-注册按钮
-(void)registerButtonClick{
    ZJNRegisterViewController *viewC = [[ZJNRegisterViewController alloc]init];
    [self.viewController.navigationController pushViewController:viewC animated:YES];
}
#pragma mark-切换区号
-(void)leftButtonClick{
    ZJNCityListViewController *viewC = [[ZJNCityListViewController alloc]init];
    viewC.changeAreaCodeBlock = ^(ZJNCityModel *cityModel) {
        [self.phoneTextField.leftButton setTitle:[NSString stringWithFormat:@"+%@",cityModel.phonePrefix] forState:UIControlStateNormal];
        self.areaId = [cityModel.id integerValue];
        self.phoneTextField.areaCode = cityModel.id;
        self.phoneTextField.text = @"";
        [self.loginButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        self.loginButton.userInteractionEnabled = NO;
    };
    [self.viewController.navigationController pushViewController:viewC animated:YES];
}

#pragma mark-获取验证码
-(void)getAuthCode{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?phone=%@&qcellcoreId=%ld",Host,ShortcutLoginSend,self.phoneTextField.plainPhoneNum,(long)self.areaId];
    [[ZJNRequestManager sharedManager] getWithUrlString:urlStr success:^(id data) {
        NSLog(@"data:%@%s",data,__FUNCTION__);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            self.authCode = nil;
            [self.authCodeTextField removeFromSuperview];
            [UIView animateWithDuration:0.5 animations:^{
                [self layoutIfNeeded];
            }];
            self.getCodeTextField.begin = @"YES";
        }else{
            [self.authCodeTextField changeAuthImage];
        }
        [self.viewController showHint:data[@"msg"]];
    } failure:^(NSError *error) {
        [self.viewController showHint:ErrorInfo];
    }];
    
}
#pragma mark-输入框代理
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"点了一遍");
    if (textField == self.getCodeTextField) {
        
        if (textField.text.length >0) {
            if (self.authCode.length>0) {
                if ([self.authCode isEqualToString:textField.text]) {
                    self.authCode = textField.text;
                    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.loginButton.userInteractionEnabled = YES;
                }else{
                    [self.loginButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
                    self.loginButton.userInteractionEnabled = NO;
                    [self.viewController showHint:@"验证码错误!"];
                }
                return;
            }
            NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"code":textField.text,@"districeId":@(self.areaId)};
            [[ZJNRequestManager sharedManager] postWithUrlString:EfficacyCode parameters:dic success:^(id data) {
                NSLog(@"%@",data);
                if ([[data[@"code"] stringValue] isEqualToString:@"200"]){
                    self.authCode = textField.text;
                    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.loginButton.userInteractionEnabled = YES;
                }else{
                    [self.loginButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
                    self.loginButton.userInteractionEnabled = NO;
                    [self.viewController showHint:data[@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }else{
            [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.loginButton.userInteractionEnabled = NO;
        }
        
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (textField == self.authCodeTextField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            return NO;
        }
    }else if (textField == self.getCodeTextField){
        
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if ((textField.text.length + string.length - range.length == 6)) {
            NSString *code = [textField.text stringByAppendingString:string];
            textField.text = code;
            [textField resignFirstResponder];
            return YES;
        }else if (textField.text.length>=6){
            textField.text = [textField.text substringToIndex:6];
            [textField resignFirstResponder];
            return NO;
        }
    }
    return YES;
}
-(void)setPhone:(NSString *)phone{
    self.phoneTextField.text = phone;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
