//
//  WXPictureCollectionViewCell.h
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/22.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXPictureCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *pictureLabelName;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
//
//@property(nonatomic,copy)NSString* ;
//@property(nonatomic,copy)NSString*

@end
