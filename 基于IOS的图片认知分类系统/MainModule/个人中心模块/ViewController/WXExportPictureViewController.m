//
//  WXExportPictureViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/22.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXExportPictureViewController.h"

#import "WXPictureCollectionViewCell.h"

#import "Image.h"

@interface WXExportPictureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak)UICollectionView* myExportCollectionView;


@property (nonatomic, strong) NSMutableArray *images;

@property(nonatomic,strong)NSMutableArray* dataArray;

@property(nonatomic,strong)NSMutableArray* allPicturesDataArray;

@property(nonatomic,assign)int number;

@end

@implementation WXExportPictureViewController

-(NSMutableArray*)images{
    if (!_images) {
        _images = [[NSMutableArray alloc]init];
        
    }
    return _images;
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自定义布局对象
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    //垂直布局 Vertical 水平布局 Horizontal
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.myExportCollectionView = collectionView;
    
    //注册cell
    [self.myExportCollectionView registerNib:[UINib nibWithNibName:@"WXPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UICollectionCell"];
    self.myExportCollectionView.backgroundColor = [UIColor clearColor];
    
   
   [self loadDataToView];
    // Do any additional setup after loading the view.
}



/**
 加载数据到界面
 */
-(void)loadDataToView{
//    NSDictionary* dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",@"dd"],@"picture",nil];
//    [AFNHttpTool POST:exportPicturesInterface parameters:dataDic success:^(id responseObject) {
//        //NSArray* array = [[NSArray alloc]initWithArray:];
//    } failure:^(NSError *error) {
//        
//    }];

    [MBProgressHUD showMessage:@"正在请求"];
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",@"0",@"index",nil];
      
    [AFNHttpTool POST:exportPicturesInterface parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"Code"]isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:WXFailureText];
        }
        else{
            NSArray* array = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary* dic  = obj;
                NSString* string = [dic objectForKey:@"picture"];
                [self.dataArray addObject:string];
                Image *image = [Image imageWithImageDic:dic];
                [self.images addObject:image];
                if (stop) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:WXSuccessText];
                    [self.myExportCollectionView reloadData];
                }
                
            }];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"%@",error);
    }];

    
}
#pragma mark - UICollectionDataSource
//定义展示的UICollectionViewCell  item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
//定义UICollectionView  section 的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个UICollectionView 展示的内容
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"UICollectionCell";
    
    WXPictureCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}
//定义每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-50)/4,100);
}
//定义section中不同的section之间的行间距（ 设置最小行间距，也就是前一行与后一行的中间最小间隔  ）
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
//定义每个item之间的间距（设置最小列间距，也就是左行与右一行的中间最小间隔  ）
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    /*
     *UIEdgeInsets UIEdgeInsets
     *CGFloat top
     *CGFloat left
     *CGFloat bottom
     *CGFloat right
     */
    //设置每个cell上下左右相距
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
