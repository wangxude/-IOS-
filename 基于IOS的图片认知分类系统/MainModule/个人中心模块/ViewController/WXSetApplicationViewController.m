//
//  WXSetApplicationViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/10.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXSetApplicationViewController.h"

#import "SignInViewController.h"



@interface WXSetApplicationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* setApplicationTableView;

@property(nonatomic,strong)NSArray* titleArray;

@end

@implementation WXSetApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleArray = @[@"账号管理",@"推送消息",@"清理缓存",@"退出登录"];
    
    self.setApplicationTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.setApplicationTableView.delegate = self;
    self.setApplicationTableView.dataSource = self;
    [self.view addSubview:self.setApplicationTableView];
    
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"setCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.titleArray[indexPath.row];
        }else{
         cell.textLabel.text = self.titleArray[indexPath.row];
            UISwitch* switchOne = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth*0.8,10, ScreenWidth*0.15, 30)];
            [cell.contentView addSubview:switchOne];
        }
        
    }
    else{
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         cell.textLabel.text = self.titleArray[indexPath.row+2];
    }
    
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIWindow* window = [[[UIApplication sharedApplication]delegate]window];//获得根窗口
    SignInViewController* signInVC = [[SignInViewController alloc]init];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:signInVC];
    window.rootViewController = nav;
    
    //转场动画
    CATransition* myTransition = [CATransition animation];
    //转场动画持续时间
    myTransition.duration = 0.35;
    //计时函数，从头到尾的流畅度？？？
    myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
    ///转场动画类型
    myTransition.type = kCATransitionFade;
    //添加动画 （转场动画是添加在层上的动画）
    [window.layer addAnimation:myTransition forKey:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSMutableArray* vcArray = [self.navigationController.viewControllers mutableCopy];
    [vcArray removeAllObjects];
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
