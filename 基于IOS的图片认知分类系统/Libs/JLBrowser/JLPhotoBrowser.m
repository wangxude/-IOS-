//
//  JLScrollView.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

//屏幕宽
//#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#define bigScrollVIewTag 101

#import "JLPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "JLPieProgressView.h"

//分享需要的头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface JLPhotoBrowser()<UIScrollViewDelegate>
/**
 *  底层滑动的scrollview
 */
@property (nonatomic,weak) UIScrollView *bigScrollView;
/**
 *  黑色背景view
 */
@property (nonatomic,weak) UIView *blackView;
/**
 *  原始frame数组
 */
@property (nonatomic,strong) NSMutableArray *originRects;

//指示器
@property(nonatomic,strong)UIActivityIndicatorView* wxIndicator;

@end

@implementation JLPhotoBrowser

-(NSMutableArray *)originRects{
    
    if (_originRects==nil) {
        
        _originRects = [NSMutableArray array];
        
    }
    
    return _originRects;
    
}

+ (instancetype)photoBrowser{
    
    return [[self alloc] init];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //0.创建黑色背景view
        [self setupBlackView];
        
        //1.创建bigScrollView
        [self setupBigScrollView];
        
        [self saveBottomButtonToView];
    }
    return self;
}

-(void)saveBottomButtonToView{
    //1.编辑按钮   2.保存按钮 3.分享 4.收藏
    UIView* backGroundView = [[UIView alloc]init];
    backGroundView.frame = CGRectMake(0,self.bounds.size.height-44, self.bounds.size.width, 44);
    backGroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backGroundView];
    
    
    NSArray* titleArray = @[@"bianji",@"save",@"share",@"shoucang"];
    for (int i = 0; i<4; i++) {
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[saveButton setTitle:titleArray[i] forState:UIControlStateNormal];
        //[saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //saveButton.backgroundColor = WXColor(74, 143, 210);
        saveButton.layer.cornerRadius = 5;
        saveButton.clipsToBounds = YES;
        [saveButton setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(clickButtonToPhoto:) forControlEvents:UIControlEventTouchUpInside];
        saveButton.frame = CGRectMake(self.bounds.size.width*i/4, 0, self.bounds.size.width/4, 44);
//        saveButton.layer.borderWidth = 1;
        saveButton.tag =900+i;
       // saveButton.layer.borderColor =WXColor(74, 141, 212).CGColor;
        [backGroundView addSubview:saveButton];

    }
    
    //指示器
//    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]init];
//    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//    indicator.center = self.center;
//    self.wxIndicator = indicator;
//    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
//    [indicator startAnimating];
    
    
    
    
}

/**
 编辑图片

 @param sender 点击的按钮
 */
-(void)clickButtonToPhoto:(UIButton*)sender{
    
    switch (sender.tag) {
        case 900:
            [self editImage];
            break;
        case 901:
            [self saveImageToAlbum];
            break;
            
        case 902:
            [self shareImageToPlatfrom];
            break;
            
        default:
           
            
            break;
    }
    
   
    
}

-(void)editImage{
   
}


/**
 分享图片
 */
