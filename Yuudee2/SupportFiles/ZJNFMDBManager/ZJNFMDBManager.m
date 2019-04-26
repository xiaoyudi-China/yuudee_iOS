//
//  ZJNFMDBManager.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/30.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNFMDBManager.h"
#import "FMDB.h"
@interface ZJNFMDBManager(){
    FMDatabase *_db;
}
@end
@implementation ZJNFMDBManager
static ZJNFMDBManager *fManager = nil;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fManager = [super allocWithZone:zone];
    });
    return fManager;
}
+(ZJNFMDBManager *)shareManager{
    
    return [[self alloc]init];
}
-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:@"/Documents/Yuudee2.db"];
        _db = [[FMDatabase alloc]initWithPath:path];
        BOOL ret = [_db open];
        if (ret) {
            //打开数据库成功
            [self creatYuudeeUserInfoTable];
        }
    }
    return self;
}

/**
 创建用户信息表
 */
-(void)creatYuudeeUserInfoTable{
    NSString *sqlPath = @"create table if not exists UserInfo(age,childId,city,createTime,id,nickname,password,phoneNumber,phonePrefix,qcellcoreId,sex,status,token,updateTime,IsRemind,photo,childNickName,chilSex,chilPhoto,chilName)";
    BOOL ret = [_db executeUpdate:sqlPath];
    if (ret) {
//        NSLog(@"用户信息表创建成功");
    }else{
        NSLog(@"用户信息表创建失败");
    }
}

/*————————————————————个人信息相关————————————————————*/
/* 增**/
-(void)addCurrentUserInfoWithModel:(ZJNUserInfoModel *)infoModel{
    BOOL isExists = [self isExistsWithUserId:infoModel.id];
    if (!isExists) {
        //表中不存在
        NSString *sqlPath = @"insert into UserInfo (age,childId,city,createTime,id,nickname,password,phoneNumber,phonePrefix,qcellcoreId,sex,status,token,updateTime,IsRemind,photo,childNickName,chilSex,chilName,chilPhoto) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        BOOL ret = [_db executeUpdate:sqlPath,infoModel.age,infoModel.childId,infoModel.city,infoModel.createTime,infoModel.id,infoModel.nickname,infoModel.password,infoModel.phoneNumber,infoModel.phonePrefix,infoModel.qcellcoreId,infoModel.sex,infoModel.status,infoModel.token,infoModel.updateTime,infoModel.IsRemind,infoModel.photo,infoModel.childNickName,infoModel.chilSex,infoModel.chilName,infoModel.chilPhoto];
        if (ret) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }else{
        //已存在 更新
        [self updateCurrentUserInfoWithModel:infoModel];
    }
}
/* 删**/
-(void)deleteCurrentUserInfoWithUserId:(NSString *)userId{
    NSString *sqlPath = @"delete from UserInfo where id=?";
    BOOL ret = [_db executeUpdate:sqlPath,userId];
    if (ret) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}
/* 改**/
-(void)updateCurrentUserInfoWithModel:(ZJNUserInfoModel *)infoModel{
    NSString *sqlPath = @"update UserInfo set age=?,childId=?,city=?,createTime=?,nickname=?,password=?,phoneNumber=?,phonePrefix=?,qcellcoreId=?,sex=?,status=?,token=?,updateTime=?,IsRemind=?,id=?,photo=?,childNickName=?,chilSex=?,chilName=?,chilPhoto=? where id=?";
    BOOL ret = [_db executeUpdate:sqlPath,infoModel.age,infoModel.childId,infoModel.city,infoModel.createTime,infoModel.nickname,infoModel.password,infoModel.phoneNumber,infoModel.phonePrefix,infoModel.qcellcoreId,infoModel.sex
                ,infoModel.status,infoModel.token,infoModel.updateTime,infoModel.IsRemind,infoModel.id,infoModel.photo,infoModel.childNickName,infoModel.chilSex,infoModel.chilName,infoModel.chilPhoto,infoModel.id];
    if (ret) {
        NSLog(@"更新完成");
    }else{
        NSLog(@"更新失败");
    }
}
/* 查**/
-(ZJNUserInfoModel *)searchCurrentUserInfoWithUserId:(NSString *)userId{
    ZJNUserInfoModel *model = [[ZJNUserInfoModel alloc]init];
    NSString *sqlPath = @"select *from UserInfo where id=?";
    FMResultSet *set = [_db executeQuery:sqlPath,userId];
    if ([set next]) {
        model.age         = [set stringForColumn:@"age"];
        model.childId     = [set stringForColumn:@"childId"];
        model.city        = [set stringForColumn:@"city"];
        model.createTime  = [set stringForColumn:@"createTime"];
        model.id          = [set stringForColumn:@"id"];
        model.nickname    = [set stringForColumn:@"nickname"];
        model.password    = [set stringForColumn:@"password"];
        model.phoneNumber = [set stringForColumn:@"phoneNumber"];
        model.phonePrefix = [set stringForColumn:@"phonePrefix"];
        model.qcellcoreId = [set stringForColumn:@"qcellcoreId"];
        model.sex         = [set stringForColumn:@"sex"];
        model.status      = [set stringForColumn:@"status"];
        model.token       = [set stringForColumn:@"token"];
        model.updateTime  = [set stringForColumn:@"updateTime"];
        model.IsRemind    = [set stringForColumn:@"IsRemind"];
        model.photo       = [set stringForColumn:@"photo"];
        model.childNickName = [set stringForColumn:@"childNickName"];
        model.chilSex     = [set stringForColumn:@"chilSex"];
        model.chilName    = [set stringForColumn:@"chilName"];
        model.chilPhoto    = [set stringForColumn:@"chilPhoto"];
    }
    return model;
}
/**
 添加新用户信息的时候判断表中是否已存在

 @param userId 新用户ID
 @return 查询结果
 */
-(BOOL)isExistsWithUserId:(NSString *)userId{
    NSString *sqlPath = @"select *from UserInfo where id=?";
    FMResultSet *set = [_db executeQuery:sqlPath,userId];
    if ([set next]) {
        return YES;
    }else{
        return NO;
    }
}
@end
