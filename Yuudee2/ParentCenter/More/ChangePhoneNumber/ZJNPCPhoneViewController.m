//
//  ZJNPCPhoneViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPCPhoneViewController.h"
#import "ZJNPhoneTextField.h"
#import "ZJNRegisterAlertView.h"
//输入验证码页面
#import "ZJNRegisterVerifyCodeViewController.h"
//选择手机号归属地
#import "ZJNCityListViewController.h"
//输入验证码
#import "ZJNCPPutAuthCodeViewController.h"
//
#import "ZJNRegisterAlertView.h"
@interface ZJNPCPhoneViewController ()<ZJNRegisterAlertViewDelegate>
@property (nonatomic ,strong)UILabel *titleLabel;
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
//下一步按钮
@property (nonatomic ,strong)UIButton    *nextBtn;
//点击下一步按钮弹出提示框
@property (nonatomic ,strong)ZJNRegisterAlertView *alertView;
//新绑定的手机号已注册时弹框提示
@property (nonatomic ,assign)NSInteger phoneCode;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNPCPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = NO;
    self.homeBtn.hidden = YES;
    self.phoneCode = 1;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(190)+AddNav());
        make.centerX.equalTo(self.view);
        
    }];
    
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(35));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(25));
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
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(53));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(16)];
        _titleLabel.text = @"更换手机号码";
    }
    return _titleLabel;
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
        _phoneTextField.areaCode = [NSString stringWithFormat:@"%ld",(long)self.phoneCode];
        __weak typeof(self) weakSelf = self;
        _phoneTextField.inputErrorBlock = ^{
            [weakSelf showHint:@"输入错误"];
        };
        _phoneTextField.phoneBlack = ^(BOOL isValidate) {
            if (isValidate) {
                [weakSelf isRegistedPhone:weakSelf.phoneTextField.plainPhoneNum];
            }else{
                [weakSelf showHint:@"手机号格式输入错误"];
                [weakSelf.nextBtn setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
                weakSelf.nextBtn.userInteractionEnabled = NO;
            }
        };
    }
    return _phoneTextField;
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
        _alertView.rightBtnTitle = @"继续";
        _alertView.delegate = self;
    }
    return _alertView;
}
//判断手机号是否已注册
-(void)isRegistedPhone:(NSString *)phone{
    //首先判断该手机号是否已经被注册
    [self showHudInView:self.view hint:nil];
    NSDictionary *dic = @{@"phone":phone,@"districeId":@(self.phoneCode)};
    [[ZJNRequestManager sharedManager] postWithUrlString:PhoneIsRegister parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            if ([[data[@"data"][@"isRegister"] stringValue] isEqualToString:@"0"]) {
                //未注册
                [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.nextBtn.userInteractionEnabled = YES;
            }else{
                //已注册
                self.alertView.alertStr = @"该手机号已在本产品注册绑定，如果继续，原账号自动解绑。";
                self.alertView.alertType = ExistAlertType;
                [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
            }
            [self.phoneTextField resignFirstResponder];
        }else{
            //其他情况
            [self showHint:data[@"msg"]];
        }
        [self hideHud];
        
        if (self.success) {
            self.success(data);
        }
    } failure:^(NSError *error) {
        [self.phoneTextField resignFirstResponder];
        [self showHint:ErrorInfo];
        [self hideHud];
        
        if (self.failure) {
            self.failure(error);
        }
    }];
    
}
#pragma mark-下一步按钮点击实现方法
-(void)nextBtnClick{
    
    self.alertView.alertType = SliderAlertType;
    [self.phoneTextField resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
}

#pragma mark-提示框代理-ZJNRegisterAlertViewDelegate
//跳转到填验证码控制器
-(void)zjnRegisterAlertViewVerifySuccess{
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"qcellcoreId":@(self.phoneCode),@"type":@"4"};
    [[ZJNRequestManager sharedManager] postWithUrlString:SendCode parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            ZJNCPPutAuthCodeViewController *verifyCode = [[ZJNCPPutAuthCodeViewController alloc]init];
            verifyCode.phone = self.phoneTextField.plainPhoneNum;
            verifyCode.qcellcoreId = self.phoneCode;
            [self.navigationController pushViewController:verifyCode animated:YES];
        }else{
            [self showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self showHint:ErrorInfo];
    }];
    
}
//已注册继续替换
-(void)zjnRegisterAlertViewGoToLogin{
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.userInteractionEnabled = YES;
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
        self.phoneCode = [cityModel.id integerValue];
        self.phoneTextField.areaCode = cityModel.id;
        self.phoneTextField.text = @"";
        [self.nextBtn setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
    };
    [self.navigationController pushViewController:viewC animated:YES];
}

-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)testPhoneIsRegisterPhoneNum:(NSString *)phoneNum districeId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self viewDidLoad];
    [self nextBtnClick];
    [self changeBtnClick];
    self.success = success;
    self.failure = failure;
    self.phoneCode = disId;
    self.phoneTextField.plainPhoneNum = phoneNum;
    [self isRegistedPhone:phoneNum];
    [self zjnRegisterAlertViewVerifySuccess];
}

@end