-(void)shareImageToPlatfrom{
    //1.创建分享参数
    
     UIImageView* currentimageView = self.photos[self.currentIndex];
    
    NSArray* imageArray = @[currentimageView.image];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary* shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容" images:imageArray url:[NSURL URLWithString:@"http://mob.com"] title:@"分享标题" type:SSDKContentTypeAuto];
            //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
    //2.分享
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (platformType) {
                case SSDKPlatformTypeQQ:
                    NSLog(@"dd");
                    break;
                case SSDKPlatformTypeWechat:
                    NSLog(@"333");
                    break;
                    
                case SSDKPlatformTypeSinaWeibo:

                    NSLog(@"weibo");
                    break;
                default:
                    break;
            }
            
            switch (state) {
                case SSDKResponseStateSuccess:{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                    
                    break;
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    NSLog(@"4444%@",error);
                    [alert show];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
}

/**
 保存图片到相册
 */
-(void)saveImageToAlbum{
    NSLog(@"%d",self.currentIndex);
    UIImageView* currentimageView = self.photos[self.currentIndex];
    UIImageWriteToSavedPhotosAlbum(currentimageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //[self.wxIndicator removeFromSuperview];
    
    UILabel* indicatorLabel = [[UILabel alloc]init];
    indicatorLabel.textColor = [UIColor whiteColor];
    indicatorLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    indicatorLabel.layer.cornerRadius = 5;
    indicatorLabel.clipsToBounds = YES;
    indicatorLabel.bounds = CGRectMake(0, 0, 150, 30);
    indicatorLabel.center = self.center;
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.font = [UIFont boldSystemFontOfSize:17];
    [JLKeyWindow addSubview:indicatorLabel];
    [JLKeyWindow bringSubviewToFront:indicatorLabel];
    if (error) {
        indicatorLabel.text = SDPhotoBrowserSaveImageFailText;
    }
    else{
        indicatorLabel.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [indicatorLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

#pragma mark 创建黑色背景

-(void)setupBlackView{
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    [self addSubview:blackView];
    self.blackView = blackView;
    
}

#pragma mark 创建背景bigScrollView

-(void)setupBigScrollView{
    
    UIScrollView *bigScrollView = [[UIScrollView alloc] init];
    bigScrollView.backgroundColor = [UIColor clearColor];
    bigScrollView.delegate = self;
    bigScrollView.tag = bigScrollVIewTag;
    bigScrollView.pagingEnabled = YES;
    bigScrollView.bounces = YES;
    bigScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = ScreenWidth;
    CGFloat scrollViewH = ScreenHeight;
    bigScrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    [self addSubview:bigScrollView];
    self.bigScrollView = bigScrollView;
    
}

-(void)show{
    
    //1.添加photoBrowser
    [JLKeyWindow addSubview:self];
    
    //2.获取原始frame
    [self setupOriginRects];
    
    //3.设置滚动距离
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth*self.photos.count, 0);
    self.bigScrollView.contentOffset = CGPointMake(ScreenWidth*self.currentIndex, 0);
    if (self.isLoadLocalOrNetData == 1) {
        [self setUpLocalPictures];
    }else{
    //4.创建子视图
      [self setupSmallScrollViews];
    }
}
-(void)setUpLocalPictures{
    __weak JLPhotoBrowser *weakSelf = self;
    
    for (int i=0; i<self.imageArray.count; i++) {
        
        UIScrollView *smallScrollView = [self creatSmallScrollView:i];
        JLPhoto *photo = [self addTapWithTag:i];
        [smallScrollView addSubview:photo];
        
        
        CGImageRef imageRef = ((ALAsset *)[self.imageArray objectAtIndex:i]).defaultRepresentation.fullScreenImage;
        photo.image = [UIImage imageWithCGImage:imageRef];
        
        [weakSelf setupPhotoFrame:photo];
        
        
    }

}
#pragma mark 创建子视图

-(void)setupSmallScrollViews{
    
    __weak JLPhotoBrowser *weakSelf = self;
    
    for (int i=0; i<self.photos.count; i++) {
        
        UIScrollView *smallScrollView = [self creatSmallScrollView:i];
        JLPhoto *photo = [self addTapWithTag:i];
        [smallScrollView addSubview:photo];
   
        
        JLPieProgressView *loop = [self creatLoopWithTag:i];
        [smallScrollView addSubview:loop];
        
        NSURL *bigImgUrl = [photo.bigImgUrl zp_url];
        
        //检查图片是否已经缓存过
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:photo.bigImgUrl done:^(UIImage *image, SDImageCacheType cacheType) {
            
//            if (image==nil) {
//                loop.hidden = NO;
//            }
            
        }];
        
        
        [photo sd_setImageWithURL:bigImgUrl placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            //设置进度条
           // loop.progressValue = (CGFloat)receivedSize/(CGFloat)expectedSize;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image!=nil) {
                
           // loop.hidden = YES;
                
                //下载回来的图片
                if (cacheType==SDImageCacheTypeNone) {
                    
                    [weakSelf setupPhotoFrame:photo];
                    
                }else{
                    
                    photo.frame = [weakSelf.originRects[i] CGRectValue];
                    [UIView animateWithDuration:0.3 animations:^{
                        [weakSelf setupPhotoFrame:photo];
                    }];
                    
                }
                
            }else{
                
                //图片下载失败
                photo.bounds = CGRectMake(0, 0, 240, 240);
                photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                photo.contentMode = UIViewContentModeScaleAspectFit;
                photo.image = [UIImage imageNamed:@"preview_image_failure"];
                
                [loop removeFromSuperview];
                
            }
            
        }];
        
    }
    
}

- (void)setupPhotoFrame:(JLPhoto *)photo{
    
    UIScrollView *smallScrollView = (UIScrollView *)photo.superview;
    
    self.blackView.alpha = 1.0;
    
    CGFloat ratio = (double)photo.image.size.height/(double)photo.image.size.width;
    
    CGFloat bigW = ScreenWidth;
    CGFloat bigH = ScreenWidth*ratio;
    
    if (bigH<ScreenHeight) {
        photo.bounds = CGRectMake(0, 0, bigW, bigH);
        photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    }else{//设置长图的frame
        photo.frame = CGRectMake(0, 0, bigW, bigH);
        smallScrollView.contentSize = CGSizeMake(ScreenWidth, bigH);
    }
    
}

- (UIScrollView *)creatSmallScrollView:(int)tag{
    
    UIScrollView *smallScrollView = [[UIScrollView alloc] init];
    smallScrollView.backgroundColor = [UIColor clearColor];
    smallScrollView.tag = tag;
    smallScrollView.frame = CGRectMake(ScreenWidth*tag, 0, ScreenWidth, ScreenHeight);
    smallScrollView.delegate = self;
    smallScrollView.maximumZoomScale=3.0;
    smallScrollView.minimumZoomScale=1;
    [self.bigScrollView addSubview:smallScrollView];
    
    return smallScrollView;
    
}

- (JLPhoto *)addTapWithTag:(int)tag{
    
    JLPhoto *photo = self.photos[tag];
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
    UITapGestureRecognizer *zonmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zonmTap:)];
    zonmTap.numberOfTapsRequired = 2;
    [photo addGestureRecognizer:zonmTap];
    [photo addGestureRecognizer:photoTap];
    
    //zonmTap失败了再执行photoTap，否则zonmTap永远不会被执行
    [photoTap requireGestureRecognizerToFail:zonmTap];
    
    return photo;
    
}

