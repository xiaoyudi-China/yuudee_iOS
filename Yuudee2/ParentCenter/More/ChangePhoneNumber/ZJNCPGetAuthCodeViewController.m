//
//  ZJNCPGetAuthCodeViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNCPGetAuthCodeViewController.h"
#import "ZJNGetAuthCodeTextField.h"
#import "ZJNPCPhoneViewController.h"
@interface ZJNCPGetAuthCodeViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)ZJNGetAuthCodeTextField *getCodeTextField;
@property (nonatomic ,strong)UILabel *phoneLabel;
@property (nonatomic ,strong)UIButton *nextBtn;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNCPGetAuthCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = NO;
    self.homeBtn.hidden = YES;
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(190)+AddNav());
        make.centerX.equalTo(self.view);
        
    }];
    
    [self.view addSubview:self.getCodeTextField];
    [self.getCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(25));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.width.mas_equalTo(ScreenWidth()-ScreenAdapter(54));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getCodeTextField.mas_bottom).offset(ScreenAdapter(10));
        make.right.equalTo(self.getCodeTextField);
    }];
    
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.getCodeTextField.mas_bottom).offset(ScreenAdapter(100));
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

-(ZJNGetAuthCodeTextField *)getCodeTextField{
    if (!_getCodeTextField) {
        _getCodeTextField = [[ZJNGetAuthCodeTextField alloc]init];
        _getCodeTextField.imageName = @"验证码";
        _getCodeTextField.placeholder = @"请输入短信验证码";
        _getCodeTextField.delegate = self;
        __weak typeof(self) weakSelf = self;
        _getCodeTextField.getAutnCodeBlock = ^{
            [weakSelf getCode];
        };
        [_getCodeTextField addTarget:self action:@selector(EditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _getCodeTextField;
}

-(UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel createLabelWithTextColor:RGBColor(180, 174, 165, 1) font:FontSize(14)];
    }
    return _phoneLabel;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton itemWithTitle:@"下一步" titleColor:HexColor(0xb5ada5) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(nextBtnClick)];
        [_nextBtn setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _nextBtn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _nextBtn.userInteractionEnabled = NO;
    }
    return _nextBtn;
}
#pragma mark-获取验证码
-(void)getCode{
    NSDictionary *dic = @{@"phone":self.phone,@"qcellcoreId":@(self.phoneCode),@"type":@"3"};
    [[ZJNRequestManager sharedManager] postWithUrlString:SendCode parameters:dic success:^(id data) {
        [self showHint:data[@"msg"]];
    } failure:^(NSError *error) {
        [self showHint:ErrorInfo];
    }];
}
#pragma mark-下一步
-(void)nextBtnClick{
    NSDictionary *dic = @{@"phone":self.phone,@"districeId":@(self.phoneCode),@"code":self.getCodeTextField.text};
    [[ZJNRequestManager sharedManager] postWithUrlString:EfficacyCode parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            [self showHint:@"验证正确"];
            ZJNPCPhoneViewController *viewC = [[ZJNPCPhoneViewController alloc]init];
            [self.navigationController pushViewController:viewC animated:YES];
        }else if ([[data[@"code"] stringValue] isEqualToString:@"202"]){
            [self showHint:@"验证错误"];
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

-(void)setPhone:(NSString *)phone{
    _phone = phone;
}
-(void)setPhoneCode:(NSInteger)phoneCode{
    _phoneCode = phoneCode;
}
-(void)setAreaCode:(NSString *)areaCode{
    _areaCode = areaCode;
    NSString *hidePhone = [NSString changePhontNumber:self.phone];
    self.phoneLabel.text = [NSString stringWithFormat:@"短信验证码已发送至%@ %@",areaCode,hidePhone];
    
    
    self.getCodeTextField.begin = @"s";
}
-(void)EditChanged:(UITextField *)textField{
    if (textField.text.length>0) {
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = YES;
    }else{
        [self.nextBtn setTitleColor:HexColor(0xb5ada5) forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
    }
}

-(void )testHeaderView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), 100)];
    UILabel *subTitleLabel = [UILabel createLabelWithTitle:@"问卷评估" textColor:HexColor(yellowColor()) font:FontWeight(22, UIFontWeightHeavy) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    [bgView addSubview:subTitleLabel];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.numberOfLines = 0;
    UIColor *co0 = [UIColor grayColor];
    subTitleLabel.textColor = co0;
    subTitleLabel.layer.masksToBounds = YES;
    CGFloat rad0 = 8.f;
    CGFloat borderWidth0 = 1.f;
    subTitleLabel.layer.cornerRadius = rad0;
    subTitleLabel.layer.borderWidth = borderWidth0;
    UIColor *borColor0 = [UIColor redColor];
    subTitleLabel.layer.borderColor = borColor0.CGColor;
    subTitleLabel.x = 30;
    subTitleLabel.y= 60;
    subTitleLabel.width = 320;
    subTitleLabel.height = 30;
    
    UILabel *titleLabel = [UILabel createLabelWithTitle:@"让我们一起来客观评测孩子的进步！" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentCenter numberOfLines:0];
    [bgView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    UIColor *col = [UIColor grayColor];
    titleLabel.textColor = col;
    titleLabel.layer.masksToBounds = YES;
    CGFloat rad01 = 8.f;
    CGFloat borderWidth01 = 1.f;
    titleLabel.layer.cornerRadius = rad01;
    titleLabel.layer.borderWidth = borderWidth01;
    UIColor *borColor = [UIColor redColor];
    titleLabel.layer.borderColor = borColor.CGColor;
    titleLabel.x = 30;
    titleLabel.y= 60;
    titleLabel.width = 320;
    titleLabel.height = 30;
    
    UILabel *titleLabel01 = [UILabel createLabelWithTitle:@"让我们一起来客观评测孩子的进步！" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentCenter numberOfLines:0];
    [bgView addSubview:titleLabel01];
    titleLabel01.textAlignment = NSTextAlignmentCenter;
    titleLabel01.numberOfLines = 0;
    UIColor *color = [UIColor grayColor];
    titleLabel01.textColor = color;
    titleLabel01.layer.masksToBounds = YES;
    CGFloat rad = 8.f;
    CGFloat borderWidth = 1.f;
    titleLabel01.layer.cornerRadius = rad;
    titleLabel01.layer.borderWidth = borderWidth;
    UIColor *borC = [UIColor redColor];
    titleLabel01.layer.borderColor = borC.CGColor;
    titleLabel01.x = 30;
    titleLabel01.y= 60;
    titleLabel01.width = 320;
    titleLabel01.height = 30;
    
    UIButton *backBtn = [UIButton itemWithTarget:self action:@selector(backBtnClick) image:@"left_button" highImage:nil];
    NSInteger tag = 101;
    backBtn.tag = tag;
    backBtn.bottom = 10;
    backBtn.top  = 11;
    backBtn.x = 10;
    backBtn.y = 101;
    UIColor *textColor = [UIColor greenColor];
    backBtn.titleLabel.textColor = textColor;
    backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    backBtn.titleLabel.numberOfLines= 0;
    backBtn.backgroundColor = [UIColor redColor];
    UIImage *img = [UIImage imageNamed:@""];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
    CGFloat radius = 19;
    imageView.layer.cornerRadius = radius;
    UIColor *imgColor = [UIColor yellowColor];
    CGFloat imgB = 1;
    imageView.layer.borderColor = imgColor.CGColor;
    imageView.layer.borderWidth = imgB;
    [bgView addSubview:backBtn];
    backBtn.x = 10;
    backBtn.y  =100;
    backBtn.width = 320;
    backBtn.height = 48;
    
}

- (void)testEfficacyPhoneNum:(NSString *)phoneNum phoneCode:(NSString *)code districeId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self viewDidLoad];
    
    [self getCode];
    [self EditChanged:self.getCodeTextField];
    
    self.success = success;
    self.failure = failure;
    self.getCodeTextField.text = code;
    self.phoneCode = disId;
    self.phone = phoneNum;
    [self nextBtnClick];
    [self.getCodeTextField testFunction];
    
    [self testHeaderView];
}

@end
