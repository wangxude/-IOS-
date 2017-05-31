//
//  WXAtlasQueryViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/9.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXAtlasQueryViewController.h"


#import "Image.h"
#import "YuriWaterfallLayout.h"
#import "FlowCollectionViewCell.h"
//瀑布流
#import "JLPhotoBrowser.h"

//弹出视图
#import "WXPopView.h"


@interface WXAtlasQueryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, YuriWaterFallLayoutDelegate,FlowCollectionViewCellDelegate>

/**
 布局的视图
 */
@property(nonatomic,strong)UICollectionView* showImageCollectionView;



@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *images;

@property(nonatomic,strong)NSMutableArray* dataArray;

@property(nonatomic,strong)NSMutableArray* allPicturesDataArray;

@property(nonatomic,assign)int number;


@end

@implementation WXAtlasQueryViewController


static NSString* const KIdentifier = @"imageIdentifier";




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.title);
    NSLog(@"%d",self.number++);
    
    _images = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    self.allPicturesDataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.number = 1;
    
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
    
    NSNumber* number = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@",self.title]];
    int i = [number intValue];
    
    self.number = ++i;
    NSNumber* dataNumber = [NSNumber numberWithInt:self.number];
    [[NSUserDefaults standardUserDefaults]setObject:dataNumber forKey:[NSString stringWithFormat:@"%@",self.title]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"ttttttttttt%d",self.number);
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.number],@"index",[NSString stringWithFormat:@"%@",self.title],@"searchValue",nil];
    [AFNHttpTool POST:queryAtlasPicturesInterface parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray* array = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
        NSLog(@"%@",responseObject);
        
//        for (int i = 0; i < array.count; i++) {
//            NSDictionary* dic  = array[i];
//            NSString* string = [dic objectForKey:@"picture"];
//            [self.dataArray addObject:string];
//            Image *image = [Image imageWithImageDic:dic];
//            [self.images addObject:image];
//            
//            
//        }
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showSuccess:@"请求成功"];
//        [self.collectionView.mj_footer endRefreshing];
//        [self.collectionView.mj_header endRefreshing];
//        [self.collectionView reloadData];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary* dic  = obj;
            NSString* string = [dic objectForKey:@"picture"];
            [self.dataArray addObject:string];
            Image *image = [Image imageWithImageDic:dic];
            [self.images addObject:image];
            if (stop) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"请求成功"];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView reloadData];
            }
            
        }];

        
        
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

    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%@",self.title],@"searchValue",nil];
    
    [AFNHttpTool POST:queryAtlasPicturesInterface parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray* array = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
        
        
//        for (int i = 0; i < array.count; i++) {
//            NSDictionary* dic  = array[i];
//            NSString* string = [dic objectForKey:@"picture"];
//            [self.dataArray addObject:string];
//            Image *image = [Image imageWithImageDic:dic];
//            [self.images addObject:image];
//            
//            
//        }
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showSuccess:@"请求成功"];
//        [self.collectionView.mj_footer endRefreshing];
//        [self.collectionView.mj_header endRefreshing];
//        [self.collectionView reloadData];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary* dic  = obj;
            NSString* string = [dic objectForKey:@"picture"];
            [self.dataArray addObject:string];
            Image *image = [Image imageWithImageDic:dic];
            [self.images addObject:image];
            if (stop) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"请求成功"];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView reloadData];
            }

        }];
        //NSLog(@"%@",self.images);
       
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)initWithData{
    NSNumber* dataNumber = [NSNumber numberWithInt:1];
    [[NSUserDefaults standardUserDefaults]setObject:dataNumber forKey:[NSString stringWithFormat:@"%@",self.title]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [MBProgressHUD showMessage:@"正在请求"];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%@",self.title],@"searchValue",nil];
    [AFNHttpTool POST:queryAtlasPicturesInterface parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray* array = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];

//        
//        for (int i = 0; i < array.count; i++) {
//            NSDictionary* dic  = array[i];
//            NSString* string = [dic objectForKey:@"picture"];
//            [self.dataArray addObject:string];
//            Image *image = [Image imageWithImageDic:dic];
//            [self.images addObject:image];
//            
//            
//        }
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showSuccess:@"请求成功"];
//        [self.collectionView.mj_footer endRefreshing];
//        [self.collectionView.mj_header endRefreshing];
//        [self.collectionView reloadData];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary* dic  = obj;
            NSString* string = [dic objectForKey:@"picture"];
            [self.dataArray addObject:string];
            Image *image = [Image imageWithImageDic:dic];
            [self.images addObject:image];
            if (stop) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"请求成功"];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView reloadData];
            }
            
        }];

        
        
    } failure:^(NSError *error) {
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
    
//    UIButton *Publishbtn=[[UIButton alloc]initWithFrame:CGRectMake(20,ScreenHeight-45-64,ScreenWidth-40,40)];
//    [Publishbtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:30/255.0 blue:37/255.0 alpha:1]];
//    [Publishbtn  addTarget:self action:@selector(submitPictures) forControlEvents:UIControlEventTouchUpInside];
//    [Publishbtn setTitle:@"确定提交" forState:UIControlStateNormal];
//    Publishbtn.layer.cornerRadius = 5.0;
//    [self.view addSubview:Publishbtn];
    
    
}
-(void)submitPictures{
    [MBProgressHUD showMessage:@"提交中"];
    //{"nickname":value,data[{"picture":value,data[{"picture":value,"tag1":value",tag2":value,"tag3":value},{"picture":value,"tag1":value",tag2":value,"tag3":value}]}}
    NSArray* pictureArray = self.allPicturesDataArray;
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",pictureArray,@"data",nil];
    [AFNHttpTool POST:upLoadPictures parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        int responseNumber = [[responseObject valueForKey:@"Code"] intValue];
        if (responseNumber ==1) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"提交成功"];
            
            NSLog(@"fffffff");
        }
        else{
            [MBProgressHUD showError:@"提交失败"];
            [MBProgressHUD hideHUD];
            NSLog(@"555555");
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"%@",error);
        NSLog(@"777777777777");
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
    photoBrowser.isLoadLocalOrNetData = 0;
    //2.3 显示图片浏览器
    [photoBrowser show];
    
}


#pragma mark - 添加数据的按钮
-(void)flowCollectionCell:(FlowCollectionViewCell *)cell didClickButton:(UIButton *)button{
    //当前点击的item
    NSIndexPath* index = [self.collectionView indexPathForCell:cell];
    
    
    WXPopView* popView=[[WXPopView alloc]initWithFrame:CGRectMake(50, ScreenHeight/4, ScreenWidth-100,ScreenHeight*0.4)];
    NSLog(@"%@",cell.imageURL);
    
    popView.imageUrl = cell.imageURL ;
    popView.urlString = self.dataArray[index.row];
    [popView showView];
    popView.block=^(NSDictionary *dic){
        
        [self.allPicturesDataArray addObject:dic];
        
    };
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.images = nil;
//    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//    
//    // 1.取消正在下载的操作
//    [mgr cancelAll];
//    
//    // 2.清除内存缓存
//    [mgr.imageCache clearMemory];
    NSNumber* dataNumber = [NSNumber numberWithInt:self.number];
    [[NSUserDefaults standardUserDefaults]setObject:dataNumber forKey:[NSString stringWithFormat:@"%@",self.title]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
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
