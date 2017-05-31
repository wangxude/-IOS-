//
//  WXDailyRecommendViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/22.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXDailyRecommendViewController.h"

#import "Image.h"
#import "YuriWaterfallLayout.h"
#import "FlowCollectionViewCell.h"
//瀑布流
#import "JLPhotoBrowser.h"

//标签界面
#import "WXAddPictureLabelViewController.h"


static NSString* const KIdentifier = @"imageIdentifier";

@interface WXDailyRecommendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, YuriWaterFallLayoutDelegate,FlowCollectionViewCellDelegate>

/**
 布局的视图
 */
@property(nonatomic,strong)UICollectionView* showImageCollectionView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *images;

@property(nonatomic,strong)NSMutableArray* dataArray;






@end

@implementation WXDailyRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _images = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
  
    self.view.backgroundColor = [UIColor redColor];
    
    [self initWithData];
    [self setupCollectionView];
    
    //添加下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefresh)];
    //添加上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(PullOnLoading)];
    // Do any additional setup after loading the view.
}

/**
 上拉加载
 */
-(void)PullOnLoading{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",nil];
    [AFNHttpTool POST:[NSString stringWithFormat:@"%@",self.dailyRecordString] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray* array = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
        
        
        for (int i = 0; i < array.count; i++) {
            NSDictionary* dic  = array[i];
            NSString* string = [dic objectForKey:@"picture"];
            [self.dataArray addObject:string];
            Image *image = [Image imageWithImageDic:dic];
            [self.images addObject:image];
            
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"请求成功"];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
/**
 下拉刷新
 */

-(void)dropDownRefresh{
    [self.images removeAllObjects];
    [self.dataArray removeAllObjects];
    NSLog(@"%@",self.images);
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",nil];
    
   
    
    [AFNHttpTool POST:[NSString stringWithFormat:@"%@",self.dailyRecordString] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray* array = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
        
       
        for (int i = 0; i < array.count; i++) {
            NSDictionary* dic  = array[i];
            NSString* string = [dic objectForKey:@"picture"];
            [self.dataArray addObject:string];
            Image *image = [Image imageWithImageDic:dic];
            [self.images addObject:image];
            
            
        }
        NSLog(@"%@",self.images);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"请求成功"];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void)initWithData{
   
    [MBProgressHUD showMessage:@"正在请求"];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",nil];
    
    
    [AFNHttpTool POST:[NSString stringWithFormat:@"%@",self.dailyRecordString] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray* array = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
        
       
        for (int i = 0; i < array.count; i++) {
            NSDictionary* dic  = array[i];
            NSString* string = [dic objectForKey:@"picture"];
            [self.dataArray addObject:string];
            Image *image = [Image imageWithImageDic:dic];
            [self.images addObject:image];
          
            
         }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"请求成功"];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        

         } failure:^(NSError *error) {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"请求成功"];
             [self.collectionView.mj_footer endRefreshing];
             [self.collectionView.mj_header endRefreshing];
             [self.collectionView reloadData];
             NSLog(@"%@",error);
    }];
    
    

}

