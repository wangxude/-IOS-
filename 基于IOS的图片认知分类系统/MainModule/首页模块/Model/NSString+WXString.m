//
//  NSString+WXString.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/29.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "NSString+WXString.h"

@implementation NSString (WXString)

-(NSURL*)zp_url{
#pragma  clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    return [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8))];
#pragma clang diagnostic pop
}

@end
