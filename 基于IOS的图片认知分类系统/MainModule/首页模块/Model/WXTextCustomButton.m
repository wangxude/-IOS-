//
//  WXTextCustomButton.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/5.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXTextCustomButton.h"

@implementation WXTextCustomButton

//-(id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        self.imageView.contentMode = UIViewContentModeCenter;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = WXColor(237, 237, 237).CGColor;
//        self.backgroundColor = WXColor(237, 237, 237);
//    }
//    return self;
//}
-(void)setHighlighted:(BOOL)highlighted{
    
}

-(id)init{
    self = [super init];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.layer.borderWidth = 1;
        self.layer.borderColor = WXColor(237, 237, 237).CGColor;
        self.backgroundColor = WXColor(237, 237, 237);
        self.layer.cornerRadius = 5;
    }
    return self;

}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleWidth = contentRect.size.width  - 20;
    CGFloat titleHeight = 20;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = contentRect.size.width  - 20;
    CGFloat imageY = 0;
    CGFloat imageWidth = 20;
    CGFloat imageHeight = 20;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

@end
