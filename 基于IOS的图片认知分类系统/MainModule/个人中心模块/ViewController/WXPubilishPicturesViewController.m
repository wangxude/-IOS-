//
//  WXPubilishPicturesViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/13.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXPubilishPicturesViewController.h"
//修改图片的尺寸
#import "UIImage+ReSize.h"
//防止分割线显示不全
#import "UITableView+Improve.h"
//选择图片
#import "AGImagePickerController.h"

#import "JLPhotoBrowser.h"

#import <AssetsLibrary/AssetsLibrary.h>


@interface WXPubilishPicturesViewController ()<LCActionSheetDelegate>

@property(nonatomic,weak)UIButton* addPictureButton;

@property(nonatomic,strong)AGImagePickerController* imagePicker;

//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray;

@property(nonatomic,strong)UIView* headView;



@end

@implementation WXPubilishPicturesViewController
//懒加载图片
-(NSMutableArray*)imagePickerArray{
    if (!_imagePickerArray) {
        _imagePickerArray = [[NSMutableArray alloc]init];
        
    }
    return _imagePickerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithPictureView];
    
    
  
    UIButton *submitCommentButton=[[UIButton alloc] initWithFrame:CGRectMake(30,ScreenHeight-60-64,ScreenWidth-60,40)];
    submitCommentButton.backgroundColor=[UIColor colorWithRed:242/255.0 green:130/255.0 blue:32/255.0 alpha:1];
    [submitCommentButton setTitle:@"确定提交" forState:UIControlStateNormal];
    [submitCommentButton addTarget:self action:@selector(upLoadPicturesToSever) forControlEvents:UIControlEventTouchUpInside];
    submitCommentButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:submitCommentButton];

    // Do any additional setup after loading the view.
}

-(void)upLoadPicturesToSever{
    
  
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.imagePickerArray.count; i++) {
        CGImageRef imageRef = ((ALAsset *)[self.imagePickerArray objectAtIndex:i]).defaultRepresentation.fullScreenImage;
        UIImage* image = [UIImage imageWithCGImage:imageRef];
        [array addObject:image];
    }
//    NSData* data = UIImageJPEGRepresentation(image,1.0);
//   [AFNHttpTool sendPostWithUrl:upLoadOnePicture parameters:nil picutreData:data success:^(id responseObject) {
//       NSLog(@"图片正确%@",responseObject);
//   } fail:^(NSError *error) {
//       NSLog(@"图片错误%@",error);
//   }];
    [AFNHttpTool sendPostWithUrl:upLoadPictures parameters:nil picutreDataArray:array success:^(id responseObject) {
         NSLog(@"图片正确%@",responseObject);
    } fail:^(NSError *error) {
        NSLog(@"图片错误%@",error);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#define padding 10
#define pictureHW (ScreenWidth - 5*padding)/4
#define MaxImageCount 100
#define deleImageWH 25 // 删除按钮的宽高
//大图特别耗内存，不能把大图存在数组里，存类型或者小图
-(void)initWithPictureView{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    NSInteger imageCount = [self.imagePickerArray count];
    for (int i = 0; i< imageCount; i++) {
        UIImageView* pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton* deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleButton.frame = CGRectMake(pictureHW-deleImageWH, 0, deleImageWH, deleImageWH);
        [deleButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleButton addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:deleButton];
        [headView addSubview:pictureImageView];
        
        pictureImageView.tag = imageTag +i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image =[UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray objectAtIndex:i]).aspectRatioThumbnail];
        [headView addSubview:pictureImageView];
        
    }
    
    if (imageCount < MaxImageCount) {
        UIButton* addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(padding+ (imageCount%4)*(pictureHW+padding),padding+(imageCount/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:addPictureButton];
        
        self.addPictureButton = addPictureButton;
    }
    
    NSInteger headViewHeight = 120 + (10 + pictureHW)*([self.imagePickerArray count]/4 + 1);
    headView.frame = CGRectMake(0, 0, ScreenWidth, headViewHeight);
    [self.view addSubview:headView];
    self.headView = headView;
}

/**
 添加图片
 */
-(void)addPicture{
    LCActionSheet* actionSheet = [LCActionSheet sheetWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开照相机",@"打开相册", nil];
    actionSheet.clickedHandle = ^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [self openTheCamera];
        }
        else if(buttonIndex == 2){
            [self openThePhotoAlbum];
        }
        else if (buttonIndex == 0){
            NSLog(@"取消");
        }
        else{
            
        }
        NSLog(@"clickedButtonAtIndex: %d", (int)buttonIndex);
    };
    [actionSheet show];

}

/**
 点击图片方法缩小

 @param tap 手势
 */
- (void)tapImageView:(UITapGestureRecognizer *)tap

{
    //1.创建JLPhoto数组
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<self.imagePickerArray.count; i++) {
      
        UIImageView *child = [self.view viewWithTag:imageTag+i];
        JLPhoto *photo = [[JLPhoto alloc] init];
        //1.1设置原始imageView
        photo.sourceImageView = child;
        //1.2设置大图URL
        
        //1.3设置图片tag
        photo.tag = i;
        [photos addObject:photo];
        
    }
  
    
    //2. 创建图片浏览器
    JLPhotoBrowser *photoBrowser = [JLPhotoBrowser photoBrowser];
    //2.1 设置JLPhoto数组
    photoBrowser.isLoadLocalOrNetData = 1;
    photoBrowser.photos = photos;
    photoBrowser.imageArray = self.imagePickerArray;
    //2.2 设置当前要显示图片的tag
    photoBrowser.currentIndex = (int)tap.view.tag-imageTag;
    //2.3 显示图片浏览器
    [photoBrowser show];
    
}


/**
 删除图片

 @param btn 删除按钮
 */
-(void)deletePic:(UIButton*)btn{
//    if ([(UIButton*)btn.superview isKindOfClass:[UIImageView class]]) {
//        UIImageView* imageView = (UIImageView*)btn.superview;
//        [self.imagePickerArray removeObjectAtIndex:imageView.tag-imageTag];
//        [imageView removeFromSuperview];
//        
//    }
//    [self initWithPictureView];
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
       UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        [self.imagePickerArray removeObjectAtIndex:(imageView.tag - imageTag)];
        //[imageView removeFromSuperview];
    }
    [self.headView removeFromSuperview];
    [self initWithPictureView];

}

/**
 打开相机
 */
-(void)openTheCamera{
    
}

/**
 打开相册
 */
-(void)openThePhotoAlbum{
    __block WXPubilishPicturesViewController *blockSelf = self;
    _imagePicker = [[AGImagePickerController alloc]initWithFailureBlock:^(NSError *error) {
        if (error == nil) {
            [blockSelf dismissViewControllerAnimated:YES completion:nil];
            
        }
        else{
            NSLog(@"%@",error);
            NSLog(@"Error: %@", error);
            
            // Wait for the view controller to show first and hide it after that
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:YES completion:^{}];
            });
        }
    } andSuccessBlock:^(NSArray *info) {
        [blockSelf.imagePickerArray addObjectsFromArray:info];
        NSLog(@"%@",info);
        [blockSelf dismissViewControllerAnimated:YES completion:nil];
        [blockSelf initWithPictureView];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    
    self.imagePicker.maximumNumberOfPhotosToBeSelected = 9 - [self.imagePickerArray count];
    
    [self presentViewController:self.imagePicker animated:YES completion:^{}];

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
