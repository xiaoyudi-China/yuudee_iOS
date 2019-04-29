//
//  ZJNVerifyCodeView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNVerifyCodeView.h"
@interface ZJNVerifyCodeView()<UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *textField;
@property (nonatomic ,copy)NSArray *labelArr;

@end
@implementation ZJNVerifyCodeView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = HexColor(yellowColor()).CGColor;
        self.layer.borderWidth = 0.5;
        
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat labelWidth = (ScreenAdapter(334)-2.5)/6.0;
        for (int i = 0; i <5; i ++) {
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = HexColor(yellowColor());
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.width.mas_equalTo(0.5);
                make.left.equalTo(self).offset(labelWidth+i*(labelWidth+0.5));
            }];
        }
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i <6; i ++) {
            UILabel *label = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(16)];
//            label.text = @"0";
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            [tempArr addObject:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.width.mas_equalTo(labelWidth);
                make.left.equalTo(self).offset(i*(labelWidth+0.5));
            }];
        }
        self.labelArr = tempArr;
    }
    return self;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0) {
        return YES;
    } else if (textField.text.length >= 6) {
        textField.text = [textField.text substringToIndex:6];
        return NO;
    } else {
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger i = textField.text.length;
    if (i == 0) {
        ((UILabel *)[self.labelArr objectAtIndex:0]).text = @"";
    } else {
        ((UILabel *)[self.labelArr objectAtIndex:i - 1]).text = [NSString stringWithFormat:@"%C", [textField.text characterAtIndex:i - 1]];
        if (6 > i) {
            ((UILabel *)[self.labelArr objectAtIndex:i]).text = @"";
        }
        if (i  == 6) {
            if (self.codeBlock) {
                self.codeBlock(textField.text);
            }
        }
    }
//    if (self.codeBlock) {
//        self.codeBlock(textField.text);
//    }
}

-(void)cleanVerifyCode{
    self.textField.text = @"";
    for (UILabel *label in self.labelArr) {
        label.text = @"";
    }
}

- (void)testFunction{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
    self.textField.text = @"12345";
    [self textFieldDidChange:self.textField];
//    self.textField.text = @"123456";
//    [self textFieldDidChange:self.textField];
    [self cleanVerifyCode];
    [self textField:self.textField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"\n"];
    [self textField:self.textField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@""];
    [self textField:self.textField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"1234567"];
}

@end
