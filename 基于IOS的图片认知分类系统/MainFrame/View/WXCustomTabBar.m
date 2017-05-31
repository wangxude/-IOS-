//
//  WXCustomTabBar.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXCustomTabBar.h"

@implementation WXCustomTabBar

-(void)layoutSubviews{
    [super layoutSubviews];
    //调整tabBarButton的位置
    CGFloat btnW = self.bounds.size.width/4;
    CGFloat btnH = self.bounds.size.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    NSLog(@"%@",self.subviews);
    //遍历子控件，调整布局
    //私有的类：打印出来，但是敲出来没有提示，说明这个类是系统私有的类
    
    int i = 0;
    for (UIView* tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            btnX = btnW * i;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
