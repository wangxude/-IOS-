//  ClassWallViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "ClassWallViewController.h"
#import "CCDraggableContainer.h"
#import "CustomCardView.h"
//我喜欢的图片
#import "WXSearchPicturesViewController.h"
//加载框架
#import "MBProgressHUD+MJ.h"

@interface ClassWallViewController ()<CCDraggableContainerDelegate,CCDraggableContainerDataSource>
//视图容器
@property(nonatomic, strong)CCDraggableContainer* container;
//图片数据源
@property(nonatomic,strong)NSMutableArray* imageUrlDataArray;
//我喜欢的按钮
@property(nonatomic,weak)UIButton* likeButton;
//我不喜欢的按钮
@property(nonatomic,weak)UIButton* dislikeButton;
//我喜欢的记录
@property(nonatomic,weak)UIButton* recordButton;

@property(nonatomic,assign)int  countNumber;

@end

@implementation ClassWallViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setUpUI];
    
    // Do any additional setup after loading the view.
}

-(void)setUpUI{
    self.container = [[CCDraggableContainer alloc]initWithFrame:CGRectMake(0, 20, CCWidth, CCWidth) style:CCDraggableStyleUpOverlay];
    self.container.delegate = self;
    self.container.dataSource = self;
    [self.view addSubview:self.container];
    //创建按钮
    UIButton* dislikeBtn = [[UIButton alloc]init];
    [self.view addSubview:dislikeBtn];
    
    UIButton* likeBtn = [[UIButton alloc]init];
    [self.view addSubview:likeBtn];
    
    UIButton * recordBtn = [[UIButton alloc]init];
    [self.view addSubview:recordBtn];
    
    dislikeBtn.sd_layout
    .bottomSpaceToView(self.view, 40)
    .leftSpaceToView(self.view, 20)
    .widthIs(70)
    .heightIs(70);
    
    likeBtn.sd_layout
    .bottomSpaceToView(self.view, 40)
    .rightSpaceToView(self.view, 20)
    .widthIs(70)
    .heightIs(70);
    
    recordBtn.sd_layout
    .bottomSpaceToView(self.view, 50)
    .leftSpaceToView(dislikeBtn, 50)
    .rightSpaceToView(likeBtn, 50)
    .heightIs(40);
    
    [dislikeBtn setImage:[UIImage imageNamed:@"nope"] forState:UIControlStateNormal];
    [dislikeBtn addTarget:self action:@selector(dislikeBtnToEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [likeBtn setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(likeBtnToEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [recordBtn setTitle:@"我喜欢的" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(queryToRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    self.dislikeButton = dislikeBtn;
    self.likeButton = likeBtn;
    
    
}
//加载数据源
-(void)loadData{
    [_imageUrlDataArray removeAllObjects];
    _imageUrlDataArray = [[NSMutableArray alloc]init];
    //[MBProgressHUD showMessage:@"请求中"];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",nil];
    [AFNHttpTool POST:returnImageInterface parameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"Code"]isEqualToString:@"1"]) {
                NSArray* array = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [self.imageUrlDataArray addObject:obj];
                    if (stop) {
//                        [MBProgressHUD hideHUD];
//                        [MBProgressHUD showSuccess:@"请求成功"];
                        [self.container reloadData];
                    }
                }];
      
            }
            else{
                if ([[responseObject objectForKey:@"Code"]isEqualToString:@"0"]) {
                    NSString * responseString = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"Message"]];
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",responseString]];
                }
               
            }
      } failure:^(NSError *error) {
//          [MBProgressHUD hideHUD];
//          [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

-(NSInteger)numberOfIndexs{
    return _imageUrlDataArray.count;
}

-(CCDraggableCardView*)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index{
    CustomCardView* cardView = [[CustomCardView alloc]initWithFrame:draggableContainer.bounds];
    [cardView installData:[_imageUrlDataArray objectAtIndex:index]];
    return cardView;
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    BOOL left=0;
    BOOL right=0;
    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
        
        self.dislikeButton.transform = CGAffineTransformMakeScale(scale, scale);
        if (scale>=1.125) {
            left=1;
        }
    }
    if (draggableDirection == CCDraggableDirectionRight) {
        
        self.likeButton.transform = CGAffineTransformMakeScale(scale, scale);
        NSLog(@"%f",scale);
        if (scale>=1.125) {
            right=1;
        }
    }
    NSLog(@"%d",self.countNumber);
    if (self.countNumber==10) {
        self.countNumber=0;
    }
}

-(void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard{
    //[draggableContainer reloadData];
    [self loadData];
}

-(void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex{
    NSLog(@"点击了Tag为%ld",didSelectIndex);
}

#pragma mark dislike And like event
-(void)likeBtnToEvent:(UIButton*)sender{
    [self.container removeFormDirection:CCDraggableDirectionRight];
    self.countNumber++;
    NSDictionary* dic = [_imageUrlDataArray objectAtIndex:self.countNumber];
    NSRange imageNameStartRangeString = [dic[@"picture"] rangeOfString:@"http://172.18.74.9:8081/images/"];
    NSString* StartRange = [dic[@"picture"] substringFromIndex:imageNameStartRangeString.location+imageNameStartRangeString.length];
    
    NSDictionary* parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",[NSString stringWithFormat:@"%@",StartRange],@"picture",nil];
    [AFNHttpTool POST:markMyFavoritePicture parameters:parameter success:^(id responseObject) {
        NSLog(@"喜欢%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
}

-(void)dislikeBtnToEvent:(UIButton*)sender{
    [self.container removeFormDirection:CCDraggableDirectionLeft];
    self.countNumber++;
    NSDictionary* dic = [_imageUrlDataArray objectAtIndex:self.countNumber];
    NSRange imageNameStartRangeString = [dic[@"picture"] rangeOfString:@"http://172.18.74.9:8081/images/"];
    NSString* StartRange = [dic[@"picture"] substringFromIndex:imageNameStartRangeString.location+imageNameStartRangeString.length];
    
    NSDictionary* parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"18131371659",@"nickname",[NSString stringWithFormat:@"%@",StartRange],@"picture",nil];
    [AFNHttpTool POST:markMyDisFavoritePicture parameters:parameter success:^(id responseObject) {
        NSLog(@"不喜欢%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
}

-(void)queryToRecord:(UIButton*)sender{
    //我喜欢的图片的数据的界面
    WXSearchPicturesViewController* recordVC = [[WXSearchPicturesViewController alloc]init];
    recordVC.hidesBottomBarWhenPushed = YES;
    recordVC.imageUrlString = myFavoritePictures;
    [self.navigationController pushViewController:recordVC animated:YES];
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
