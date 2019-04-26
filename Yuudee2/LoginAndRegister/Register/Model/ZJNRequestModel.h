//
//  ZJNRequestModel.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/25.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJNRequestModel : NSObject
//手机号
@property (nonatomic ,copy)NSString *phone;
//手机号归属地
@property (nonatomic ,copy)NSString *districe;
//手机号归属地ID
@property (nonatomic ,assign)NSInteger districeId;
//密码
@property (nonatomic ,copy)NSString *password;
@end

NS_ASSUME_NONNULL_END
