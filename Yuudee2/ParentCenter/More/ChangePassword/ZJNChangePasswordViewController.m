//
//  ZJNChangePasswordViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNChangePasswordViewController.h"
#import "ZJNPasswordTextField.h"
@interface ZJNChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UILabel *titleLabel;
//旧密码
@property (nonatomic ,strong)ZJNPasswordTextField *oldPswTF;
//新密码
@property (nonatomic ,strong)ZJNPasswordTextField *freshPswTF;
//确认新密码
@property (nonatomic ,strong)ZJNPasswordTextField *beSureNewPswTF;
//确认按钮
@property (nonatomic ,strong)UIButton *okButton;

//记录三个输入框的填写状态
@property (nonatomic ,assign)NSInteger ops;
@property (nonatomic ,assign)NSInteger nps;
@property (nonatomic ,assign)NSInteger bps;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ops = 0;
    self.nps = 0;
    self.bps = 0;
    self.backBtn.hidden = NO;
    self.homeBtn.hidden = YES;
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(190)+AddNav());
        make.centerX.equalTo(self.view);
        
    }];
    
    [self.view addSubview:self.oldPswTF];
    [self.oldPswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.freshPswTF];
    [self.freshPswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldPswTF.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.beSureNewPswTF];
    [self.beSureNewPswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.freshPswTF.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.beSureNewPswTF.mas_bottom).offset(ScreenAdapter(55));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(16)];
        _titleLabel.text = @"修改密码";
    }
    return _titleLabel;
}

-(ZJNPasswordTextField *)oldPswTF{
    if (!_oldPswTF) {
        _oldPswTF = [[ZJNPasswordTextField alloc]init];
        _oldPswTF.delegate = self;
        _oldPswTF.imageName = @"old-password";
        _oldPswTF.placeholder = @"请输入当前密码";
    }
    return _oldPswTF;
}

-(ZJNPasswordTextField *)freshPswTF{
    if (!_freshPswTF) {
        _freshPswTF = [[ZJNPasswordTextField alloc]init];
        _freshPswTF.delegate = self;
        _freshPswTF.imageName = @"new-password";
        _freshPswTF.placeholder = @"请输入新密码（6-13位数字或字母组合）";
    }
    return _freshPswTF;
}

-(ZJNPasswordTextField *)beSureNewPswTF{
    if (!_beSureNewPswTF) {
        _beSureNewPswTF = [[ZJNPasswordTextField alloc]init];
        _beSureNewPswTF.delegate = self;
        _beSureNewPswTF.imageName = @"confirm-password";
        _beSureNewPswTF.placeholder = @"请再次确认新密码";
    }
    return _beSureNewPswTF;
}

-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton itemWithTitle:@"确认提交" titleColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(okBtnClick)];
        [_okButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _okButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _okButton.userInteractionEnabled = NO;
        [_okButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
    }
    return _okButton;
}
#pragma mark-输入框代理方法

//限定输入长度
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
    }
    if (textField.text.length >= 13) {
        textField.text = [textField.text substringToIndex:13];
        return NO;
    }
    
    return YES;
}
//验证密码是否符合要求
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.oldPswTF) {
        if (textField.text.length == 0) {
            self.ops = 0;
        }else{
            self.ops = 1;
        }
    }
    if (textField == self.beSureNewPswTF) {
        if (textField.text.length == 0) {
            self.bps = 0;
        }else{
            self.bps = 1;
        }
    }
    if (textField == self.freshPswTF) {
        if (textField.text.length == 0) {
            self.nps = 0;
        }else{
            self.nps = 1;
        }
    }
    if (textField == self.freshPswTF) {
        if (textField.text.length<6) {
            [self showHint:@"请输入至少6位密码"];
            return;
        }
        BOOL verify = [NSString ValidatePassword:textField.text];
        if (!verify) {
            textField.text = @"";
            [self showHint:@"请输入6-13位数字或字母组合"];
        }
    }
}
#pragma mark-确定按钮
-(void)okBtnClick{
    if (self.oldPswTF.text.length == 0) {
        [self showHint:@"请输入当前密码"];
        return;
    }else if (self.freshPswTF.text.length == 0){
        [self showHint:@"请输入新密码"];
        return;
    }else if (self.freshPswTF.text.length<6){
        [self showHint:@"请输入至少6位密码"];
        return;
    }else if (self.beSureNewPswTF.text.length == 0){
        [self showHint:@"请再次确认新密码"];
        return;
    }
    if (![self.freshPswTF.text isEqualToString:self.beSureNewPswTF.text]) {
        [self showHint:@"新密码两次输入不一致，请重新输入"];
        return;
    }
    NSDictionary *dic = @{@"token":self.token,@"oldPassword":self.oldPswTF.text,@"newPassword":self.freshPswTF.text};
    [[ZJNRequestManager sharedManager] postWithUrlString:ChangePassword parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
//            AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
//            delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[ZJNLoginAndRegisterViewController new]];
            [self showHint:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark-返回按钮
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setToken:(NSString *)token{
    _token = token;
}
-(void)setCount:(NSInteger)count{
    if (count == 3) {
        NSLog(@"按钮点亮");
    }else{
        NSLog(@"按钮置灰");
    }
}
-(void)setOps:(NSInteger)ops{
    _ops = ops;
    if (self.nps==1 && self.bps==1 && ops == 1) {
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.userInteractionEnabled = YES;
    }else{
        [_okButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        _okButton.userInteractionEnabled = NO;
    }
}
-(void)setNps:(NSInteger)nps{
    _nps = nps;
    if (nps==1 && self.bps==1 && self.ops == 1) {
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.userInteractionEnabled = YES;
    }else{
        [_okButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        _okButton.userInteractionEnabled = NO;
    }
}
-(void)setBps:(NSInteger)bps{
    _bps = bps;
    if (self.nps==1 && bps==1 && self.ops == 1) {
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.userInteractionEnabled = YES;
    }else{
        [_okButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        _okButton.userInteractionEnabled = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)testFunction {
    [self viewDidLoad];

    [self textField:self.oldPswTF shouldChangeCharactersInRange:NSMakeRange(1, 1) replacementString:@"1"];
    [self textFieldDidEndEditing:self.oldPswTF];
    [self textFieldDidEndEditing:self.beSureNewPswTF];
    self.freshPswTF.text = @"";
    [self textFieldDidEndEditing:self.freshPswTF];
    self.freshPswTF.text = @"12345";
    [self textFieldDidEndEditing:self.freshPswTF];
    
    self.ops = 1;
    self.nps = 1;
    self.bps = 1;
    self.oldPswTF.text = @"";
    [self okBtnClick];
    self.freshPswTF.text = @"";
    [self okBtnClick];
    self.freshPswTF.text = @"123";
    [self okBtnClick];
    self.beSureNewPswTF.text = @"";
    [self okBtnClick];
    self.freshPswTF.text = @"123456";
    self.beSureNewPswTF.text = @"123";
    [self okBtnClick];
}

- (void)testOldPassword:(NSString *)token oldPsw:(NSString *)oldPsw newPsw:(NSString *)newPsw success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
    self.token = token;
    self.oldPswTF.text = oldPsw;
    self.freshPswTF.text = newPsw;
    self.beSureNewPswTF.text = newPsw;
    [self okBtnClick];

}

@end
