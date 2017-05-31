//
//  WXHomeCollectionReusableView.h
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/24.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXHomeCollectionReusableView;

@protocol  WXHomeCollectionReusableViewDelegate<NSObject>

-(void)homeCollectionReuseableView:(WXHomeCollectionReusableView*)collectionView didClickButton:(UIButton*)button;

@end

@interface WXHomeCollectionReusableView : UICollectionReusableView

@property(nonatomic,weak)id<WXHomeCollectionReusableViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray*)imageArray;

@end
