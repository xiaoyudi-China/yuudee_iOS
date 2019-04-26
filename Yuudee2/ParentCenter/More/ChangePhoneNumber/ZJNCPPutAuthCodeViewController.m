//
//  ZJNCPPutAuthCodeViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNCPPutAuthCodeViewController.h"
#import "ZJNVerifyCodeView.h"
#import "ZJNCPChangeSuccessViewController.h"
@interface ZJNCPPutAuthCodeViewController ()
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UIButton *getCodeBtn;
@property (nonatomic ,strong)ZJNVerifyCodeView *verifyCodeView;
@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNCPPutAuthCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = NO;
    self.homeBtn.hidden = YES;
    
    [self setUpSubviews];
    [self timer];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

-(void)setUpSubviews{
    
    [self.view addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(190)+AddNav());
        make.centerX.equalTo(self.view);
        
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(30));
        make.right.equalTo(self.view).offset(-ScreenAdapter(30));
        make.top.equalTo(self.topLabel.mas_bottom).offset(ScreenAdapter(25));
    }];
    
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(20));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    
    [self.view addSubview:self.verifyCodeView];
    [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.getCodeBtn.mas_bottom).offset(ScreenAdapter(35));
        make.size.equalTo(self.getCodeBtn);
    }];
}
-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(16)];
        _topLabel.text = @"更换手机号码";
    }
    return _topLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(14)];
        _titleLabel.text = @"验证码已发送至";
    }
    return _titleLabel;
}
-(UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton itemWithTitle:@"" titleColor:HexColor(0xb5ada5) font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(getCodeBtnClick)];
        [_getCodeBtn setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _getCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _getCodeBtn.userInteractionEnabled = NO;
    }
    return _getCodeBtn;
}
-(ZJNVerifyCodeView *)verifyCodeView{
    if (!_verifyCodeView) {
        _verifyCodeView = [[ZJNVerifyCodeView alloc]init];
        __weak typeof(self) weakSelf = self;
        _verifyCodeView.codeBlock = ^(NSString *verifyCode) {
            [weakSelf updatePhoneWithVerifyCode:verifyCode];
        };
    }
    return _verifyCodeView;
}
- (void)updatePhoneWithVerifyCode:(NSString *)verifyCode{
    NSDictionary *dic = @{@"phone":self.phone,@"code":verifyCode,@"districeId":@(self.qcellcoreId),@"token":[[ZJNTool shareManager] getToken]};
    [[ZJNRequestManager sharedManager] postWithUrlString:UpdatePhone parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            ZJNCPChangeSuccessViewController *viewC = [[ZJNCPChangeSuccessViewController alloc]init];
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

#pragma mark-重新获取验证码
-(void)getCodeBtnClick{
    [self getCodeFromService];
}
#pragma mark-返回上一层
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-倒计时
-(void)timer{
    __weak typeof(self) weakSelf = self;
    __block NSInteger time = 59; //倒计时时间
    //全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [weakSelf.getCodeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
                [weakSelf.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [weakSelf.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2ds后重新获取", seconds] forState:UIControlStateNormal];
                [weakSelf.getCodeBtn setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
                weakSelf.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

-(void)setPhone:(NSString *)phone{
    _phone = phone;
}
-(void)setQcellcoreId:(NSInteger)qcellcoreId{
    _qcellcoreId = qcellcoreId;
}

-(void)getCodeFromService{
    NSDictionary *dic = @{@"phone":self.phone,@"qcellcoreId":@(self.qcellcoreId),@"type":@"4"};
    
    [[ZJNRequestManager sharedManager] postWithUrlString:SendCode parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            [self timer];
        }
        [self showHint:data[@"msg"]];
        
    } failure:^(NSError *error) {
        
        [self showHint:ErrorInfo];
        
    }];
}

- (void)testUpdatePhoneWithVerifyCode:(NSString *)verifyCode phoneNum:(NSString *)phone districeId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
    self.phone = phone;
    self.qcellcoreId = disId;
    [self updatePhoneWithVerifyCode:verifyCode];
    [self getCodeBtnClick];
    [self backBtnClick];
}

@end
