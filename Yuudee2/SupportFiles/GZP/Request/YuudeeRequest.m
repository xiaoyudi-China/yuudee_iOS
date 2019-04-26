//
//  YuudeeRequest.m
//  Yuudee2
//
//  Created by GZP on 2018/10/30.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "YuudeeRequest.h"

@implementation YuudeeRequest

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static YuudeeRequest *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 60.0;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        manager.responseSerializer = response;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/html",@"text/css",@"text/plain", nil];
    });
    return manager;
}

- (void)request:(HTTPMethod)method url:(NSString *)URLString paras:(id)parameters completion:(void (^)(id, NSError *))completion {
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    };
    void(^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    };
    
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *URL = [Host stringByAppendingString:URLString];
    if (method == Get) {
        [self GET:URL parameters:parameters progress:nil success:successBlock failure:failureBlock];
    } else {
        [self POST:URL parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
}

@end
