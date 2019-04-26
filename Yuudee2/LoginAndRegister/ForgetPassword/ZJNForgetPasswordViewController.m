//
//  ZJNForgetPasswordViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNForgetPasswordViewController.h"
#import "ZJNSlider.h"
#import "ZJNAreaPhoneTextField.h"
#import "ZJNPasswordTextField.h"
#import "ZJNChangePasswordSuccessView.h"
#import "ZJNGetAuthCodeTextField.h"
#import "ZJNCityListViewController.h"
@interface ZJNForgetPasswordViewController ()<UITextFieldDelegate>
//忘记密码
@property (nonatomic ,strong)UILabel *titleLabel;
//电话号
@property (nonatomic ,strong)ZJNAreaPhoneTextField *phoneTextField;
//滑块验证
@property (nonatomic ,strong)ZJNSlider *kSlider;
//
@property (nonatomic ,strong)UILabel *contentLabel;

//获取验证码
@property (nonatomic ,strong)ZJNGetAuthCodeTextField *getCodeTextField;
//输入密码
@property (nonatomic ,strong)ZJNPasswordTextField *passwordTextField;
//确认密码
@property (nonatomic ,strong)ZJNPasswordTextField *authPasswordTextField;
//确定按钮
@property (nonatomic ,strong)UIButton *okButton;
//
@property (nonatomic ,strong)ZJNChangePasswordSuccessView *successView;

@property (nonatomic ,assign)NSInteger areaId;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);

@end

@implementation ZJNForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.areaId = 1;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(190)+AddNav());
        make.centerX.equalTo(self.view);
        
    }];
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.kSlider];
    [self.kSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(43);
    }];
    
    _contentLabel = [UILabel createLabelWithTitle:@"向右拖动滑块验证" textColor:[UIColor whiteColor] font:FontSize(14) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    [self.view addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.kSlider);
        make.height.mas_equalTo(ScreenAdapter(20));
    }];
    
    [self.view addSubview:self.getCodeTextField];
    [self.getCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.kSlider.mas_right).offset(ScreenAdapter(54)).with.priority(300);
        make.left.equalTo(self.view).offset(ScreenAdapter(27)).with.priority(250);
        make.width.mas_equalTo(ScreenWidth()-ScreenAdapter(54));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getCodeTextField.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.authPasswordTextField];
    [self.authPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.authPasswordTextField.mas_bottom).offset(ScreenAdapter(55));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    
    [self.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTitle:@"忘记密码" textColor:RGBColor(19, 16, 29, 1) font:FontSize(16) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _titleLabel;
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
                [weakSelf showHint:@"输入有误"];
                weakSelf.kSlider.userInteractionEnabled = NO;
            }
        };
        _phoneTextField.areaBtnClickBlock = ^{
            [weakSelf changeAreaId];
        };
    }
    return _phoneTextField;
}

-(ZJNSlider *)kSlider{
    if (!_kSlider) {
        _kSlider = [[ZJNSlider alloc]init];
        _kSlider.userInteractionEnabled = NO;
        [_kSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _kSlider;
}

-(ZJNGetAuthCodeTextField *)getCodeTextField{
    if (!_getCodeTextField) {
        _getCodeTextField = [[ZJNGetAuthCodeTextField alloc]init];
        _getCodeTextField.imageName = @"验证码";
        _getCodeTextField.placeholder = @"请输入短信验证码";
        _getCodeTextField.delegate = self;
        __weak typeof(self) weakSelf = self;
        _getCodeTextField.getAutnCodeBlock = ^{
            [weakSelf getAutoCode];
        };
    }
    return _getCodeTextField;
}

-(ZJNPasswordTextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[ZJNPasswordTextField alloc]init];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.imageName = @"old-password";
        _passwordTextField.delegate = self;
        _passwordTextField.placeholder = @"请输入6-13位数字与字母组合";
    }
    return _passwordTextField;
}

