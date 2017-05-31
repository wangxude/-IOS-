//
//  DetermineWhetherIsEmpty.m
//  爱心汇
//
//  Created by kys-23 on 16/3/6.
//  Copyright © 2016年 kys-4. All rights reserved.
//

#import "DetermineWhetherIsEmpty.h"

@implementation DetermineWhetherIsEmpty
//传入一个对象判断是否为空
+ (NSInteger)introducedIntoAnObject:(id)obj{
    if([obj isEqual:[NSNull null]]||[obj isEqualToString:@"Null"]||obj == nil||obj == NULL||[obj isEqualToString:@"nil"])
    {
        return 0;
    }else{
        return 1;
    }
}
@end
