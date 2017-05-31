//
//  WXHomePageViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXHomePageViewController.h"

#import <SDCycleScrollView.h>
#import <RESideMenu.h>

//每日推荐
#import "WXDailyRecommendViewController.h"
//猜你喜欢
#import "ClassWallViewController.h"

#import "WXHomeCollectionViewCell.h"

#import "WXHomeCollectionReusableView.h"

@interface WXHomePageViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WXHomeCollectionReusableViewDelegate>

@property(nonatomic,strong) NSMutableArray* dataImage;
//分类图片
@property(nonatomic,weak)UICollectionView* classificationCollectionView;



@end

@implementation WXHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"侧滑" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
//    UIImageView* imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    imageView.image = [UIImage imageNamed:@"Balloon"];
//    [self.view addSubview:imageView];
//    
//    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
//    UIImageView * backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"005.jpg"]];
//    [self.view addSubview:backView];
    
    
    NSArray* images = @[@"钢结构.jpg",@"青岛地区.jpg",@"X80.jpg",@"几种常见.jpg",@"管线.jpg",@"国家材料.jpg",@"钢铁材料.jpg",@"氟碳层.jpg",@"长效防腐.jpg"];
    
    NSArray* titles = @[@"钢结构桥梁的腐蚀控制",@"青岛几种典型钢大气腐蚀数据",@"X80管线钢实验数据",@"常见钢的海水腐蚀专题",@"管线钢土壤腐蚀数据专题",@"国家材料环境腐蚀平台数据",@"钢铁材料及制品大气腐蚀数据",@"氟碳涂层在自然环境中的腐蚀",@"防腐涂层在热带海水22年的腐蚀"];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 180) imageNamesGroup:images];
    
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.backgroundColor=[UIColor clearColor];
    
    cycleScrollView.titlesGroup= titles;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.pageControlAliment=SDCycleScrollViewPageContolAlimentRight;
    [self.view addSubview:cycleScrollView];
    
    //[self.view addSubview:[self headView]];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 180, ScreenWidth, ScreenHeight-180-(ScreenWidth-70)/3) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.classificationCollectionView = collectionView;
    self.classificationCollectionView.backgroundColor = WXColor(239, 239, 244);
    
    [collectionView registerNib:[UINib nibWithNibName:@"WXHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WXHomeCollectionViewCell"];
    
//    [collectionView registerNib:[UINib nibWithNibName:@"WXHomeCollectionViewCell" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[WXHomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
       // Do any additional setup after loading the view.
}
-(void)homeCollectionReuseableView:(WXHomeCollectionReusableView *)collectionView didClickButton:(UIButton *)button{
    if (button.tag == 102) {
        ClassWallViewController* classVC = [[ClassWallViewController alloc]init];
        classVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classVC animated:YES];
    }
    else{
        WXDailyRecommendViewController* dailyVC = [[WXDailyRecommendViewController alloc]init];
        dailyVC.dailyRecordString = returnImageInterface;
        dailyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dailyVC animated:YES];
        
        
    }

}


#pragma mark - WXHomeCollectionViewCell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake(ScreenWidth, 580);
    
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(ScreenWidth, (ScreenWidth-70)/3);
    return size;
}



-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"WXHomeCollectionViewCell";
    
    
    WXHomeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* headerIndertifier  = @"header";
       UICollectionReusableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIndertifier forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader) {
        
        WXHomeCollectionReusableView* head = (WXHomeCollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIndertifier forIndexPath:indexPath];
        [head initWithFrame:CGRectMake(0, 0, 200, 200) ImageArray:nil];
        head.delegate = self;
        resuableView = head;
    }
    return resuableView;
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
