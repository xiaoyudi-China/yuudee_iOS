//
//  GZPModel.m
//  Yuudee2
//
//  Created by GZP on 2018/10/30.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "GZPModel.h"

@implementation GZPModel

-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(GZPModel *)setModelWithDic:(NSDictionary *)dic
{
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@",obj];
        }
    }];
    return [[GZPModel alloc]initWithDic:dic];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _valueID = value;
    }
    
    
}
@end
