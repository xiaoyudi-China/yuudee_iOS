//
//  ZJNTotalModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/6.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJNTotalModel : NSObject
@property (nonatomic ,copy)NSString *id;
@property (nonatomic ,copy)NSString *rate_all;//测试进度
@property (nonatomic ,copy)NSString *learning_time;//学习时长
@property (nonatomic ,copy)NSString *score;//分数

@end

NS_ASSUME_NONNULL_END
