//
//  WXGetTheCurrentTime.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/16.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXGetTheCurrentTime.h"
#import <Foundation/Foundation.h>

@implementation WXGetTheCurrentTime

+(NSString*)getCurrentTimeToPictureName{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString* str = [formatter stringFromDate:[NSDate date]];
    NSString* fileName = [NSString stringWithFormat:@"%@.png",str];
    return fileName;
}

@end
