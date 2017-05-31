//
//  UITableView+Improve.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/15.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "UITableView+Improve.h"

@implementation UITableView (Improve)

-(void)improveTabelView{
    self.tableFooterView = [[UIView alloc]init];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        //防止分割线显示不全
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        //防止分割线显示不全
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
