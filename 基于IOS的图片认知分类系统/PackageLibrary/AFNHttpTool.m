//
//  AFNHttpTool.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/16.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "AFNHttpTool.h"
#import "WXGetTheCurrentTime.h"


@implementation AFNHttpTool

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    session.requestSerializer.timeoutInterval=7.0f;
//    [session.responseSerializer didChangeValueForKey:@"timeoutInterval"];
    // 2.设置请求头
    //session.requestSerializer = [AFHTTPRequestSerializer serializer];
    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
   // [self setHTTPHeader];  // 可在此处设置Http头信息
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:[NSString stringWithFormat:@"%@%@",LocalHost,URLString] parameters:parameters progress: ^(NSProgress *progress)
     {
         
     }
          success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (success) {
             
             success(responseObject);
             
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(error);
              }
          }];
    }


+ (NSString *)SignInWithCode:(int)code
{
    switch (code) {
        case 101:
            return @"未登录";
            break;
        case 102:
            return @"已登录";
            break;
        case 201:
            return @"资源不存在";
            break;
        case 202:
            return @"资源已存在";
            break;
        case 203:
            return @"资源被占用";
            break;
        case 204:
            return @"重复操作";
            break;
        case 301:
            return @"参数错误";
            break;
        case 302:
            return @"业务错误";
            break;
        case 303:
            return @"数据库错误";
            break;
        case 304:
            return @"网络错误";
            break;
        case 401:
            return @"权限不足";
            break;
        case 500:
            return @"服务器内部错误";
            break;
        case 999:
            return @"操作失败";
            break;
        default:
            return nil;
            break;
            
    }
}

+(void)sendPostWithUrl:(NSString *)url parameters:(NSDictionary *)dic picutreData:(NSData*)data success:(SuccessBlock)successBlock fail:(FailureBlock)failBlock{
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置超时时间
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 10.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manger POST:[NSString stringWithFormat:@"%@%@",LocalHost,url] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType] 
         */
        
       [formData appendPartWithFileData:data name:@"image" fileName:[WXGetTheCurrentTime getCurrentTimeToPictureName] mimeType:@"image/png/jpeg"];
        NSLog(@"111");
    } progress:^(NSProgress * _Nonnull uploadProgress) {
         NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
         NSLog(@"333");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
         NSLog(@"444");
    }];
    
}
+(void)sendPostWithUrl:(NSString *)url parameters:(NSDictionary *)dic picutreDataArray:(NSArray *)array success:(SuccessBlock)successBlock fail:(FailureBlock)failBlock{
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    // 可在此处设置Http头信息
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置请求超时时间
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 10.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger POST:[NSString stringWithFormat:@"%@%@",LocalHost,url] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        
        for (int i = 0; i < array.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmssSSS";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            UIImage *image = array[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i] fileName:fileName mimeType:@"image/jpeg"];
         
            
        }
         NSLog(@"111");
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"传输字节%lld,总字节数据%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
        NSLog(@"333");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        NSLog(@"444");
    }];

}
@end
