//
//  WXEditInformationViewController.h
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/10.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TheValueBlock)(NSDictionary*parameter);

@interface WXEditInformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)TheValueBlock sendBlock;

@end
