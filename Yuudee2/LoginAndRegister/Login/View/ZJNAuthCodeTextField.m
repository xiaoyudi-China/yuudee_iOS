//
//  ZJNAuthCodeTextField.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNAuthCodeTextField.h"
#import "MQVerCodeImageView.h"

@interface ZJNAuthCodeTextField()
//@property (nonatomic ,strong)MQVerCodeImageView *verImageView;
@property (nonatomic ,strong)UIImageView *verImageView;
@property (nonatomic ,strong)NSString *authCode;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end
@implementation ZJNAuthCodeTextField

-(id)init{
    self = [super init];
    if (self) {
        UIView *rightV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 35)];
        [rightV addSubview:self.verImageView];
        self.rightView = rightV;
        self.rightViewMode = UITextFieldViewModeAlways;
        [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

//-(MQVerCodeImageView *)verImageView{
//    if (!_verImageView) {
//        _verImageView = [[MQVerCodeImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
//        __weak typeof(self) weakSelf = self;
//        _verImageView.bolck = ^(NSString *codeStr) {
//            weakSelf.authCode = codeStr;
//        };
//        _verImageView.isRotation = NO;
//        [_verImageView freshVerCode];
//    }
//    return _verImageView;
//}
-(UIImageView *)verImageView{
    if (!_verImageView) {
        _verImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
        _verImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,AuthImage]]]];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAuthImage)];
        _verImageView.userInteractionEnabled = YES;
        [_verImageView addGestureRecognizer:recognizer];
//        [_verImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,AuthImage]] placeholderImage:nil];
    }
    return _verImageView;
}

-(void)textFieldValueChanged:(UITextField *)textfield{
    if (textfield.text.length == 4) {
        [self verifyImageCode];
    }
}

-(void)verifyImageCode{
    
    NSDictionary *dic = @{@"imageCode":self.text};
    [[ZJNRequestManager sharedManager] postWithUrlString:VerifyImageCode parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            if (self.authResult) {
                self.authResult(YES);
            }
        }else{
            [[[self superview] viewController] showHint:data[@"msg"]];
        }
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

-(void)changeAuthImage{
    self.verImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,AuthImage]]]];
}

- (void)testVerifyImageCode:(NSString *)code success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    self.success = success;
    self.failure = failure;
    self.text = code;
    UITextField *textfield = [[UITextField alloc]init];
    textfield.text = code;
//    [self verifyImageCode];
    [self textFieldValueChanged:textfield];
    [[ZJNTool shareManager] getToken];
}

@end
