//
//  FlowCollectionViewCell.m
//  FlowLayout
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "FlowCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
//标签
#import "UIColor+Wonderful.h"
#import "SXMarquee.h"
#import "SXHeadLine.h"


@interface FlowCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FlowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Initialization code
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
   
}

-(void)setLabelTextArray:(NSArray *)labelTextArray{
    _labelTextArray = labelTextArray;
    
    SXHeadLine* headLine = [[SXHeadLine alloc]initWithFrame:CGRectMake(0,0,self.view.size.width,self.view.size.height)];
    headLine.messageArray = labelTextArray;
    [headLine setBgColor:[UIColor whiteColor] textColor:[UIColor orangeRed] textFont:[UIFont systemFontOfSize:13]];
    [headLine setScrollDuration:0.5 stayDuration:3];
    headLine.hasGradient = YES;
    //    [headLine changeTapMarqueeAction:^(NSInteger index) {
    //        NSLog(@"点击了第%ld个标签",(long)index);
    //    }];
    [headLine start];
    
    [self.view addSubview:headLine];
  

}



-(void)clickButton:(UIButton*)button{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(flowCollectionCell:didClickButton:)]) {
        [self.delegate flowCollectionCell:self didClickButton:button];
    }
}

@end
