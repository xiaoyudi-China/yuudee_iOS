//
//  ZJNPhoneTextField.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/27.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPhoneTextField.h"
@interface ZJNPhoneTextField()<UITextFieldDelegate>

@end
@implementation ZJNPhoneTextField
-(instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
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
    NSUInteger lengthOfString = string.length;//lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex];//将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48){
            if (self.inputErrorBlock) {
                self.inputErrorBlock();
            }
            return NO;
        }
        
        if (character > 57 && character < 65){
            if (self.inputErrorBlock) {
                self.inputErrorBlock();
            }
            return NO;
        }
        
        if (character > 90 && character < 97){
            if (self.inputErrorBlock) {
                self.inputErrorBlock();
            }
            return NO;
        };
        
        if (character > 122){
            if (self.inputErrorBlock) {
                self.inputErrorBlock();
            }
            return NO;
        };
        
    }
    
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
