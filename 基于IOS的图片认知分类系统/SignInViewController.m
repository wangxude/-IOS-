//
//  SignInViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/16.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "SignInViewController.h"

#import "MBProgressHUD+MJ.h"
#import "LoginViewController.h"

#import "ClassWallViewController.h"

#import "WXTabBarViewController.h"
#import <RESideMenu.h>
#import "WXLeftMenuViewController.h"

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

@interface SignInViewController ()<UITextFieldDelegate,RESideMenuDelegate>{
    
    //登陆按钮
    UIButton* loginBtn;
    
    //注册按钮
    UIButton* registerBtn;
    //背景图片
    UIImageView* backGroundView;
    
    //授权登陆
    UIButton* qqButton;
    
    UIButton* sinaWeiBoButton;
    
    UIButton* weChatButton;
    
    //用户名密码输入框
    UITextField* userTextFiled,* passwordTextFiled;
    
    
}

@property(nonatomic,strong)NSDictionary* saveAccountAndPassord;

@property(nonatomic,assign)BOOL whetherSave;

@property(nonatomic,strong)UIButton* rememberBtn;

@property(nonatomic,strong)NSDictionary* saveUserInfoDic;


@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加视图界面
    [self addSubViewToView];
    // Do any additional setup after loading the view.
}

-(void)addSubViewToView{
    
    UIImage* image = [UIImage imageNamed:@"登陆背景"];
    backGroundView = [[UIImageView alloc]initWithImage:image];
    //图片太小（图片有问题）
    backGroundView.frame = CGRectMake(0, 0, ScreenWidth+3, ScreenHeight+3);
    
    [self.view addSubview:backGroundView];
    
    //登陆按钮
    loginBtn= [[UIButton alloc]initWithFrame:CGRectMake(20, 305, ScreenWidth-40, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 6.0;
    [loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor whiteColor];
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginBtn addTarget:self action:@selector(ChooseLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //注册按钮
    
    registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 353, ScreenWidth-40, 40)];
    //[registerBtn setBackgroundImage:[UIImage imageNamed:@"注册"] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 6.0;
    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(ChooseRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:registerBtn];
    
    NSArray* imageArr = @[[UIImage imageNamed:@"新浪"],[UIImage imageNamed:@"QQ"],[UIImage imageNamed:@"微信"]];
    for (int i = 0; i<3; i++) {
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth - 180)*(i+1)/4 + 60*i, 480, 60, 60)];
        [button setBackgroundImage:imageArr[i] forState:UIControlStateNormal];
        //微信，qq，新浪
        button.tag = 500 + i;
        [button addTarget:self action:@selector(theThreePartiesLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    //用户名密码输入框
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 174, 20, 20)];
    imageV.image = [UIImage imageNamed:@"man_user_24px_11046_easyicon.net"];
    [self.view addSubview:imageV];
    
    UIImageView* imageVO = [[UIImageView alloc]initWithFrame:CGRectMake(20, 222, 20, 20)];
    imageVO.image = [UIImage imageNamed:@"lock_password_secure_24px_4831_easyicon.net"];
    [self.view addSubview:imageVO];
    
    userTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(45, 174, 305, 20)];
    [userTextFiled setBorderStyle:UITextBorderStyleNone];
    userTextFiled.placeholder = @"请输入用户名";
    userTextFiled.delegate = self;
    [self.view addSubview:userTextFiled];
    passwordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(45, 222, 305, 20)];
    [passwordTextFiled setBorderStyle:UITextBorderStyleNone];
    passwordTextFiled.placeholder = @"请输入6到16位密码";
    
    passwordTextFiled.secureTextEntry = YES; //每输入一个字符就变成点 用语密码输入
    //passwordTextFiled.borderStyle=UITextBorderStyleRoundedRect;
    passwordTextFiled.clearButtonMode=UITextFieldViewModeWhileEditing;//用户界面文本框编辑视图模式
    passwordTextFiled.delegate = self;
    [self.view addSubview:passwordTextFiled];
    
    
  
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userSave"] isEqualToString:@"save"]) {
     NSDictionary* dic  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
        userTextFiled.text = [dic objectForKey:@"account"];
        passwordTextFiled.text = [dic objectForKey:@"password"];
    }
    else{
        
    }
    //用户名密码下划线
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, 250, ScreenWidth - 40, 2)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, 197, ScreenWidth - 40, 2)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    
    UILabel *tishiyu = [[UILabel alloc]initWithFrame:CGRectMake(0, 437, ScreenWidth, 21)];
    tishiyu.text = @"------- 第三方合作账号 -------";
    tishiyu.textColor =[UIColor whiteColor];
    tishiyu.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tishiyu];
    
   
    [self addRememberWithButton];
}

