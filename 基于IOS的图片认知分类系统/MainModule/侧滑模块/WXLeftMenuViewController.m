//
//  WXLeftMenuViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/22.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXLeftMenuViewController.h"

@interface WXLeftMenuViewController ()

@property(nonatomic,strong) UITableView* menuTableView;

@property(nonatomic,strong) NSArray* imageArray;
@property(nonatomic,strong) NSArray* titleArray;


@end

@implementation WXLeftMenuViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //列表上的数据(快捷创建数组为了安全应该用plist表）
    self.titleArray = @[@"主界面",@"二维码",@"设置",@"关于我们",@"更多"];
    
    self.imageArray = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    
    self.menuTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5)/2, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
    
    self.menuTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    //设置为不透明的
    self.menuTableView.opaque = NO;
    
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.backgroundView = nil;
    //没有分割线
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //禁止拖动
    self.menuTableView.bounces = NO;
    
    [self.view addSubview:self.menuTableView];
    // Do any additional setup after loading the view.
}
#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    AXHProfileViewController* profileVC = [[AXHProfileViewController alloc]init];
//    
//    AXHSettingsViewController* settingsVC = [[AXHSettingsViewController alloc]init];
//    
//    AXHCollectionViewController* collectingVC = [[AXHCollectionViewController alloc]init];
//    
//    switch (indexPath.row) {
//        case 0:
//            [self.sideMenuViewController setContentViewController:[[CLTabBarViewController alloc]init] animated:YES] ;
//            [self.sideMenuViewController hideMenuViewController];
//            break;
//            
//        case 1:
//            
//            
//            [self.sideMenuViewController setContentViewController:[[CLNavigationViewController alloc]initWithRootViewController:profileVC] animated:YES];
//            
//            [self.sideMenuViewController hideMenuViewController];
//            
//            break;
//            
//        case 2:
//            
//            [self.sideMenuViewController setContentViewController:[[CLNavigationViewController alloc]initWithRootViewController:settingsVC] animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//            break;
//            
//        case 3:
//            
//            [self.sideMenuViewController setContentViewController:[[CLNavigationViewController alloc]initWithRootViewController:collectingVC] animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//            
//            break;
//        default:
//            break;
//    }
}



#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor lightGrayColor];
    //不明白
    cell.selectedBackgroundView = [[UIView alloc]init];
    
    return cell;
    
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
