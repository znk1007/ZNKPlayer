//
//  HTTPEngineGuide.m
//  SECollection
//
//  Created by HuangSam on 16/8/29.
//  Copyright © 2016年 suneee. All rights reserved.
//

#import "HTTPEngine.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"


@interface HTTPEngine ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HTTPEngine

+ (HTTPEngine *)sharedEngine{
    static HTTPEngine *_sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedEngine = [[self alloc] init];
    });
    return _sharedEngine;
}

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}


- (NSURLSessionDataTask *)getRequestWithURL:(NSString *)url
                                 parameters:(id)parameters
                                    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(task, responseObject);
            }else if ([responseObject isKindOfClass:[NSData class]]) {
                NSError *error;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    NSDictionary *jsonObj = [NSDictionary dictionaryWithXMLData:responseObject];
                    if (jsonObj) {
                        success(task, jsonObj);
                    }else{
                        success(task,nil);
                    }
                }else{
                    success(task, dic);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(task, error);
        }
    }];
}

- (NSURLSessionDataTask *)postRequestWithURL:(NSString *)url
                 parameters:(id)parameters
                   success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(task, responseObject);
            }else if ([responseObject isKindOfClass:[NSData class]]) {
                NSError *error;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    NSDictionary *jsonObj = [NSDictionary dictionaryWithXMLData:responseObject];
                    if (jsonObj) {
                        success(task, jsonObj);
                    }else{
                        success(task,@{@"error":error.localizedDescription});
                    }
                }else{
                    success(task, dic);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(task, error);
        }
    }];
    
    
}

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
                     failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [self.manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(task, responseObject);
            }else if ([responseObject isKindOfClass:[NSData class]]) {
                NSError *error;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    NSDictionary *jsonObj = [NSDictionary dictionaryWithXMLData:responseObject];
                    if (jsonObj) {
                        success(task, jsonObj);
                    }else{
                        success(task,@{@"error":error.localizedDescription});
                    }
                }else{
                    success(task, dic);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(task,error);
        }
    }];
}

@end

