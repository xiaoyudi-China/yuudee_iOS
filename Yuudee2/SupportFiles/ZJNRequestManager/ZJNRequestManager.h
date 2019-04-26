//
//  ZJNRequestManager.h
//  Yuudee2
//
//  Created by 北京道口贷科技有限公司 on 2018/8/23.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ZJNRequestManager : NSObject
@property (nonatomic ,strong)AFHTTPSessionManager *sessionManager;
/**
 请求成功回调
 
 @param data 请求成功返回数据
 */
typedef void (^HttpSuccess) (id data);

/**
 请求失败回调
 
 @param error 请求失败原因
 */
typedef void (^HttpFailure) (NSError *error);

/** 单例创建Manager */
+(ZJNRequestManager *)sharedManager;

/**
 get请求
 
 @param urlStr 请求接口
 @param success 成功回调
 @param failure 失败回调
 */
-(void)getWithUrlString:(NSString *)urlStr success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 post请求
 
 @param urlStr 请求接口
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
-(void)postWithUrlString:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;


/**
 form表单提交图片
 
 @param urlStr 请求接口
 @param parameters 请求参数
 @param images 需要上传的图片
 @param success 成功回调
 @param failure 失败回调
 */
-(void)postWithUrlString:(NSString *)urlStr parameters:(NSDictionary *)parameters images:(NSArray *)images success:(HttpSuccess)success failure:(HttpFailure)failure;

/**
 上传单张图片

 @param urlStr 请求接口
 @param parameters 请求参数
 @param image 上传的图片
 @param success 成功回调
 @param failure 失败回调
 */
-(void)postWithUrlString:(NSString *)urlStr parameters:(NSDictionary *)parameters image:(UIImage *)image success:(HttpSuccess)success failure:(HttpFailure)failure;
@end