- (void)setupCollectionView {
    
    YuriWaterfallLayout *layout = [YuriWaterfallLayout waterFallLayoutWithColumnCount:2];
    
    [layout setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    layout.delegate = self;
//        [layout setItemHeightBlock:^CGFloat(CGFloat itemWidth, NSIndexPath *indexPath) {
//            Image *image = self.images[indexPath.item];
//            return image.imageH / image.imageW * itemWidth;
//        }];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FlowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];


    
}
#pragma mark 提交图片
-(void)submitPictures:(NSDictionary*)dic index:(int)pictureIndex{
    [MBProgressHUD showMessage:@"提交中"];
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",[NSString stringWithFormat:@"%@",dic[@"picture"]],@"picture",[NSString stringWithFormat:@"%@",dic[@"tag1"]],@"tag1",[NSString stringWithFormat:@"%@",dic[@"tag2"]],@"tag2",[NSString stringWithFormat:@"%@",dic[@"tag3"]],@"tag3",nil];
    [AFNHttpTool POST:upLoadPictures parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        int responseNumber = [[responseObject valueForKey:@"Code"] intValue];
        if (responseNumber ==1) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"提交成功"];
            
            
            NSDictionary* oneDic = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",[NSString stringWithFormat:@"%@",dic[@"picture"]],@"picture",nil];
             [AFNHttpTool POST:getOnePictureLabel parameters:oneDic success:^(id responseObject) {
                 NSLog(@"44444444%@",responseObject);
                 
                 
                 NSDictionary* itemPictureDataDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",responseObject[@"picture"]],@"picture",[NSString stringWithFormat:@"%@",responseObject[@"tag1"]],@"tag1",[NSString stringWithFormat:@"%@",responseObject[@"tag2"]],@"tag2",[NSString stringWithFormat:@"%@",responseObject[@"tag3"]],@"tag3",nil];
                 
                 Image *image = [Image imageWithImageDic:itemPictureDataDic];
                
                 [self.images replaceObjectAtIndex:pictureIndex withObject:image];
                 NSIndexPath* pictureIndexPath =[NSIndexPath indexPathForRow:pictureIndex inSection:0];
                 [UIView performWithoutAnimation:^{
                     [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:pictureIndexPath, nil]];
                 }];
                 
                 
                 
             } failure:^(NSError *error) {
                 
             }];
           
        }
        else{
            [MBProgressHUD showError:@"提交失败"];
            [MBProgressHUD hideHUD];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"%@",error);
        
    }];
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(YuriWaterfallLayout *)waterfallLayout itemHeightWithItemWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    
   
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    Image *image = self.images[indexPath.item];
  
    return image.imageH / image.imageW * itemWidth +35;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld",self.images.count);
    if (self.images.count == 0) {
        return 0;
    }
    NSLog(@"%ld",self.images.count);
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.delegate = self;
    Image *image = self.images[indexPath.item];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    cell.iconImageView.userInteractionEnabled = YES;
    cell.iconImageView.tag = 1010+indexPath.item;
    [cell.iconImageView addGestureRecognizer:tap];
   
    cell.labelTextArray = image.labelArray;
    cell.imageURL = image.imageURL;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   

}


- (void)tapImageView:(UITapGestureRecognizer *)tap

{
    //1.创建JLPhoto数组
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<self.images.count; i++) {
        
        UIImageView *child = [self.view viewWithTag:1010+i];
        JLPhoto *photo = [[JLPhoto alloc] init];
        //1.1设置原始imageView
        photo.sourceImageView = child;
        //1.2设置大图URL
        photo.bigImgUrl = self.dataArray[i];
       
        //1.3设置图片tag
        photo.tag = i;
        [photos addObject:photo];
        
    }
    
    //2. 创建图片浏览器
    JLPhotoBrowser *photoBrowser = [JLPhotoBrowser photoBrowser];
    //2.1 设置JLPhoto数组
    photoBrowser.photos = photos;
    //2.2 设置当前要显示图片的tag
    photoBrowser.currentIndex = (int)tap.view.tag-1010;
    NSLog(@"%@",self.dataArray[photoBrowser.currentIndex]);
    photoBrowser.isLoadLocalOrNetData = 0;
    //2.3 显示图片浏览器
    [photoBrowser show];

}


#pragma mark - 添加数据的按钮
-(void)flowCollectionCell:(FlowCollectionViewCell *)cell didClickButton:(UIButton *)button{
    //当前点击的item
    NSIndexPath* index = [self.collectionView indexPathForCell:cell];
    
    WXAddPictureLabelViewController* addVC = [[WXAddPictureLabelViewController alloc]init];
    addVC.block = ^(NSDictionary *dic) {
        
        [self submitPictures:dic index:index.row];
    };
    addVC.imageUrl = cell.imageURL;
    addVC.urlString = self.dataArray[index.row];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
   // self.images = nil;
//    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//    
//    // 1.取消正在下载的操作
//    [mgr cancelAll];
//    
//    // 2.清除内存缓存
//    [mgr.imageCache clearMemory];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //self.images = [[NSMutableArray alloc]init];
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
