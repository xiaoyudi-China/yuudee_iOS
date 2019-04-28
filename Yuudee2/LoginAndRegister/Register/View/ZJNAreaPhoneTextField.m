//
//  ZJNAreaPhoneTextField.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/11.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNAreaPhoneTextField.h"
@interface ZJNAreaPhoneTextField()<UITextFieldDelegate>

@property (nonatomic ,strong)UIView   *leftV;

@property (nonatomic ,strong)UILabel  *placeHolderLabel;
@end

@implementation ZJNAreaPhoneTextField
-(instancetype)init{
    self = [super init];
    if (self) {
        self.layer.borderColor = HexColor(yellowColor()).CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = ScreenAdapter(21.5);
        self.layer.masksToBounds = YES;
        self.textColor = HexColor(yellowColor());
        self.font = FontSize(14);
        self.leftView = self.leftV;
        self.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.placeHolderLabel];
        [self setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
        self.delegate = self;
    }
    return self;
}
-(UIView *)leftV{
    if (!_leftV) {
        _leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenAdapter(70), ScreenAdapter(43))];
        [_leftV addSubview:self.leftButton];
    }
    return _leftV;
}
-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton itemWithTitle:@"+86" titleColor:HexColor(yellowColor()) font:FontSize(14) target:self action:@selector(leftButtonClick)];
        [_leftButton setImage:SetImage(@"sign_icon_iphone") forState:UIControlStateNormal];
        _leftButton.frame = CGRectMake(ScreenAdapter(7), 0, ScreenAdapter(63), ScreenAdapter(43));
        _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    }
    return _leftButton;
}
-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel createLabelWithTitle:@"" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _placeHolderLabel;
}
-(void)leftButtonClick{
    NSLog(@"按钮被点击了");
    if (self.areaBtnClickBlock) {
        self.areaBtnClickBlock();
    }
}
- (NSString *)plainPhoneNum {
    return [self noneSpaseString:self.text];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        return;
    }
    [self isRealPhoneWithPhoneNumber:textField.text];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *phStr = Placeholder;
    unichar phChar = ' ';
    if (phStr.length) {
        phChar = [phStr characterAtIndex:0];
    }
    if (textField) {
        NSString* text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length - 1 ) {
                    if ([text characterAtIndex:text.length - 1] == phChar) {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == phChar && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                return NO;
            }
            else{
                return YES;
            }
        }else if(string.length >0){
            
            if ([self.areaCode isEqualToString:@"1"]) {
                //限制输入字符个数
                if (([self noneSpaseString:textField.text].length + string.length - range.length > 11)) {
                    return NO;
                }
                if (([self noneSpaseString:textField.text].length + string.length - range.length == 11)) {
                    NSString *phone = [textField.text stringByAppendingString:string];
                    textField.text = phone;
                    [textField resignFirstResponder];
                    return YES;
                }
            }
            //判断是否是纯数字(搜狗，百度输入法，数字键盘居然可以输入其他字符)
            if(![self isNum:string]){
                return NO;
            }
            [textField insertText:string];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

- (NSString*)parseString:(NSString*)string{
    
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:Placeholder withString:@""]];
    if (mStr.length >3) {
        [mStr insertString:Placeholder atIndex:3];
    }if (mStr.length > 8) {
        [mStr insertString:Placeholder atIndex:8];
        
    }
    return  mStr;
}

/** 获取正常电话号码（去掉空格） */
- (NSString*)noneSpaseString:(NSString*)string{
    
    return [string stringByReplacingOccurrencesOfString:Placeholder withString:@""];
    
}

- (BOOL)isNum:(NSString *)checkedNumString {
    
    if (!checkedNumString) {
        return NO;
    }
    
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(checkedNumString.length > 0) {
        return NO;
    }
    
    return YES;
    
}
-(void)setAreaCode:(NSString *)areaCode{
    _areaCode = areaCode;
}
#pragma mark-判断手机号是否正确
-(void)isRealPhoneWithPhoneNumber:(NSString *)phoneNumber{
    NSDictionary *dic = @{@"phone":[self noneSpaseString:phoneNumber],@"qcellcoreId":self.areaCode};
    [[ZJNRequestManager sharedManager] postWithUrlString:PhoneNumber parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([data[@"data"] isEqualToString:@"1"]) {
            if (self.phoneBlack) {
                self.phoneBlack(YES);
            }
        }else{
            if (self.phoneBlack) {
                self.phoneBlack(NO);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)testFunction{
    [self leftButtonClick];
    self.text = @"13661316354";
    self.areaCode = @"1234";
    [self textFieldDidEndEditing:self];
    [self isNum:self.text];
    
    [self textField:self shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"1"];
}

@end
