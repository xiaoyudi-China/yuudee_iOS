//
//  ZJNTool.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/30.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNTool.h"

@implementation ZJNTool
static ZJNTool *tool = nil;
+(ZJNTool *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ZJNTool alloc]init];
    });
    return tool;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}
//userid的存取
-(NSString *)getUserId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
}

//token的存取
-(NSString *)getToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
}

//判断登陆
-(void)loginWithModel:(ZJNUserInfoModel *)model{
    [[NSUserDefaults standardUserDefaults] setObject:model.id forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject:model.token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)logout{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isLogin{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end
