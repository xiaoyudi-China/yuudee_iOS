//
//  ChangePhoneNumberViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ChangePhoneNumberViewController.h"
#import "ZJNAreaPhoneTextField.h"
#import "ZJNCPGetAuthCodeViewController.h"
#import "ZJNCityListViewController.h"
@interface ChangePhoneNumberViewController ()
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)ZJNAreaPhoneTextField *phoneTextField;
@property (nonatomic ,strong)UIButton *okButton;
@property (nonatomic ,assign)NSInteger phoneCode;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ChangePhoneNumberViewController

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
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScreenAdapter(55));
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
-(ZJNAreaPhoneTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[ZJNAreaPhoneTextField alloc]init];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder = @"请输入当前账户绑定手机号码";
        _phoneTextField.areaCode = [NSString stringWithFormat:@"%ld",(long)self.phoneCode];
        __weak typeof(self) weakSelf = self;
        _phoneTextField.phoneBlack = ^(BOOL isValidate) {
            if (isValidate) {
                if ([weakSelf.phoneTextField.plainPhoneNum isEqualToString:weakSelf.currentPhone]) {
                    [weakSelf.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    weakSelf.okButton.userInteractionEnabled = YES;
                }else{
                    [weakSelf showHint:@"已绑定手机号输入错误，请重新输入"];
                }
                
            }else{
                [weakSelf showHint:@"手机号格式错误"];
                [weakSelf.okButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
                weakSelf.okButton.userInteractionEnabled = NO;
            }
        };
        _phoneTextField.areaBtnClickBlock = ^{
            [weakSelf leftButtonClick];
        };
//        [_phoneTextField.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneTextField;
}

-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton itemWithTitle:@"验证" titleColor:HexColor(0xb5ada5) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(okBtnClick)];
        [_okButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _okButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _okButton.userInteractionEnabled = NO;
    }
    return _okButton;
}

#pragma mark-确定按钮
-(void)okBtnClick{
    if (self.phoneTextField.text.length==0) {
        [self showHint:@"请输入当前账户绑定手机号码"];
        return;
    }
    NSDictionary *dic = @{@"phone":self.phoneTextField.plainPhoneNum,@"qcellcoreId":@(self.phoneCode),@"type":@"3"};
    [[ZJNRequestManager sharedManager] postWithUrlString:SendCode parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            ZJNCPGetAuthCodeViewController *viewC = [[ZJNCPGetAuthCodeViewController alloc]init];
            viewC.phoneCode = self.phoneCode;
            viewC.phone = self.phoneTextField.plainPhoneNum;
            viewC.areaCode = self.phoneTextField.leftButton.titleLabel.text;
            [self.navigationController pushViewController:viewC animated:YES];
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
-(void)getCode{
    
}
#pragma mark-返回按钮
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-切换区号
-(void)leftButtonClick{
    ZJNCityListViewController *viewC = [[ZJNCityListViewController alloc]init];
    viewC.changeAreaCodeBlock = ^(ZJNCityModel *cityModel) {
        [self.phoneTextField.leftButton setTitle:[NSString stringWithFormat:@"+%@",cityModel.phonePrefix] forState:UIControlStateNormal];
        self.phoneCode = [cityModel.id integerValue];
        self.phoneTextField.areaCode = cityModel.id;
        self.phoneTextField.text = @"";
        [self.okButton setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        self.okButton.userInteractionEnabled = NO;
    };
    [self.navigationController pushViewController:viewC animated:YES];
}
-(void)setCurrentPhone:(NSString *)currentPhone{
    _currentPhone = currentPhone;
}

- (void)testSendCode:(NSString *)phoneNum phoneCode:(NSInteger )code
             success:(void (^) (id json))success
             failure:(void (^)(NSError *error))failure{
    self.phoneTextField.plainPhoneNum = phoneNum;
    self.phoneTextField.text = phoneNum;
    self.phoneCode = code;
    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
    [self okBtnClick];
}

@end
