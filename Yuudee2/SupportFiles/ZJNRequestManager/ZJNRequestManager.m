//
//  ZJNRequestManager.m
//  Yuudee2
//
//  Created by 北京道口贷科技有限公司 on 2018/8/23.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNRequestManager.h"
#import <JPUSHService.h>
@implementation ZJNRequestManager
static ZJNRequestManager *manager = nil;
+(ZJNRequestManager *)sharedManager{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[ZJNRequestManager alloc]init];
//        manager.sessionManager = [AFHTTPSessionManager manager];
//
//        AFHTTPRequestSerializer *request = [AFHTTPRequestSerializer serializer];
//        request.timeoutInterval = 30;
//        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//        manager.sessionManager.requestSerializer = request;
//
//        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
//        response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
//        manager.sessionManager.responseSerializer = response;
//
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = NO;
//        manager.sessionManager.securityPolicy = securityPolicy;
//
//    });
//    return manager;
    return [[self alloc]init];
}
+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        manager.sessionManager = [AFHTTPSessionManager manager];
        
        AFHTTPRequestSerializer *request = [AFHTTPRequestSerializer serializer];
        request.timeoutInterval = 30;
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        manager.sessionManager.requestSerializer = request;
        
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        manager.sessionManager.responseSerializer = response;
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        manager.sessionManager.securityPolicy = securityPolicy;
    });
    return manager;
}

-(void)getWithUrlString:(NSString *)urlStr success:(HttpSuccess)success failure:(HttpFailure)failure{
    [self.sessionManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)postWithUrlString:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    
    NSString *URL = [Host stringByAppendingString:urlStr];
    
    [self.sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"209"]) {
            //退出登录时，清空用户相关信息
            [[ZJNFMDBManager shareManager] deleteCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
            [[ZJNTool shareManager] logout];
            [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
            } seq:0];
            AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[ZJNLoginAndRegisterViewController new]];
            //这里就不return了
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(void)postWithUrlString:(NSString *)urlStr parameters:(NSDictionary *)parameters images:(NSArray *)images success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *URL = [Host stringByAppendingString:urlStr];
    [self.sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <images.count; i ++) {
            UIImage *image = images[i];
            NSData *imgData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5)];
            
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"image%d",i] fileName:[NSString stringWithFormat:@"image%d.png",i] mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)postWithUrlString:(NSString *)urlStr parameters:(NSDictionary *)parameters image:(UIImage *)image success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *URL = [Host stringByAppendingString:urlStr];
    [self.sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imgData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5)];
            
        [formData appendPartWithFileData:imgData name:@"image" fileName:@"image.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
