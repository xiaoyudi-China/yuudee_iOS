//
//  ZJNChangeNickNameViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNChangeNickNameViewController.h"
#import "ZJNBasicTextField.h"
@interface ZJNChangeNickNameViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)ZJNBasicTextField *nickNameTextField;
@property (nonatomic ,strong)UIButton *okButton;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backBtn.hidden = NO;
    self.homeBtn.hidden = YES;
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScreenAdapter(190)+AddNav());
        make.centerX.equalTo(self.view);
        
    }];
    [self.view addSubview:self.nickNameTextField];
    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScreenAdapter(20));
        make.left.equalTo(self.view).offset(ScreenAdapter(27));
        make.right.equalTo(self.view).offset(-ScreenAdapter(27));
        make.height.mas_equalTo(ScreenAdapter(43));
    }];
    
    [self.view addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.nickNameTextField.mas_bottom).offset(ScreenAdapter(55));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(greetingTextFieldChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.nickNameTextField];
    // Do any additional setup after loading the view.
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(16)];
        _titleLabel.text = @"修改儿童昵称";
    }
    return _titleLabel;
}

-(ZJNBasicTextField *)nickNameTextField{
    if (!_nickNameTextField) {
        _nickNameTextField = [[ZJNBasicTextField alloc]init];
        _nickNameTextField.imageName = @"1";
        _nickNameTextField.delegate = self;
        _nickNameTextField.placeholder = @"请输入儿童新昵称";
    
    }
    return _nickNameTextField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    
    //拼音九键的本质 其实也是在输入符号
    if ([NSString isNineKeyBoard:string]) {
        return YES;
    }else{
        if ([NSString isContainsEmoji:string]) {
            return NO;
        }
    }
//    if (range.length == 1 && string.length == 0) {
//        return YES;
//    }else if (textField.text.length>=13) {
//        textField.text = [textField.text substringToIndex:13];
//        return NO;
//    }else{
        BOOL isV = [NSString validateNickName:string];
        if (isV) {
            [self showHint:@"请输入字母，数字或文字形式的儿童昵称"];
            
            return NO;
        }
//    }
    return YES;
    
}

-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton itemWithTitle:@"确定" titleColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(okBtnClick)];
        [_okButton setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
        _okButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
//        _okButton.userInteractionEnabled = NO;
    }
    return _okButton;
}

#pragma mark-确定按钮
-(void)okBtnClick{
    [self.nickNameTextField endEditing:YES];
    if (self.nickNameTextField.text.length==0) {
        [self showHint:@"请输入儿童新昵称"];
        return;
    }
    NSDictionary *dic = @{@"token":self.token,@"name":self.nickNameTextField.text};
    [[ZJNRequestManager sharedManager] postWithUrlString:UpdateChildInfo parameters:dic success:^(id data) {
        if (self.success) {
            self.success(data);
        }
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshName" object:nil];
            if (self.updateNickname) {
                self.updateNickname(self.nickNameTextField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self showHint:data[@"msg"]];

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

-(void)greetingTextFieldChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式n
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > 13) {
                textField.text = [toBeString substringToIndex:13];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            NSLog(@"这里什么时候会调用");
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > 13) {
            textField.text= [toBeString substringToIndex:13];
        }
    }
}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.nickNameTextField];
//}

- (void)testUpdateChildInfo:(NSString *)token userName:(NSString *)name
                success:(void (^) (id json))success
                failure:(void (^)(NSError *error))failure{
    [self viewDidLoad];
    self.nickNameTextField.text = name;
    self.token = token;
    self.success = success;
    self.failure = failure;
    [self okBtnClick];
}

@end
