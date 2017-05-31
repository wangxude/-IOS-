//
//  AFNHttpTool.h
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/16.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSError* error);

@interface AFNHttpTool : NSObject

/**
 * 开发者：王旭
 * POST 请求
 * 不需要返回值：1.网络数据会延迟，并不会马上返回
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 *开发者 ：王旭
 *
 @param code 返回码
 @return 返回错误类型
 */
+ (NSString *)SignInWithCode:(int)code;

/**
 封装 上传图片

 @param url 服务器地址
 @param dic 请求参数
 @param data 图片的二进制流数据
 @param successBlock 请求成功之后的回调
 @param failBlock 请求失败之后的回调
 */
+(void)sendPostWithUrl:(NSString *)url parameters:(NSDictionary *)dic picutreData:(NSData*)data success:(SuccessBlock)successBlock fail:(FailureBlock)failBlock;


/**
 封装上传图片的多张图片

 @param url 服务器地址
 @param dic 传参数
 @param array 图片数组
 @param successBlock 请求成功之后的回调
 @param failBlock 请求失败之后的回调
 */
+(void)sendPostWithUrl:(NSString *)url parameters:(NSDictionary *)dic picutreDataArray:(NSArray*)array success:(SuccessBlock)successBlock fail:(FailureBlock)failBlock;

@end
