//
//  FlowCollectionViewCell.h
//  FlowLayout
//
//  Created by 王旭 on 2017/4/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlowCollectionViewCell;

@protocol FlowCollectionViewCellDelegate <NSObject>

-(void)flowCollectionCell:(FlowCollectionViewCell*)cell didClickButton:(UIButton*)button;

@end

@interface FlowCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property(nonatomic,weak)id<FlowCollectionViewCellDelegate>delegate;


@property (nonatomic, strong) NSURL *imageURL;
@property(nonatomic,strong)NSArray* labelTextArray;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *view;
@end
