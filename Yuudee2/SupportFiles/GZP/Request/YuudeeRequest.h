//
//  YuudeeRequest.h
//  Yuudee2
//
//  Created by GZP on 2018/10/30.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSUInteger, HTTPMethod) {
    Get = 0,
    Post
};
@interface YuudeeRequest : AFHTTPSessionManager

+(instancetype)shareManager;

- (void)request:(HTTPMethod)method url:(NSString *)URLString paras:(id)parameters completion:(void(^)(id response, NSError *error))completion;

@end
