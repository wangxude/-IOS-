//
//  WXPointViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/12.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXPointViewController.h"

#import "CDPStarEvaluation.h"
#import "MBProgressHUD+MJ.h"

@interface WXPointViewController ()<CDPStarEvaluationDelegate>{
    CDPStarEvaluation* _starEvaluation; //星型评价
    UILabel* _commentLabel; //评论级别label
}


@end

@implementation WXPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    //总体评价
    UILabel *allCommentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,100,self.view.bounds.size.width,self.view.bounds.size.height*0.07042254)];
    allCommentLabel.text=@"总体评价";
    allCommentLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:allCommentLabel];
    //CDPStarEvaluation星形评价
    _starEvaluation=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.1875,allCommentLabel.frame.origin.y+allCommentLabel.bounds.size.height,self.view.bounds.size.width*0.625,allCommentLabel.bounds.size.height) onTheView:self.view];
    _starEvaluation.delegate=self;
    
    //评论级别Label
    //评价级别label
    _commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,_starEvaluation.starImageView.frame.origin.y+_starEvaluation.starImageView.bounds.size.height,self.view.bounds.size.width,allCommentLabel.bounds.size.height)];
    _commentLabel.text=_starEvaluation.commentText;
    _commentLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_commentLabel];
    
    //提交评论
    UIButton *submitCommentButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.0625,_commentLabel.frame.origin.y+_commentLabel.bounds.size.height,self.view.bounds.size.width*0.875,self.view.bounds.size.height*0.07042254)];
    submitCommentButton.backgroundColor=[UIColor colorWithRed:242/255.0 green:130/255.0 blue:32/255.0 alpha:1];
    [submitCommentButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [submitCommentButton addTarget:self action:@selector(submitCommentClick) forControlEvents:UIControlEventTouchUpInside];
    submitCommentButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:submitCommentButton];
    
}

#pragma mark CDPStarEvaluationDelegate获得实时评价级别
-(void)theCurrentCommentText:(NSString *)commentText{
    _commentLabel.text=commentText;
}
#pragma mark 点击事件
//提交评论
-(void)submitCommentClick{
    //    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提交结果" message:[NSString stringWithFormat:@"级别:%@  分数:%.2f\n(分数默认显示小数点后两位,自己可根据需求更改)",_commentLabel.text,_starEvaluation.width*5] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    [alertView show];
    [MBProgressHUD showSuccess:@"亲,谢谢您的评价😊"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
