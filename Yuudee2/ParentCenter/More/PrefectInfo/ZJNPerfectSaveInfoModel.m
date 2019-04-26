//
//  ZJNPerfectSaveInfoModel.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/30.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPerfectSaveInfoModel.h"
@interface ZJNPerfectSaveInfoModel()

@end
@implementation ZJNPerfectSaveInfoModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthdate forKey:@"birthdate"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.medical forKey:@"medical"];
    [aCoder encodeObject:self.firstLanguage forKey:@"firstLanguage"];
    [aCoder encodeObject:self.secondLanguage forKey:@"secondLanguage"];
    [aCoder encodeObject:self.fatherCulture forKey:@"fatherCulture"];
    [aCoder encodeObject:self.motherCulture forKey:@"motherCulture"];
    [aCoder encodeObject:self.trainingMethod forKey:@"trainingMethod"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.birthdate = [aDecoder decodeObjectForKey:@"birthdate"];
        self.medical = [aDecoder decodeObjectForKey:@"medical"];
        self.firstLanguage = [aDecoder decodeObjectForKey:@"firstLanguage"];
        self.secondLanguage = [aDecoder decodeObjectForKey:@"secondLanguage"];
        self.fatherCulture = [aDecoder decodeObjectForKey:@"fatherCulture"];
        self.motherCulture = [aDecoder decodeObjectForKey:@"motherCulture"];
        self.trainingMethod = [aDecoder decodeObjectForKey:@"trainingMethod"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}
@end
