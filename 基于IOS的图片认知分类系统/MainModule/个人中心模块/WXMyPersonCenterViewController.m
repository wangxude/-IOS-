//
//  WXMyPersonCenterViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXMyPersonCenterViewController.h"
//头部视图
#import "HeadView.h"

//设置应用
#import "WXSetApplicationViewController.h"
//编辑个人中心
#import "WXEditInformationViewController.h"
//评分界面
#import "WXPointViewController.h"
//发布图片
#import "WXPubilishPicturesViewController.h"
//导出图片
#import "WXExportPictureViewController.h"

@interface WXMyPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
//个人中心
@property(nonatomic,strong)UITableView* personTabeleView;
//标题数组
@property(nonatomic,strong)NSArray* titleArray;
//图片数组
@property(nonatomic,strong)NSArray* imagesArray;



@end

@implementation WXMyPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleArray = [[NSArray alloc]initWithObjects:@"发布图片",@"导出图片",@"我的收藏",@"历史记录",@"欢迎评分",@"意见反馈",nil];
    self.imagesArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"发布动态"],[UIImage imageNamed:@"留言板"],[UIImage imageNamed:@"我的群组"],[UIImage imageNamed:@"我的好友"], [UIImage imageNamed:@"给我打分"],[UIImage imageNamed:@"意见反馈"],nil];

    
    self.personTabeleView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.personTabeleView.delegate = self;
    self.personTabeleView.dataSource = self;
    [self.view addSubview:self.personTabeleView];
    
 //   self.personTabeleView.tableHeaderView = [self footView];
    
    UIButton* barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 32, 32);
    [barButton setBackgroundImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(setTheApplication) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = item;
   
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - 设置应用
-(void)setTheApplication{
    WXSetApplicationViewController* setVC = [[WXSetApplicationViewController alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    setVC.title = @"设置应用";
    [self.navigationController pushViewController:setVC animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    else{
        //删除cell中的子对象，防止覆盖的问题
        while ([cell.contentView.subviews lastObject]!=NULL) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
   
    //移除之前的cell
    for (UIView* subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    //布局
    if (indexPath.section==0) {
        HeadView* footView = [[HeadView alloc]init];
        footView.frame = CGRectMake(0, 0, ScreenWidth, 100);
        footView.backgroundColor = WXColor(110, 168, 253);
        [cell.contentView addSubview:footView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1){
        cell.imageView.image = self.imagesArray[indexPath.row];
        cell.textLabel.text = self.titleArray[indexPath.row];
    }
    else if (indexPath.section == 2){
        cell.imageView.image = self.imagesArray[indexPath.row+2];
        cell.textLabel.text = self.titleArray[indexPath.row+2];
    }
    else{
        cell.imageView.image = self.imagesArray[indexPath.row+4];
        cell.textLabel.text = self.titleArray[indexPath.row+4];
    }

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //设置边线
    [self.personTabeleView setSeparatorInset:UIEdgeInsetsZero];
    [self.personTabeleView setLayoutMargins:UIEdgeInsetsZero];
    

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section== 0?100:50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"发布图片"]) {
        WXPubilishPicturesViewController* publishVC = [[WXPubilishPicturesViewController alloc]init];
        publishVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publishVC animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"欢迎评分"]){
        WXPointViewController* pointVC = [[WXPointViewController alloc]init];
        pointVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pointVC animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"导出图片"]){
        WXExportPictureViewController* exportVC = [[WXExportPictureViewController alloc]init];
        exportVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:exportVC animated:YES];
    }
    else{
        WXEditInformationViewController* editVC = [[WXEditInformationViewController alloc]init];
        editVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editVC animated:YES];
    }
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