-(void)addRememberWithButton{
    
    UILabel* rememberLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 260, 80, 40)];
    rememberLabel.text = [NSString stringWithFormat:@"%@",@"记住密码"];
    rememberLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:rememberLabel];
    
    UIButton* rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.frame = CGRectMake(280,270, 20, 20);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userSave"] isEqualToString:@"save"]) {
        rememberBtn.selected = YES;
        self.whetherSave = YES;
        
    }
    else{
        rememberBtn.selected = NO;
        self.whetherSave = NO;
    }
    [rememberBtn setBackgroundImage:[UIImage imageNamed:@"blackListPicture"] forState:UIControlStateSelected];
    [rememberBtn setBackgroundImage:[UIImage imageNamed:@"BListPicture"] forState:UIControlStateNormal];
    [rememberBtn addTarget:self action:@selector(rememberBtnWithEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberBtn];
    self.rememberBtn = rememberBtn;
}

-(void)rememberBtnWithEvent:(UIButton*)sender{
    

    sender.selected = !sender.selected;
    self.whetherSave = sender.selected;
    if (self.whetherSave) {
        [[NSUserDefaults standardUserDefaults]setObject:@"save" forKey:@"userSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"notSave" forKey:@"userSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
 
    }
}

-(void)ChooseLoginBtn{
    
    [MBProgressHUD showMessage:@"登录中"];

    if ([userTextFiled.text isEqualToString:@""]||[userTextFiled.text isEqual:[NSNull null]]||userTextFiled.text == nil) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入用户名"];
        //不保存账号密码
        [self WXDontSavePassword];

    }
    else if ([passwordTextFiled.text isEqualToString:@""]||[passwordTextFiled.text isEqual:[NSNull null]]||passwordTextFiled.text == nil){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入密码"];
        //不保存账号密码
        [self WXDontSavePassword];

    }
    else{
        
        
        //记住密码
        if (self.whetherSave) {
            
            self.saveUserInfoDic = [[NSMutableDictionary alloc]init];
            [self.saveUserInfoDic setValue:passwordTextFiled.text forKey:@"password"];
            [self.saveUserInfoDic setValue:userTextFiled.text forKey:@"account"];
            [[NSUserDefaults standardUserDefaults] setObject:self.saveUserInfoDic forKey:@"userData"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"save" forKey:@"userSave"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
        else{
           //不保存账号密码
            [self WXDontSavePassword];

        }
         NSLog(@"fff%d",self.whetherSave);
        NSLog(@"%@",userTextFiled.text);
        NSLog(@"%@",passwordTextFiled.text);
        NSDictionary* parameter = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",userTextFiled.text],@"nickname",[NSString stringWithFormat:@"%@",passwordTextFiled.text],@"password",nil];
        
        [AFNHttpTool POST:LoginInterface parameters:parameter success:^(id responseObject) {
            NSLog(@"%@",responseObject);
           
            NSLog(@"%@",[responseObject objectForKey:@"Message"]);
            
            if ([[responseObject objectForKey:@"Code"]isEqual:@"0"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"Message"]]];
            }
            else{
               
            [MBProgressHUD hideHUD];
            WXTabBarViewController* tabVC = [[WXTabBarViewController alloc]init];
            
            WXLeftMenuViewController * leftVC = [[WXLeftMenuViewController alloc]init];
            
            RESideMenu* sideMenuVC = [[RESideMenu alloc]initWithContentViewController:tabVC leftMenuViewController:leftVC rightMenuViewController:nil];
            //菜单栏的背景图片
            sideMenuVC.backgroundImage = [UIImage imageNamed:@"Stars"];
            //菜单栏的样式（亮的背景）
            sideMenuVC.menuPreferredStatusBarStyle = 1;
            
            sideMenuVC.delegate = self;
            
            sideMenuVC.contentViewShadowColor = [UIColor blackColor];
            
            sideMenuVC.contentViewShadowOffset = CGSizeMake(0, 0);
            
            sideMenuVC.contentViewShadowOpacity = 0.6;
            
            sideMenuVC.contentViewShadowRadius = 12;
            
            sideMenuVC.contentViewShadowEnabled = YES;
            
            [UIApplication sharedApplication].keyWindow.rootViewController = sideMenuVC;
            
            self.navigationController.navigationBarHidden = NO;
            
            }

            
        } failure:^(NSError *error) {
            NSLog(@"%ld",(long)error.code);
            [MBProgressHUD hideHUD];
        }];

    }
    
    
}

#pragma mark - 不保存密码
-(void)WXDontSavePassword{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"notSave" forKey:@"userSave"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)ChooseRegisterBtn{
    LoginViewController* loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)theThreePartiesLogin:(UIButton*)sender{
    switch (sender.tag) {
        case 501:
            //取消授权
            [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
         
            [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    NSLog(@"%@",user.uid);
                    NSLog(@"%@",user.credential);
                    NSLog(@"%@",user.credential.token);
                    NSLog(@"%@",user.nickname);
                }
                else{
                    NSLog(@"%@",error);
                }
            }];
            break;
        case 500:
            [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
            [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    NSLog(@"%@",user.uid);
                    NSLog(@"%@",user.credential);
                    NSLog(@"%@",user.credential.token);
                    NSLog(@"%@",user.nickname);
                }
                else{
                    NSLog(@"%@",error);
                }
            }];

            break;
        default:
           
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    //删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];

    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //隐藏导航栏
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
