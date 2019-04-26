//
//  NSString+ZJNCategory.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZJNCategory)
/**
 判断字符串是否为空
 
 @param string 待判断字符串
 @return 判断结果
 */
+ (BOOL)isEmpty:(NSString *)string;


/**
 判断字符串是否为合法手机号

 @param mobileNum 需要判断的字符串
 @return 返回结果
 */
+(BOOL)validateMobile:(NSString *)mobileNum;

/**
 判断密码是否符合6-13位数字字母组合

 @param password 需要验证的密码
 @return 返回结果
 */
+(BOOL)ValidatePassword:(NSString *)password;


/**
 验证儿童昵称是否由数字，字母，汉字形式

 @param nickName 儿童昵称d
 @return 验证结果
 */
+(BOOL)validateNickName:(NSString *)nickName;

/**
 将时间戳转成自己想要的时间格式

 @param timeStamp 时间戳
 @param dateFormat 时间展示格式
 @return 时间
 */
+(NSString *)timeStampToString:(NSInteger)timeStamp withDateFormat:(NSString *)dateFormat;

/**
 将时间转换为最基本的时间格式：年月日

 @param timeStamp 时间戳
 @return 转换后的时间
 */
+(NSString *)timeStampToString:(NSInteger)timeStamp;


/**
 隐藏手机号中间几位

 @param phoneNumber 手机号码
 @return 变形后的手机号
 */
+(NSString *)changePhontNumber:(NSString *)phoneNumber;


/**
 将类似2018-05-05格式日期转换成 05月05号

 @param date 需要转换的日期
 @return 转换后的日期
 */
+(NSString *)changeDateWithDateStr:(NSInteger)date;



/**
 由一周的起始日期和截止日期计算周四的日期

 @param firstDate 周一的日期
 @param lastDate 周日的日期
 @return 周四的日期
 */
+(NSString *)middleDateWithWeekFirstDate:(NSInteger)firstDate lastDate:(NSInteger)lastDate;


/**
 计算两个日期之间的间隔

 @param time1 开始日期
 @param time2 结束日期
 @return 间隔天数
 */
+(NSInteger)intervalFromStarTime:(NSString *)time1 toEndTime:(NSString *)time2;

/**
 判断输入是否是emoji表情
 
 @param text 输入
 @return YES 输入emoji表情
 */
+(BOOL)isContainsEmoji:(NSString *)text;

/**
  判断是不是九宫格
  @param string 输入的字符
  @return YES(是九宫格拼音键盘)
  */
+(BOOL)isNineKeyBoard:(NSString *)string;
@end
