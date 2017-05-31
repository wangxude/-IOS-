//
//  UIImage+ReSize.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/15.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "UIImage+ReSize.h"

@implementation UIImage (ReSize)

-(UIImage*)reSzieImageToSize:(CGSize)reSize{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height), NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage* reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}


@end
