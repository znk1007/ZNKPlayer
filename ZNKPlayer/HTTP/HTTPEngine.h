//
//  HTTPEngineGuide.h
//  SECollection
//
//  Created by HuangSam on 16/8/29.
//  Copyright © 2016年 suneee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

@interface HTTPEngine : NSObject


+ (HTTPEngine *)sharedEngine;



/**
 *  GET 请求
 *
 *  @param url          请求url
 *  @param parameters   get参数
 *  @param success      成功回调
 *  @param failure      失败回调
 *
 *  @return
 */
- (NSURLSessionDataTask *)getRequestWithURL:(NSString *)url
                                 parameters:(id)parameters
                                    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

/**
 *  POST 请求
 *
 *  @param url       请求url
 *  @param parameters post参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (NSURLSessionDataTask *)postRequestWithURL:(NSString *)url
                                  parameters:(id)parameters
                                     success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

/**
 *  上传
 *
 *  @param url       请求url
 *  @param parameter post参数
 *  @param block     上传数据
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (NSURLSessionDataTask *)uploadRequestWithURL:(NSString *)url
                                     parameter:(id)parameter
                              constructingBody:(void(^)(id <AFMultipartFormData> formData))block
                                       success:(void (^)(NSURLSessionDataTask *operation, NSDictionary *responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

@end


