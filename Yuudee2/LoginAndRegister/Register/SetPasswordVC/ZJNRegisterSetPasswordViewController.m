//
//  ZJNRegisterSetPasswordViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/1.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterSetPasswordViewController.h"
#import "ZJNPasswordTextField.h"
#import "ZJNRegisterSuccessAlertView.h"
//#import "ZJNParentCenterViewController.h"
#import "ZJNPerfectInfoViewController.h"
//#import <JPUSHService.h>
@interface ZJNRegisterSetPasswordViewController ()<UITextFieldDelegate>
//顶部label
@property (nonatomic ,strong)UILabel              *titleLabel;
//输入登录密码
@property (nonatomic ,strong)ZJNPasswordTextField *topPhoneTF;
//确认登录密码
@property (nonatomic ,strong)ZJNPasswordTextField *bottomPhoneTF;
//确认按钮
@property (nonatomic ,strong)UIButton             *OKBtn;
//注册成功弹出
@property (nonatomic ,strong)ZJNRegisterSuccessAlertView *successAlertView;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNRegisterSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubviews];
    [self.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)setUpSubviews{
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(193)+AddNav());
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.topPhoneTF];
    [self.topPhoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
        
    }];
    
    [self.view addSubview:self.bottomPhoneTF];
    [self.bottomPhoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.top.equalTo(self.topPhoneTF.mas_bottom).offset(ScreenAdapter(21));
        make.height.mas_equalTo(ScreenAdapter(43));
        
    }];
    
    [self.view addSubview:self.OKBtn];
    [self.OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bottomPhoneTF.mas_bottom).offset(ScreenAdapter(45));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
        
    }];
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTitle:@"请输入登录密码" textColor:[UIColor colorWithHex:0x000000] font:FontSize(16) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _titleLabel;
}
-(ZJNPasswordTextField *)topPhoneTF{
    if (!_topPhoneTF) {
        _topPhoneTF = [[ZJNPasswordTextField alloc]init];
        _topPhoneTF.delegate = self;
        _topPhoneTF.secureTextEntry = YES;
        _topPhoneTF.keyboardType = UIKeyboardTypeASCIICapable;
        _topPhoneTF.imageName = @"old-password";
        _topPhoneTF.placeholder = @"请输入6-13位数组或字母组合";
        [_topPhoneTF addTarget:self action:@selector(topPhoneTFValueChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _topPhoneTF;
}
-(ZJNPasswordTextField *)bottomPhoneTF{
    if (!_bottomPhoneTF) {
        _bottomPhoneTF = [[ZJNPasswordTextField alloc]init];
        _bottomPhoneTF.delegate = self;
        _bottomPhoneTF.secureTextEntry = YES;
        _bottomPhoneTF.keyboardType = UIKeyboardTypeASCIICapable;
        _bottomPhoneTF.imageName = @"old-password";
        _bottomPhoneTF.placeholder = @"请再次确认密码";
        [_bottomPhoneTF addTarget:self action:@selector(bottomPhoneTFValueChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _bottomPhoneTF;
}
-(UIButton *)OKBtn{
    if (!_OKBtn) {
        _OKBtn = [UIButton itemWithTitle:@"完成" titleColor:HexColor(0xffffff) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(okBtnClick)];
        [_OKBtn setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _OKBtn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
    }
    return _OKBtn;
}
-(ZJNRegisterSuccessAlertView *)successAlertView{
    if (!_successAlertView) {
        _successAlertView = [[ZJNRegisterSuccessAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenHeight())];
        __weak typeof(self) weakSelf = self;
        _successAlertView.perfectChildInfoBlock = ^{
            
            [weakSelf login];
        };
    }
    return _successAlertView;
}
#pragma mark-注册成功后直接登录
-(void)login{
    NSDictionary *dic = @{@"qcellcoreId":@(self.requestModel.districeId),@"phone":self.requestModel.phone,@"password":self.topPhoneTF.text};
    [self showHudInView:self.view hint:nil];
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
            ZJNPerfectInfoViewController *viewC = [[ZJNPerfectInfoViewController alloc]init];
            viewC.pushFrom = @"register";
            [self.navigationController pushViewController:viewC animated:YES];

        }else{
            [self showHint:data[@"msg"]];
        }
        [self hideHud];
        if (self.success) {
            self.success(data);
        }
    } failure:^(NSError *error) {
        [self showHint:ErrorInfo];
        [self hideHud];
        NSLog(@"%@",error);
        if (self.failure) {
            self.failure(error);
        }
    }];
}

#pragma mark-完成按钮点击实现方法
-(void)okBtnClick{
    if (self.topPhoneTF.text.length == 0) {
        [self showHint:@"请先输入密码"];
        return;
    }else if (self.topPhoneTF.text.length<6){
        [self showHint:@"请输入至少6位密码"];
        return;
    }
    if (self.bottomPhoneTF.text.length == 0) {
        [self showHint:@"请输入确认密码"];
        return;
    }
    if ([self.topPhoneTF.text isEqualToString:self.bottomPhoneTF.text]) {
        [self.view endEditing:YES];
        //两次密码匹配,调注册按钮
        [self regist];
        
    }else{
        [self showHint:@"两次密码输入不一致"];
    }
}
-(void)regist{
    NSDictionary *dic = @{@"phone":self.requestModel.phone,@"password":self.topPhoneTF.text,@"qcellcoreId":@(self.requestModel.districeId)};
    [[ZJNRequestManager sharedManager] postWithUrlString:Register parameters:dic success:^(id data) {
        
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.successAlertView];
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
#pragma mark-输入密码
-(void)topPhoneTFValueChanged{}

#pragma mark-验证密码
-(void)bottomPhoneTFValueChanged{}

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
    }else if (textField.text.length >= 13) {
        textField.text = [textField.text substringToIndex:13];
        return NO;
    }
    return YES;
}
//验证密码是否符合要求
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.topPhoneTF) {
        
        if (textField.text.length<6) {
            [self showHint:@"请输入至少6位密码"];
            return;
        }
        BOOL verify = [NSString ValidatePassword:textField.text];
        if (!verify) {
            textField.text = @"";
            [self showHint:@"请输入6-13位数字或字母"];
        }
    }
}

#pragma mark-返回上个页面
-(void)homeBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setRequestModel:(ZJNRequestModel *)requestModel{
    _requestModel = requestModel;
}

- (void)testGeneralLogin:(NSString *)phoneNum disId:(NSInteger )disId psw:(NSString *)psw
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure{
    self.requestModel.districeId = disId;
    self.requestModel.phone = phoneNum;
    self.topPhoneTF.text = psw;
    self.success = success;
    self.failure = failure;
    [self login];
    [self homeBtnClick];
}

- (void)testRegister:(NSString *)phoneNum disId:(NSInteger )disId psw:(NSString *)psw
                 success:(void (^) (id json))success
                 failure:(void (^)(NSError *error))failure{
    [self viewDidLoad];
    self.requestModel.districeId = disId;
    self.requestModel.phone = phoneNum;
    self.topPhoneTF.text = psw;
    self.bottomPhoneTF.text = psw;
    self.success = success;
    self.failure = failure;
    [self okBtnClick];
}

@end
