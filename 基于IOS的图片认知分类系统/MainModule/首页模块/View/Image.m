//
//  Image.m
//  FlowLayout
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "Image.h"

#import "NSString+WXString.h"
#import "UIImage+image.h"


@implementation Image
+ (instancetype)imageWithImageDic:(NSDictionary *)imageDic {
    Image *image = [[Image alloc] init];
    NSString* string = [NSString stringWithFormat:@"%@",imageDic[@"picture"]];
    NSURL* url = [string zp_url];
    image.imageURL = url;
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    if ([UIImage isValidPNGByImageData:data]) {
        UIImage* image1 = [UIImage imageWithData:data];
        
        NSMutableArray* mutableArray = [[NSMutableArray alloc]init];
        for (int i = 0; i<3; i++) {
            NSString* imageString = imageDic[[NSString stringWithFormat:@"tag%d",i+1]];
            if ([DetermineWhetherIsEmpty introducedIntoAnObject:imageString]) {
                [mutableArray addObject:imageString];
            }
            else{
                
            }
            
        }
        if (mutableArray.count==0) {
            image.labelArray = @[@"暂无标签数据",@"暂无标签数据"];
        }
        else{
            image.labelArray = mutableArray;
            
        }
        
//        NSNumber* number1 = imageDic[@"width"];
//        NSNumber* number2 = imageDic[@"height"];
//        image.imageW = [number1 intValue];
//        image.imageH = [number2 intValue];
        image.imageW  = image1.size.width;
        image.imageH = image1.size.height;
        return image;
    }
    
   
    
    NSMutableArray* mutableArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<3; i++) {
        NSString* imageString = imageDic[[NSString stringWithFormat:@"tag%d",i+1]];
        if ([DetermineWhetherIsEmpty introducedIntoAnObject:imageString]) {
            [mutableArray addObject:imageString];
        }
        else{
            
        }
        
    }
    if (mutableArray.count==0) {
        image.labelArray = @[@"暂无标签数据",@"暂无标签数据"];
    }
    else{
        image.labelArray = mutableArray;
        
    }
    UIImage* image1 = [UIImage imageNamed:@"2"];
    image.imageW = image1.size.width;
    image.imageH = image1.size.height;
    
    NSRange imageNameStartRangeString = [string rangeOfString:@"http://172.18.74.9:8081/images/"];
    NSString* StartRange = [string substringFromIndex:imageNameStartRangeString.location+imageNameStartRangeString.length];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",StartRange],@"picture",nil];
    [AFNHttpTool POST:deleteTheDamagedImage parameters:dictionary success:^(id responseObject) {
        NSLog(@"%@",string);
        NSLog(@"%@",@"ddddddddddddddddddd");
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",@"rrrrrrrrrrrrrrrrrr");
    }];
    return image;
}



@end
