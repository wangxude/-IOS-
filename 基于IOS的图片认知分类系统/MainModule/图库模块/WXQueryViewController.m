//
//  WXQueryViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXQueryViewController.h"

#import "ZJScrollPageView.h"
#import "WXAtlasQueryViewController.h"

@interface WXQueryViewController ()<ZJScrollPageViewDelegate>

@property(nonatomic,strong)NSArray<NSString*> *titles;
@property(nonatomic,strong)NSArray<UIViewController*>* childVC;
@property(nonatomic,strong)ZJScrollPageView* scrollPageView;


@end

@implementation WXQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //必要的设置, 如果没有设置可能导致内容显示不正常
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle* style = [[ZJSegmentStyle alloc]init];
    //显示滚动条
    style.showLine = YES;
    style.gradualChangeTitleColor = YES;
    self.titles = @[@"北京",@"壁纸",@"表情包",@"电脑",@"动漫卡通",@"风景",@"搞笑",@"花",@"键盘",@"科技",@"蓝天",@"白云",@"老人",@"老师",@"美女",@"萌宠",@"可爱",@"汽车",@"帅哥",@"小清新",@"游戏",@"英雄联盟",@"娱乐",@"明星"
                    ];
    //初始化
    _scrollPageView = [[ZJScrollPageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:_scrollPageView];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfChildViewControllers{
    return self.titles.count;
}

-(UIViewController<ZJScrollPageViewChildVcDelegate>*)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index{
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
    childVc = [[WXAtlasQueryViewController alloc]init];
    childVc.title = self.titles[index];
    
    
    }
    return childVc;
}
//-(void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index{
//
//    NSLog(@"%@",childViewController.title);
//    NSLog(@"%ld",(long)index);
//    NSLog(@"%@",scrollPageController);
//    
//}



- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
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
