//
//  ZJNCityModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/12.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNCityModel : NSObject
@property (nonatomic ,copy)NSString *cityType;
@property (nonatomic ,copy)NSString *createTime;
@property (nonatomic ,copy)NSString *id;
@property (nonatomic ,copy)NSString *logo;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *phonePrefix;
@property (nonatomic ,copy)NSString *states;
@property (nonatomic ,copy)NSString *updateTime;
@end

@interface ZJNPhoneAreaModel : NSObject
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSArray <ZJNCityModel *>*list;
@end

@interface ZJNPhoneResultModel : NSObject
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *msg;
@property (nonatomic ,copy)NSArray <ZJNPhoneAreaModel *> *data;

@end
