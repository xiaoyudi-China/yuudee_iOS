//
//  YuudeeDate.m
//  Yuudee2
//
//  Created by GZP on 2018/11/9.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "YuudeeDate.h"

@implementation YuudeeDate

+(NSString *)getStartTime:(NSDate *)date
{
    NSDateFormatter * fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [fo stringFromDate:date];;
}
@end
