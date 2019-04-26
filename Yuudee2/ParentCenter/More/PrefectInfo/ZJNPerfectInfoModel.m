//
//  ZJNPerfectInfoModel.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/1.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPerfectInfoModel.h"

@implementation ZJNPerfectInfoModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthdate forKey:@"birthdate"];
    [aCoder encodeObject:self.medical forKey:@"medical"];
    [aCoder encodeObject:self.medicalState forKey:@"medicalState"];
    [aCoder encodeObject:self.firstLanguage forKey:@"firstLanguage"];
    [aCoder encodeObject:self.firstRests forKey:@"firstRests"];
    [aCoder encodeObject:self.secondLanguage forKey:@"secondLanguage"];
    [aCoder encodeObject:self.secondRests forKey:@"secondRests"];
    [aCoder encodeObject:self.fatherCulture forKey:@"fatherCulture"];
    [aCoder encodeObject:self.motherCulture forKey:@"motherCulture"];
    [aCoder encodeObject:self.trainingMethod forKey:@"trainingMethod"];
    [aCoder encodeObject:self.trainingRests forKey:@"trainingRests"];
    [aCoder encodeObject:self.states forKey:@"states"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.countiyId forKey:@"countiyId"];
    [aCoder encodeObject:self.provinceId forKey:@"provinceId"];
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.birthdate = [aDecoder decodeObjectForKey:@"birthdate"];
        self.medical = [aDecoder decodeObjectForKey:@"medical"];
        self.medicalState = [aDecoder decodeObjectForKey:@"medicalState"];
        self.firstLanguage = [aDecoder decodeObjectForKey:@"firstLanguage"];
        self.firstRests = [aDecoder decodeObjectForKey:@"firstRests"];
        self.secondLanguage = [aDecoder decodeObjectForKey:@"secondLanguage"];
        self.secondRests = [aDecoder decodeObjectForKey:@"secondRests"];
        self.fatherCulture = [aDecoder decodeObjectForKey:@"fatherCulture"];
        self.motherCulture = [aDecoder decodeObjectForKey:@"motherCulture"];
        self.trainingMethod = [aDecoder decodeObjectForKey:@"trainingMethod"];
        self.trainingRests = [aDecoder decodeObjectForKey:@"trainingRests"];
        self.states = [aDecoder decodeObjectForKey:@"states"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.countiyId = [aDecoder decodeObjectForKey:@"countiyId"];
        self.provinceId = [aDecoder decodeObjectForKey:@"provinceId"];
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        
    }
    return self;
}
@end
