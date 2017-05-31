//
//  LoginViewController.m
//  AXHProject
//
//  Created by kys-5 on 16/9/4.
//  Copyright © 2016年 kys-5. All rights reserved.
//

#import "LoginViewController.h"


#import "MBProgressHUD+MJ.h"

#import "ClassWallViewController.h"



@interface LoginViewController ()<UITextFieldDelegate>

//设置了几个文本框，user对应用户名；verification对应填写验证码；password对应设置密码。fieldone、fieldtwo是关于
@property (strong,nonatomic) UITextField* user;
@property (strong,nonatomic) UITextField* verification;
@property (strong,nonatomic) UITextField* password;

//obtainButton是获取验证码
//@property(nonatomic,strong)UIButton* obtainButton;
@property(nonatomic,strong)UIImageView* verificationImageView;

@property(nonatomic,strong)NSString* Random;



@property(nonatomic,strong) NSDictionary *WXYonghuOne;
@property(nonatomic,strong) NSMutableDictionary *WXPasswordTwo;




@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   self.title = @"注册";
    [self setNewView];
    // Do any additional setup after loading the view.
}

//子视图的一些内容
-(void)setNewView{
   
    
    //用户名文本框
    _user=[[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth/20,ScreenHeight/7.5, ScreenWidth-ScreenWidth/10, ScreenHeight/15)];
    _user.placeholder=@"账号";
    _user.borderStyle=UITextBorderStyleRoundedRect;
    _user.clearButtonMode=UITextFieldViewModeWhileEditing;
    _user.keyboardType=UIKeyboardTypeNumberPad;
    _user.delegate=self;
    [_user.layer setCornerRadius:4.0];
    
    [self.view addSubview:_user];
    
    //填写验证码文本框
    _verification=[[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth/20,ScreenHeight/4.4, ScreenWidth/2, ScreenHeight/15)];
    _verification.placeholder=@"验证码";
    
    _verification.delegate=self;
    [self.view addSubview:_verification];
    
    _verification.borderStyle=UITextBorderStyleRoundedRect;
    _verification.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    //点击获取验证码按钮
    //*  *//
    self.verificationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-ScreenWidth/2.7, ScreenHeight/4.4, ScreenWidth/3.1, ScreenHeight/15)];
    //[_obtainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [_obtainButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [_obtainButton.layer setCornerRadius:4.0];
    
    // Do any additional setup after loading the view, typically from a nib.
//    [_obtainButton addTarget:self action:@selector(verificationCodeActions)forControlEvents:UIControlEventTouchUpInside];
    self.verificationImageView.backgroundColor = [UIColor colorWithRed:0.773 green:0.173 blue:0.153 alpha:1];
    
    [self.verificationImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,VerificationCodeInterface]] placeholderImage:nil];
   
    self.verificationImageView.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(verificationCodeActions)];
    //为图片添加一个手势
    [self.verificationImageView addGestureRecognizer:singleTap];
    //显示图片
    [self.view addSubview:self.verificationImageView];
    
    
    //设置密码文本框
    _password=[[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth/20,ScreenHeight/3.1, ScreenWidth-ScreenWidth/10, ScreenHeight/15)];
    _password.placeholder=@"密码(6~16位英文或数字)";
    
    _password.secureTextEntry = YES;//每输入一个字符就变成点 用语密码输入
    _password.borderStyle=UITextBorderStyleRoundedRect;
    _password.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    _password.delegate=self;
    self.password=_password;
    [self.view addSubview:_password];
    
    UILabel* reglabel=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/8.5,ScreenHeight/1.7, ScreenWidth/2, ScreenHeight/20)];
    reglabel.font=[UIFont systemFontOfSize:11];
    
    reglabel.text=@"轻触“注册”按钮，即表示您同意";//设置显示文字
    reglabel.textColor=[UIColor lightGrayColor];
    [self.view addSubview:reglabel];
    
    UIButton* contentBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/1.7,ScreenHeight/1.7, ScreenWidth/2.8, ScreenHeight/18)];
    [contentBtn setTitle:@"《图片服务协议》" forState:UIControlStateNormal];
    [contentBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [contentBtn addTarget:self action:@selector(BtnDelegate:) forControlEvents:UIControlEventTouchUpInside];
    [contentBtn setTitleColor:[UIColor colorWithRed:0.616 green:0.808 blue:0.996 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:contentBtn];
    
    //立即注册按钮
    UIButton* sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/20,ScreenHeight/2.1, ScreenWidth-ScreenWidth/10, ScreenHeight/15)];
    sureBtn.backgroundColor=[UIColor colorWithRed:0.773 green:0.173 blue:0.153 alpha:1];
    [sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn.layer setCornerRadius:4.0];
    
    [sureBtn addTarget:self action:@selector(LoginToView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    //添加用户数据
    [self addUserData];
    
    
}


-(void)addUserData{
    
    _WXYonghuOne = [[NSDictionary alloc]init];
    
    _WXPasswordTwo = [[NSMutableDictionary alloc]init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _WXYonghuOne = [userDefaults objectForKey:@"userData"];
    NSLog(@"%@",_WXYonghuOne);
    
    [_WXPasswordTwo addEntriesFromDictionary:_WXYonghuOne];
    
    //在存储数据的地方,别忘了这一句
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)LoginToView{
    [MBProgressHUD showMessage:@"请求中"];
   
    
//    [AFNHttpTool POST:VerificationCodeInterface parameters:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
//    ClassWallViewController* classVC = [[ClassWallViewController alloc]init];
//    [self.navigationController pushViewController:classVC animated:YES];
    
    
    if ([_user.text isEqualToString:@""]||_user.text == nil || [_user.text isEqual:[NSNull null]]) {
          [MBProgressHUD hideHUD];
          [MBProgressHUD showError:@"请输入用户名"];
        
    }
    else if ([_verification.text isEqualToString:@""]||_verification.text == nil || [_verification.text isEqual:[NSNull null]]){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入验证码"];
    }
    else if ([_password.text isEqualToString:@""]||_password.text == nil || [_password.text isEqual:[NSNull null]]){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入密码"];
    }
    else{
       
        
        NSDictionary* parameters = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_user.text],@"nickname",[NSString stringWithFormat:@"%@",_password.text],@"password",[NSString stringWithFormat:@"%@",_verification.text],@"verifyCode",nil];
        
        [AFNHttpTool POST:registerInterface parameters:parameters success:^(id responseObject) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            
            NSLog(@"%@",responseObject);
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        }];
    }
    
        
       
//        [_WXPasswordTwo setValue:_password.text forKey:_user.text];
//        //存储数据
//        [[NSUserDefaults standardUserDefaults]setObject:_WXPasswordTwo forKey:@"userData"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//       
//        EMError* error1 = [[EMClient sharedClient]loginWithUsername:_user.text password:_password.text];
//       
//            
//            [UIApplication sharedApplication].keyWindow.rootViewController = sideMenuVC;
//    
//        else{
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"注册不成功"];
//        }
    

       
        
        
    }
    
    

    
    






-(void)verificationCodeActions{
//    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 400, 50, 30)];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,VerificationCodeInterface]]];
    self.verificationImageView.image = [UIImage imageWithData:imageData];
   // [self.view addSubview:imageView];
//    self.Random = @"";
//    
//    for(int i=0; i<6; i++)
//    {
//        self.Random = [ self.Random stringByAppendingFormat:@"%i",(arc4random() % 9)];
//    }
//    
//    NSLog(@"随机数: %@", self.Random);
//    _verification.text = self.Random;
}

-(void)BtnDelegate:(UIButton*)sender{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
