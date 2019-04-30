//
//  ZJNRegisterVerifyCodeViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRegisterVerifyCodeViewController.h"
#import "ZJNVerifyCodeView.h"
#import "ZJNRegisterSetPasswordViewController.h"
@interface ZJNRegisterVerifyCodeViewController ()
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UIButton *getCodeBtn;
@property (nonatomic ,strong)ZJNVerifyCodeView *verifyCodeView;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNRegisterVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    [self timer];
    [self.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}
-(void)setUpSubviews{
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(30));
        make.right.equalTo(self.view).offset(-ScreenAdapter(30));
        make.top.equalTo(self.view).offset(ScreenAdapter(235)+AddNav());
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
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(14)];
        
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
            [weakSelf verifyCodeWithCode:verifyCode];
        };
    }
    return _verifyCodeView;
}
#pragma mark-验证输入的手机验证码是否正确
-(void)verifyCodeWithCode:(NSString *)verifyCode{
    NSDictionary *dic = @{@"phone":self.requestModel.phone,@"districeId":@(self.requestModel.districeId),@"code":verifyCode};
    [[ZJNRequestManager sharedManager] postWithUrlString:RegisterCodeverify parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            //验证码正确
            ZJNRegisterSetPasswordViewController *viewC = [[ZJNRegisterSetPasswordViewController alloc]init];
            viewC.requestModel = self.requestModel;
            [self.navigationController pushViewController:viewC animated:YES];
        }else{
            [self.verifyCodeView cleanVerifyCode];
            [self showHint:data[@"msg"]];
        }
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
#pragma mark-重新获取验证码
-(void)getCodeBtnClick{
    [self getVerifyCode];
}
#pragma mark-返回上一层
-(void)homeBtnClick{
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
-(void)getVerifyCode{
    NSDictionary *dic = @{@"phone":self.requestModel.phone,@"districeId":@(self.requestModel.districeId)};
    [[ZJNRequestManager sharedManager] postWithUrlString:RegisterSendCode parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            [self timer];
        }
        [self showHint:data[@"msg"]];
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
-(void)setRequestModel:(ZJNRequestModel *)requestModel{
    _requestModel = requestModel;
    self.titleLabel.text = [NSString stringWithFormat:@"验证码已发送至+%@ %@",requestModel.districe,requestModel.phone];
}

- (void)testRegisterCodeverify:(NSString *)phoneNum disId:(NSInteger)disId verifyCode:(NSString *)code success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    self.success = success;
    self.failure = failure;
    self.requestModel.districeId = disId;
    self.requestModel.phone = phoneNum;
    [self verifyCodeWithCode:code];
    [self homeBtnClick];
}

- (void)testRegisterSendCode:(NSString *)phoneNum disId:(NSInteger)disId success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
   self.titleLabel.text = [self testRemoveThePlace:@"动词训练马上开始，请在正确的答案上选A，错误的答案选B，不会的选C"];
    self.requestModel.districeId = disId;
    self.requestModel.phone = phoneNum;
    [self getCodeBtnClick];
}

- (NSString *)testRemoveThePlace:(NSString *)str{
    NSInteger length = str.length;
    for (NSInteger count = 0; count < length; count ++) {
        if (count > 26) {
            return str;
        }
        if (count == 0) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 1) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 2) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 3) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 4) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 5) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 6) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 7) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 8) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 9) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 10) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 11) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 12) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 13) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 14) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 15) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 16) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 17) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (count == 18) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }
    return str;
}

@end
