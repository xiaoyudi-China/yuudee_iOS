//
//  GZPModel.m
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 险峰科技. All rights reserved.
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
    return [[GZPModel alloc]initWithDic:dic];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
