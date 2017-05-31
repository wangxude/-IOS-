//
//  UIImage+image.h
//  爱心汇
//
//  Created by kys-4 on 15/11/25.
//  Copyright © 2015年 kys-4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)
//instancetype默认会识别当前是那个类或者对象调用，就会转换成对应的类对象
//UIImage *
//加载没有渲染图片
+ (instancetype)imageWithOriginalName:(NSString *)imageName;
/**
 *  校验图片是否为有效的PNG图片
 *
 *  @param imageData 图片文件直接得到的NSData对象
 *
 *  @return 是否为有效的PNG图片
 */
+(BOOL)isValidPNGByImageData:(NSData*)imageData;

@end
