//
//  HeadView.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/10.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

-(id)initWithFrame:(CGRect)frame{
    //?
    if (self = [super initWithFrame:frame]) {
        [self setUpSubView];
    }
    return self;
}

-(void)setUpSubView{
    UIButton* iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [UIImage imageNamed:@"2"];
    [iconButton setBackgroundImage:image forState:UIControlStateNormal];
   // [iconButton addTarget:self action:@selector() forControlEvents:UIControlStateNormaleve]
    iconButton.layer.cornerRadius = 40.0;
    iconButton.layer.masksToBounds = YES;
    [self addSubview:iconButton];
    
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"奋斗一号";
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:nameLabel];
    
    UIImageView* sexImageView = [[UIImageView alloc]init];
    sexImageView.image = [UIImage imageNamed:@"sexm"];
    sexImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:sexImageView];
    
    UILabel* permissionLabel = [[UILabel alloc]init];
    permissionLabel.text = @"普通权限";
    permissionLabel.font = [UIFont systemFontOfSize:14];
    permissionLabel.textAlignment = NSTextAlignmentCenter;
    permissionLabel.layer.cornerRadius = 5;
    permissionLabel.layer.borderColor = [UIColor yellowColor].CGColor;
    permissionLabel.layer.borderWidth = 1;
    permissionLabel.textColor = [UIColor redColor];
    [self addSubview:permissionLabel];
    
    UILabel* integralLabel = [[UILabel alloc]init];
    integralLabel.text = @"积分:100";
    integralLabel.textColor = [UIColor purpleColor];
    integralLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:integralLabel];
    
    iconButton.sd_layout
    .widthIs(80)
    .heightIs(80)
    .topSpaceToView(self, 10)
    .leftSpaceToView(self, 10);
    
    nameLabel.sd_layout
    .widthIs(70)
    .heightIs(30)
    .topSpaceToView(self, 5)
    .leftSpaceToView(iconButton,10);
    
    
    sexImageView.sd_layout
    .widthIs(30)
    .heightIs(30)
    .topEqualToView(nameLabel)
    .leftSpaceToView(nameLabel, 1);
    
    permissionLabel.sd_layout
    .widthIs(70)
    .heightIs(30)
    .topSpaceToView(nameLabel, 2)
    .leftSpaceToView(iconButton, 10);
    
    integralLabel.sd_layout
    .widthIs(100)
    .heightIs(30)
    .topSpaceToView(permissionLabel, 2)
    .leftSpaceToView(iconButton, 10);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
