//
//  ZJNAreaModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/1.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJNAreaModel : NSObject

@property (nonatomic ,copy)NSString *areaid;
@property (nonatomic ,copy)NSString *areacode;
@property (nonatomic ,copy)NSString *areaname;
@property (nonatomic ,copy)NSString *level;
@property (nonatomic ,copy)NSString *citycode;
@property (nonatomic ,copy)NSString *center;
@property (nonatomic ,copy)NSString *parentid;

@end

NS_ASSUME_NONNULL_END