- (JLPieProgressView *)creatLoopWithTag:(int)tag{
    
    JLPieProgressView *loop = [[JLPieProgressView alloc] init];
    loop.tag = tag;
    loop.frame = CGRectMake(0,0 , 80, 80);
    loop.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    loop.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    loop.hidden = YES;
    UITapGestureRecognizer *loopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopTap:)];
    [loop addGestureRecognizer:loopTap];
    return loop;
    
}

-(void)zonmTap:(UITapGestureRecognizer *)zonmTap{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIScrollView *smallScrollView = (UIScrollView *)zonmTap.view.superview;
        smallScrollView.zoomScale = 3.0;
        
    }];
    
}

-(void)photoTap:(UITapGestureRecognizer *)photoTap{
    
    //1.将图片缩放回一倍，然后再缩放回原来的frame，否则由于屏幕太小动画直接从3倍缩回去，看不完整
    JLPhoto *photo = (JLPhoto *)photoTap.view;
    UIScrollView *smallScrollView = (UIScrollView *)photo.superview;
    smallScrollView.zoomScale = 1.0;
    
    //1.1如果是长图片先将其移动到CGPointMake(0, 0)在缩放回去 
    if (CGRectGetHeight(photo.frame)>ScreenHeight) {
        smallScrollView.contentOffset = CGPointMake(0, 0);
    }
    
    //2.再取出原始frame，缩放回去
    CGRect frame = [self.originRects[photo.tag] CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        photo.frame = frame;
        self.blackView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

-(void)loopTap:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.blackView.alpha = 0;
        tap.view.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark 获取原始frame

-(void)setupOriginRects{
    
    for (JLPhoto *photo in self.photos) {
        
        UIImageView *sourceImageView = photo.sourceImageView;
        CGRect sourceF = [JLKeyWindow convertRect:sourceImageView.frame fromView:sourceImageView.superview];
        [self.originRects addObject:[NSValue valueWithCGRect:sourceF]];
        
    }
    
}

#pragma mark UIScrollViewDelegate

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    if (scrollView.tag==bigScrollVIewTag) return nil;
    
    JLPhoto *photo = self.photos[scrollView.tag];
    
    return photo;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if (scrollView.tag==bigScrollVIewTag) return;
    
    JLPhoto *photo = (JLPhoto *)self.photos[scrollView.tag];
    
    CGFloat photoY = (ScreenHeight-photo.frame.size.height)/2;
    CGRect photoF = photo.frame;
    
    if (photoY>0) {
        
        photoF.origin.y = photoY;
        
    }else{
        
        photoF.origin.y = 0;
        
    }
    
    photo.frame = photoF;
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    //如果结束缩放后scale为1时，跟原来的宽高会有些轻微的出入，导致无法滑动，需要将其调整为原来的宽度
    if (scale == 1.0) {
        
        CGSize tempSize = scrollView.contentSize;
        tempSize.width = ScreenWidth;
        scrollView.contentSize = tempSize;
        CGRect tempF = view.frame;
        tempF.size.width = ScreenWidth;
        view.frame = tempF;
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int currentIndex = scrollView.contentOffset.x/ScreenWidth;
    
    if (self.currentIndex!=currentIndex && scrollView.tag==bigScrollVIewTag) {
        
        self.currentIndex = currentIndex;
        
        for (UIView *view in scrollView.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                UIScrollView *scrollView = (UIScrollView *)view;
                scrollView.zoomScale = 1.0;
            }
            
        }
        
    }
    
}

#pragma mark 设置frame

-(void)setFrame:(CGRect)frame{
    
    frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [super setFrame:frame];
    
}


@end
