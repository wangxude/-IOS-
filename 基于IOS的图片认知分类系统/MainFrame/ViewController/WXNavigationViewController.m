//
//  WXNavigationViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXNavigationViewController.h"

#import "UIBarButtonItem+Item.h"

#import "WXCustomTabBar.h"

@interface WXNavigationViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation WXNavigationViewController

+(void)initialize{
    UIBarButtonItem* item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary* titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:240/255.0 green:156/255.0 blue:30/255.0 alpha:1];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor colorWithRed:240/255.0 green:156/255.0 blue:30/255.0 alpha:1]}];
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].translucent = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //设置非控制器导航条的内容
    //设置导航条左边按钮
    if (self.viewControllers.count != 0)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"]
                          forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(backTopre)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 30, 30);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.navigationItem.leftBarButtonItem = menuButton;
        //        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_back"] highImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] target:self action:@selector(backTopre) forControlEvents:UIControlEventTouchUpInside];
    }
    [super pushViewController:viewController animated:animated];
    
}
- (void)backTopre
{
    [self popViewControllerAnimated:YES];
}
//导航控制器跳转完成的时候调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {//显示跟控制器
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else
    {//不是显示更控制器
        //实现滑动返回功能
        //清空滑动返回手势的代理，就能实现活动功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
//直接返回子控制器tabBar上的按钮会重新加载要获取TabBarVC重新删除
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    // 删除系统自带的tabBarButton
    //    for (UIView *tabBarButton in tabBarVc.tabBar.subviews) {
    //        if (![tabBarButton isKindOfClass:[AXHTabBar class]]) {
    //            [tabBarButton removeFromSuperview];
    //        }
    //    }
    
    
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
