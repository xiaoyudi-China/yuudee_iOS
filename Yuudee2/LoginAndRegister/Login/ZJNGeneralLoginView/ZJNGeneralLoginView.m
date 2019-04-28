//
//  ZJNGeneralLoginView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/7.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//gzpmark登录

#import "ZJNGeneralLoginView.h"
#import "ZJNAreaPhoneTextField.h"
#import "ZJNPasswordTextField.h"
//注册页面
#import "ZJNRegisterViewController.h"
//忘记密码
#import "ZJNForgetPasswordViewController.h"
//手机号归属地
#import "ZJNCityListViewController.h"
#import "ZJNUserInfoModel.h"
//#import <JPUSHService.h>
@interface ZJNGeneralLoginView()<UITextFieldDelegate>
@property (nonatomic ,strong)ZJNAreaPhoneTextField *phoneTextField;
@property (nonatomic ,strong)ZJNPasswordTextField *passwordTextField;
//登录按钮
@property (nonatomic ,strong)UIButton          *loginButton;
//注册按钮
@property (nonatomic ,strong)UIButton          *registerButton;
//忘记密码按钮
@property (nonatomic ,strong)UIButton          *fpButton;
//电话号归属地
@property (nonatomic ,assign)NSInteger phoneCode;

@end
@implementation ZJNGeneralLoginView
-(id)init{
    self = [super init];
    if (self) {
        _phoneCode = 1;
        [self addSubview:self.phoneTextField];
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(27));
            make.right.equalTo(self).offset(-ScreenAdapter(27));
            make.top.equalTo(self).offset(ScreenAdapter(37));
            make.height.mas_equalTo(ScreenAdapter(43));
        }];
        
        [self addSubview:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(27));
            make.right.equalTo(self).offset(-ScreenAdapter(27));
            make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(20));
            make.height.mas_equalTo(ScreenAdapter(43));
        }];
        
        [self addSubview:self.loginButton];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(ScreenAdapter(100));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
        }];
        
        [self addSubview:self.registerButton];
        [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginButton.mas_bottom).offset(10);
            make.left.equalTo(self.loginButton).offset(15);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(60), ScreenAdapter(30)));
        }];
        
        [self addSubview:self.fpButton];
        [self.fpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginButton.mas_bottom).offset(10);
            make.right.equalTo(self.loginButton).offset(-15);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(60), ScreenAdapter(30)));
        }];
    }
    return self;
}

-(ZJNAreaPhoneTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[ZJNAreaPhoneTextField alloc]init];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.areaCode = [NSString stringWithFormat:@"%ld",self.phoneCode];
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

-(ZJNPasswordTextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[ZJNPasswordTextField alloc]init];
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.imageName = @"old-password";
        _passwordTextField.placeholder = @"请输入密码";
        [_passwordTextField addTarget:self action:@selector(bottomPhoneTFValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
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

-(UIButton *)fpButton{
    if (!_fpButton) {
        _fpButton = [UIButton itemWithTitle:@"忘记密码" titleColor:HexColor(yellowColor()) font:FontSize(14) target:self action:@selector(fpButtonClick)];
    }
    return _fpButton;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    NSUInteger lengthOfString = string.length;//lengthOfString的值始终为1
    
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        
        unichar character = [string characterAtIndex:loopIndex];//将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        
        if (character < 48) return NO;//48 unichar for 0
        
        if (character > 57 && character < 65) return NO; //
        
        if (character > 90 && character < 97) return NO;
        
        if (character > 122) return NO;
        
    }
    if (range.length == 1 && string.length == 0) {
        return YES;
    }else if (textField.text.length >= 13) {
        textField.text = [textField.text substringToIndex:13];
        return NO;
    }
    return YES;
}
-(void)bottomPhoneTFValueChanged:(UITextField *)textField{
    BOOL isVerify = [NSString ValidatePassword:textField.text];
    if (isVerify) {
        self.loginButton.userInteractionEnabled = YES;
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
#pragma mark-判断手机号是否未注册
-(void)isRegistedPhone:(NSString *)phone{
    //首先判断该手机号是否已经被注册
    [self.viewController showHudInView:self hint:nil];
    NSDictionary *dic = @{@"phone":phone,@"districeId":@(self.phoneCode)};
    [[ZJNRequestManager sharedManager] postWithUrlString:PhoneIsRegister parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            if ([[data[@"data"][@"isRegister"] stringValue] isEqualToString:@"0"]) {
                //未注册
                [self.viewController showHint:@"用户不存在，请先注册"];
                [self.phoneTextField resignFirstResponder];
            }else{
                //已注册
                [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.loginButton.userInteractionEnabled = YES;
                [self.phoneTextField resignFirstResponder];
            }
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
    if (self.phoneTextField.text.length==0) {
        [self.viewController showHint:@"请输入正确的手机号"];
        return;
    }
    
    NSDictionary *dic = @{@"qcellcoreId":@(self.phoneCode),@"phone":self.phoneTextField.plainPhoneNum,@"password":self.passwordTextField.text};
    [[ZJNRequestManager sharedManager] postWithUrlString:GeneralLogin parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            
            ZJNUserInfoModel *model = [ZJNUserInfoModel yy_modelWithJSON:data[@"data"][@"parents"]];
            model.IsRemind = data[@"data"][@"IsRemind"];
            model.chilSex = data[@"data"][@"chilSex"];
            model.chilName = data[@"data"][@"chilName"];
            model.chilPhoto = data[@"data"][@"chilPhoto"];
            [[ZJNTool shareManager] loginWithModel:model];
            [[ZJNFMDBManager shareManager] addCurrentUserInfoWithModel:model];
//            [JPUSHService setAlias:model.id completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
//            } seq:0];
            AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = [[ZJNNavigationController alloc]initWithRootViewController:[MainVC new]];;
        }else if ([[data[@"code"] stringValue] isEqualToString:@"201"]){
            [self.viewController showHint:@"用户名与密码不一致，请重新输入"];
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.viewController showHint:ErrorInfo];
        NSLog(@"%@",error);
    }];
}
#pragma mark-注册按钮
-(void)registerButtonClick{
    ZJNRegisterViewController *viewC = [[ZJNRegisterViewController alloc]init];
    [self.viewController.navigationController pushViewController:viewC animated:YES];
}
#pragma mark-忘记密码
-(void)fpButtonClick{
    ZJNForgetPasswordViewController *viewC = [[ZJNForgetPasswordViewController alloc]init];
    [self.viewController.navigationController pushViewController:viewC animated:YES];
}
#pragma mark-切换区号
-(void)leftButtonClick{
    ZJNCityListViewController *viewC = [[ZJNCityListViewController alloc]init];
    viewC.changeAreaCodeBlock = ^(ZJNCityModel *cityModel) {
        [self.phoneTextField.leftButton setTitle:[NSString stringWithFormat:@"+%@",cityModel.phonePrefix] forState:UIControlStateNormal];
        self.phoneCode = [cityModel.id integerValue];
        self.phoneTextField.areaCode = cityModel.id;
        self.phoneTextField.text = @"";
        [self.loginButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        self.loginButton.userInteractionEnabled = NO;
    };
    [self.viewController.navigationController pushViewController:viewC animated:YES];
}

@end
