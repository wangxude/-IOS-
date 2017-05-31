//
//  WXHomeCollectionReusableView.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/24.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXHomeCollectionReusableView.h"

@implementation WXHomeCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray{
    self = [super init];
    if (self) {
        [self addSubview:[self headView]];
    }
    return self;
}

-(UIView*)headView{
    UIView* view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, (ScreenWidth-70)/3);
//        NSArray *picArray=[[NSArray alloc]initWithObjects:[UIImage imageNamed:@"腐蚀图谱"],[UIImage imageNamed:@"失效图谱"],[UIImage imageNamed:@"金相图谱"],[UIImage imageNamed:@"其他图谱"], nil];
    NSArray* titleArray=@[@"我喜欢的",@"每日推荐",@"猜你喜欢",@"敬请期待"];
    
    for (int i=0; i<4; i++) {
        UIButton* titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame=CGRectMake(2+2*i+i*(ScreenWidth-10)/4,0,(ScreenWidth-10)/4,(ScreenWidth-70)/3) ;
        titleBtn.tag=100+i;
        
        [titleBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [titleBtn setBackgroundImage:picArray[i] forState:UIControlStateNormal];
//        [titleBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [titleBtn setBackgroundColor:[UIColor whiteColor]];
        [titleBtn addTarget:self action:@selector(activityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:titleBtn];
        
    }
    return view;
    
}

-(void)activityBtnClick:(UIButton*)sender{
  
    //通知代理
    if ([self.delegate respondsToSelector:@selector(homeCollectionReuseableView:didClickButton:)]) {
        [self.delegate homeCollectionReuseableView:self didClickButton:sender];
    }
}



@end
