//
//  HeadView.h
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/10.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView
//头像
@property(nonatomic,strong)NSString* WXIconUrl;
//名字
@property(nonatomic,strong)UILabel* WXName;
//性别
@property(nonatomic,strong)UIImageView* WXSex;
//个性签名
@property(nonatomic,strong)NSString* signatureString;


@end
