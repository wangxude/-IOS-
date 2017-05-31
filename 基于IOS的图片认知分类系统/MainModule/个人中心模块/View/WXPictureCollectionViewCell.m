//
//  WXPictureCollectionViewCell.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/22.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXPictureCollectionViewCell.h"

@implementation WXPictureCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"BListPicture"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"blackListPicture"] forState:UIControlStateSelected];
   // self.deleteButton.backgroundColor = [UIColor whiteColor];
    [self.deleteButton addTarget:self action:@selector(changeButtonState:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Initialization code
}

-(void)changeButtonState:(UIButton*)button{
    button.selected = !button.selected;
    button.tintColor = [UIColor clearColor];
}

@end
