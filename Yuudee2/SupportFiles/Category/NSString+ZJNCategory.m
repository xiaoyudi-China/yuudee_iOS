//
//  NSString+ZJNCategory.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "NSString+ZJNCategory.h"

@implementation NSString (ZJNCategory)

+(BOOL)isEmpty:(NSString *)string{
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        return YES;
    }
    return NO;
}

+(BOOL)validateMobile:(NSString *)mobileNum
{
//    NSString *regex = @"^1[3|5|6|7|8][0-9]\\d{8}$";
    NSString *regex = @"^\\d{11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if(![pred evaluateWithObject:mobileNum]){
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)ValidatePassword:(NSString *)password{
    
//    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,13}$";//必须同时含有字母和数字
    NSString *regex = @"^[a-zA-Z0-9]{6,13}$";//字母或数字
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if(![pred evaluateWithObject:password]){
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)validateNickName:(NSString *)nickName{
    NSString *regex = @"[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？ _]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:nickName]) {
        return NO;
    }else{
        return YES;
    }
    
}

+(NSString *)timeStampToString:(NSInteger)timeStamp withDateFormat:(NSString *)dateFormat{
    NSDate *dateStamp = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    NSDateFormatter *dateformt = [[NSDateFormatter alloc]init];
    [dateformt setDateFormat:dateFormat];
    NSString *dateStr = [dateformt stringFromDate:dateStamp];
    return dateStr;
}

+(NSString *)timeStampToString:(NSInteger)timeStamp{
    NSDate *dateStamp = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    NSDateFormatter *dateformt = [[NSDateFormatter alloc]init];
    [dateformt setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateformt stringFromDate:dateStamp];
    return dateStr;
}

+(NSString *)changePhontNumber:(NSString *)phoneNumber{
    NSString *phoneStr = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return phoneStr;
}

+(NSString *)changeDateWithDateStr:(NSInteger)date{
    NSString *dateStr = [self timeStampToString:date];
    NSArray *array = [dateStr componentsSeparatedByString:@"-"];
    NSString *month = array[1];
    NSString *day    = array[2];
    NSString *newDate = [NSString stringWithFormat:@"%@月%@日",month,day];
    return newDate;
}

+(NSString *)middleDateWithWeekFirstDate:(NSInteger)firstDate lastDate:(NSInteger)lastDate{
    NSString *firstStr = [self timeStampToString:firstDate];
    NSString *lastStr  = [self timeStampToString:lastDate];
    NSArray  *firstArr = [firstStr componentsSeparatedByString:@"-"];
    NSArray  *lastArr  = [lastStr  componentsSeparatedByString:@"-"];
    NSString *lastDay = lastArr[2];
    NSInteger last = [lastDay integerValue];
    if ((last-3)>0) {
        NSString *month = lastArr[1];
        NSString *day   = [NSString stringWithFormat:@"%ld",(last -3)];
        NSString *newDate = [NSString stringWithFormat:@"%@月%@日",month,day];
        return newDate;
    }else{
        NSString *month = firstArr[1];
        NSString *firstDay = firstArr[2];
        NSInteger first = [firstDay integerValue];
        NSString *day = [NSString stringWithFormat:@"%ld",first+3];
        NSString *newDate = [NSString stringWithFormat:@"%@月%@日",month,day];
        return newDate;
    }
}

+(NSInteger)intervalFromStarTime:(NSString *)time1 toEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    return cmps.day;
}

+(BOOL)isContainsEmoji:(NSString *)text{
    if ([self stringContainsEmoji:text]||[self hasEmoji:text]) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)stringContainsEmoji:(NSString *)string {
    
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return YES;
    }else{
        return NO;
    }

}
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
    
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
    
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
/**
  判断是不是九宫格
  @param string 输入的字符
  @return YES(是九宫格拼音键盘)
  */
+(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++){
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

@end