-(ZJNPasswordTextField *)authPasswordTextField{
    if (!_authPasswordTextField) {
        _authPasswordTextField = [[ZJNPasswordTextField alloc]init];
        _authPasswordTextField.secureTextEntry = YES;
        _authPasswordTextField.delegate = self;
        _authPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _authPasswordTextField.imageName = @"old-password";
        _authPasswordTextField.placeholder = @"请再次确认新密码";
    }
    return _authPasswordTextField;
}

-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton itemWithTitle:@"确定" titleColor:HexColor(0xb5ada5) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(okBtnClick)];
        [_okButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _okButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _okButton.userInteractionEnabled = NO;
    }
    return _okButton;
}

-(ZJNChangePasswordSuccessView *)successView{
    if (!_successView) {
        _successView = [[ZJNChangePasswordSuccessView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenHeight())];
        __weak typeof(self) weakSelf = self;
        _successView.changePasswordBlock = ^{
            UIViewController *viewC = weakSelf.navigationController.viewControllers[1];
            [weakSelf.navigationController popToViewController:viewC animated:NO];
        };
    }
    return _successView;
}
//判断手机号是否已注册
-(void)isRegistedPhone:(NSString *)phone{
    //首先判断该手机号是否已经被注册
    [self showHudInView:self.view hint:nil];
    NSDictionary *dic = @{@"phone":phone,@"districeId":@(self.areaId)};
    [[ZJNRequestManager sharedManager] postWithUrlString:PhoneIsRegister parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            if ([[data[@"data"][@"isRegister"] stringValue] isEqualToString:@"0"]) {
                //未注册
                self.kSlider.userInteractionEnabled = NO;
                [self showHint:@"不存在此手机号，请重新注册"];
            }else{
                self.kSlider.userInteractionEnabled = YES;
            }
            [self.phoneTextField resignFirstResponder];
        }else{
            //其他情况
            self.kSlider.userInteractionEnabled = NO;
            [self showHint:data[@"msg"]];
        }
        [self hideHud];
        
        if (self.success) {
            self.success(data);
        }
    } failure:^(NSError *error) {
        self.kSlider.userInteractionEnabled = NO;
        [self.phoneTextField resignFirstResponder];
        [self showHint:ErrorInfo];
        [self hideHud];
        if (self.failure) {
            self.failure(error);
        }
    }];
    
}
#pragma mark-输入框代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    NSUInteger lengthOfString = string.length;//lengthOfString的值始终为1
    
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        
        unichar character = [string characterAtIndex:loopIndex];//将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        
        if (character < 48){
            [self showHint:@"请输入6-13位数组或字母组合"];
            return NO;//48 unichar for 0
        }
        
        if (character > 57 && character < 65){
            [self showHint:@"请输入6-13位数组或字母组合"];
            return NO; //
        }
        
        if (character > 90 && character < 97){
            [self showHint:@"请输入6-13位数组或字母组合"];
            return NO;
        }
        
        if (character > 122){
            [self showHint:@"请输入6-13位数组或字母组合"];
            return NO;
        }
        
    }
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }else if (textField.text.length >= 13) {
        textField.text = [textField.text substringToIndex:13];
        return NO;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.passwordTextField) {
        if (textField.text.length<6) {
            [self showHint:@"请输入至少6位密码"];
        }else{
            BOOL varify = [NSString ValidatePassword:textField.text];
            if (!varify) {
                textField.text = @"";
                [self showHint:@"请输入6-13位数字与字母组合"];
            }
        }
    }else if (textField == self.getCodeTextField){
        if (textField == self.getCodeTextField && textField.text.length > 0) {
            if (textField.text.length >0) {
                NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"code":textField.text,@"districeId":@(self.areaId)};
                [[ZJNRequestManager sharedManager] postWithUrlString:EfficacyCode parameters:dic success:^(id data) {
                    NSLog(@"%@",data);
                    if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
                        [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        self.okButton.userInteractionEnabled = YES;
                    }else{
                        [self showHint:data[@"msg"]];
                    }
                } failure:^(NSError *error) {

                }];
            }else{
                [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.okButton.userInteractionEnabled = NO;
            }
        }
    }
}
#pragma mark-滑块验证
-(void)sliderValueChanged:(ZJNSlider *)slider{
    NSLog(@"%f",slider.value);
    if (slider.value<1) {
        [slider setThumbImage:SetImage(@"sign_icon_right") forState:UIControlStateNormal];
        return;
    }else{
        [slider setThumbImage:SetImage(@"sign_state_ok") forState:UIControlStateNormal];
        [self.contentLabel removeFromSuperview];
        [self.kSlider removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.getCodeTextField.begin = @"YES";
        [self getAutoCode];
    }
}
#pragma mark-获取验证码
-(void)getAutoCode{
    NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"qcellcoreId":@(self.areaId),@"type":@"1"};
    [[ZJNRequestManager sharedManager] postWithUrlString:SendCode parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        [self showHint:data[@"msg"]];
        if (self.success) {
            self.success(data);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showHint:ErrorInfo];
        if (self.failure) {
            self.failure(error);
        }
    }];
}
#pragma mark-确定
-(void)okBtnClick{
    if (self.phoneTextField.text.length == 0) {
        [self showHint:@"请输入手机号码"];
        return;
    }else if (self.getCodeTextField.text.length == 0){
        [self showHint:@"请输入短信验证码"];
        return;
    }else if (self.passwordTextField.text.length == 0||self.passwordTextField.text.length<6){
        [self showHint:@"请输入6-13位数字与字母组合"];
        return;
    }else if (self.authPasswordTextField.text.length == 0){
        [self showHint:@"请再次确认新密码"];
        return;
    }else if (![self.passwordTextField.text isEqualToString:self.authPasswordTextField.text]) {
        [self showHint:@"两次密码输入不一致"];
        return;
    }
    [self changePassword];
}
-(void)changePassword{
    NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"code":self.getCodeTextField.text,@"password":self.passwordTextField.text};
    [[ZJNRequestManager sharedManager] postWithUrlString:ResetPassword parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.successView];
        }else{
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
#pragma mark-homeBtn
-(void)homeBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-更换区号
-(void)changeAreaId{
    ZJNCityListViewController *listVC = [[ZJNCityListViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    listVC.changeAreaCodeBlock = ^(ZJNCityModel *cityModel) {
        [weakSelf.phoneTextField.leftButton setTitle:cityModel.phonePrefix forState:UIControlStateNormal];
        weakSelf.areaId = [cityModel.id integerValue];
        self.phoneTextField.areaCode = cityModel.id;
        self.phoneTextField.text = @"";
        self.kSlider.userInteractionEnabled = NO;
    };
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)testUpdatePhoneIsRegister:(NSString *)phoneNum districeId:(NSInteger)code success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
    self.areaId = code;
    [self isRegistedPhone:phoneNum];
}

- (void)testResetPassword:(NSString *)phoneNum code:(NSString *)code psw:(NSString *)psw success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    self.success = success;
    self.failure = failure;
    self.phoneTextField.plainPhoneNum = phoneNum;
    self.phoneTextField.text = phoneNum;
    self.getCodeTextField.text = code;
    self.passwordTextField.text = psw;
    self.authPasswordTextField.text = psw;
    [self changeAreaId];
    [self okBtnClick];
}

- (void)testSendCode:(NSString *)phoneNum districeId:(NSInteger )code
             success:(void (^) (id json))success
             failure:(void (^)(NSError *error))failure{
    self.success = success;
    self.failure = failure;
    self.areaId = code;
    self.phoneTextField.plainPhoneNum = phoneNum;
    [self sliderValueChanged:nil];
    [self getAutoCode];
}


@end
