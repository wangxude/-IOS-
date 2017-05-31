//
//  AppDelegate.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/15.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"

//注册shareSDK应用
#define shareSDKAppkey @"1d83f14168b16"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信的SDK文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate,QQApiInterfaceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:shareSDKAppkey
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ] onImport:^(SSDKPlatformType platformType){
                                switch (platformType) {
                                    case SSDKPlatformTypeQQ:
                                        [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                        
                                        break;
                                    case SSDKPlatformTypeWechat:
                                        [ShareSDKConnector connectWeChat:[WXApi class]];
                                        
                                        break;
                                    case SSDKPlatformTypeSinaWeibo:
                                        
                                        [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                        
                                        break;
                                    default:
                                        break;
                                }
                                
                                
                                
                            }
          onConfiguration:^(SSDKPlatformType platformType,NSMutableDictionary *appInfo){
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"45480196"
                                                appSecret:@"9a627cde5e221b9eb3d7543818bfdab1"
                                              redirectUri:@"http://www.weibo.com"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx6d42c75abef33c5d"
                                            appSecret:@"2a4a40d1908dd757da676ebf739064b7"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1106064487"
                                           appKey:@"sqJMXGt2oc93NO4G"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];

   

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    SignInViewController*signInVC = [[SignInViewController alloc]init];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:signInVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [QQApiInterface handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [QQApiInterface handleOpenURL:url delegate:self];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    // 1.取消正在下载的操作
    [mgr cancelAll];
    
    // 2.清除内存缓存
    [mgr.imageCache clearMemory];
}




@end
