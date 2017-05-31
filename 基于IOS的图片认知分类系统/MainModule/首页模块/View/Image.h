//
//  Image.h
//  FlowLayout
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Image : NSObject
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, assign) CGFloat imageW;
@property (nonatomic, assign) CGFloat imageH;

@property(nonatomic,copy)NSArray* labelArray;

+ (instancetype)imageWithImageDic:(NSDictionary *)imageDic;
@end
