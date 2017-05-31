//
//  WXTabBarViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXTabBarViewController.h"
#import "WXNavigationViewController.h"

#import "WXCustomTabBar.h"
#import "UIImage+image.h"
//类库
#import "WXMyPersonCenterViewController.h"
#import "WXQueryViewController.h"
#import "WXFavoriteViewController.h"
#import "WXHomePageViewController.h"
#import "ClassWallViewController.h"
#import <PYSearchViewController.h>
#import "WXSearchPicturesViewController.h"

@interface WXTabBarViewController (){
    WXCustomTabBar* tabBar;
}

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation WXTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置TabBar的属性
    [self setUpTabBarItemAttr];
    
    
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor=[UIColor redColor];
    
    
    [self setUpChildViewController];
    
    [self setUpTabBar];
    
}
- (void)setUpTabBarItemAttr
{  //设置tabbar的颜色
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    // UIControlStateNormal状态下的属性
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    // 设置字体颜色
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 设置字体大小
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的属性
    NSMutableDictionary *selectAttr = [NSMutableDictionary dictionary];
    selectAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:240/255.0 green:156/255.0 blue:30/255.0 alpha:1];
    
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
}

//设置自控制器
-(void)setUpChildViewController{
    
    WXQueryViewController * queryVC = [[WXQueryViewController alloc]init];
    
    // PYSearchViewController* favoriteVC = [[PYSearchViewController alloc]init];
    NSArray *hotSeaches = @[@"北京",@"壁纸",@"表情包",@"电脑",@"动漫卡通",@"风景",@"搞笑",@"花",@"键盘",@"科技",@"蓝天",@"白云",@"老人",@"老师",@"美女",@"萌宠",@"可爱",@"汽车",@"帅哥",@"小清新",@"游戏",@"英雄联盟",@"娱乐",@"明星"
                                           ];
  
    PYSearchViewController *favoriteVC = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索图片标签" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        WXSearchPicturesViewController* searchPicturesVC = [[WXSearchPicturesViewController alloc]init];
        searchPicturesVC.imageUrlString = queryAtlasPicturesInterface;
        searchPicturesVC.title = searchText;
        searchPicturesVC.hidesBottomBarWhenPushed = YES;
        [searchViewController.navigationController pushViewController:searchPicturesVC animated:YES];
    }];
    favoriteVC.hotSearchStyle = PYHotSearchStyleColorfulTag;
    favoriteVC.searchHistoryStyle = PYSearchHistoryStyleBorderTag;

    WXHomePageViewController *homePageVC = [[WXHomePageViewController alloc] init];
    
    WXMyPersonCenterViewController * personVC = [[WXMyPersonCenterViewController alloc]init];
    
   
    
    [self setUpOneChildViewController:homePageVC image:[UIImage imageNamed:@"tabBar_icon_schedule_default"] selectedImage:[UIImage imageWithOriginalName:@"tabBar_icon_schedule"] title:@"首页"];
    
    
    [self setUpOneChildViewController:favoriteVC image:[UIImage imageNamed:@"tabBar_icon_customer_default"] selectedImage:[UIImage imageWithOriginalName:@"tabBar_icon_customer"] title:@"搜索"];
    
    
    [self setUpOneChildViewController:queryVC image:[UIImage imageNamed:@"tabBar_icon_contrast_default"] selectedImage:[UIImage imageWithOriginalName:@"tabBar_icon_contrast"] title:@"图库"];
    
    [self setUpOneChildViewController:personVC image:[UIImage imageNamed:@"tabBar_icon_mine_default"] selectedImage:[UIImage imageWithOriginalName:@"tabBar_icon_mine"] title:@"我的"];
    
}
- (void)setUpTabBar
{
    [self setValue:[[WXCustomTabBar alloc] init] forKeyPath:@"tabBar"];
    
    
    //    // 自定义tabBar
    //    tabBar = [[AXHTabBar alloc] initWithFrame:self.tabBar.bounds];
    //    tabBar.backgroundColor = [UIColor clearColor];
    //
    //    // 设置代理
    //    tabBar.delegate = self;
    //
    //    // 给tabBar传递tabBarItem模型
    //    tabBar.items = self.items;
    //    //    NSLog(@"tabBar.items == %@",tabBar.items);
    //    // 添加自定义tabBar
    //    [self.tabBar addSubview:tabBar];
    
    // 移除系统的tabBar
    //    [self.tabBar removeFromSuperview];
}


-(void)setUpOneChildViewController:(UIViewController *)VC image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    
    VC.title = title;
    
    VC.tabBarItem.image = image;
    
    VC.tabBarItem.selectedImage = selectedImage;
    
    
    // 保存tabBarItem模型到数组
    [self.items addObject:VC.tabBarItem];
    WXNavigationViewController *nav = [[WXNavigationViewController alloc] initWithRootViewController:VC];
    [self addChildViewController:nav];
    
    
}
#pragma mark - 当点击tabBar上的按钮调用
//- (void)tabBar:(AXHTabBar *)tabBar didClickButton:(NSInteger)index
//{
//    self.selectedIndex = index;
//}
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
