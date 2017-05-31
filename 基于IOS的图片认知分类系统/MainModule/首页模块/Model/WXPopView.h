//
//  WXPopView.h
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/1.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^exitInterfaceBlock)(NSDictionary* dic);

@interface WXPopView : UIView{
    UIButton* _cancelButton;
    UIButton* _defineButton;
    UIControl* _backgroundControlView;
}
//出现view
-(void)showView;

@property(nonatomic,strong)exitInterfaceBlock block;

@property(nonatomic,strong)NSURL* imageUrl;
@property(nonatomic,strong)NSString* urlString;

@end
