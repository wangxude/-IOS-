//
//  WXAddPictureLabelViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/21.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXAddPictureLabelViewController.h"

#import "WXTextCustomButton.h"

@interface WXAddPictureLabelViewController ()<UITextFieldDelegate>{
    //标签的父视图
    UIView* textLabelSuperView;
    
    
}


//标记的标签
@property(nonatomic,weak)NSString* wxTextView;

@property(nonatomic,strong)NSMutableArray* buttonContentArray;

@property(nonatomic,strong)NSMutableArray* createButtonArray;

@property(nonatomic,assign)int allHeight;

@property(nonatomic,strong)NSString* imageName;


@end

@implementation WXAddPictureLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonContentArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //图片名字
    NSRange imageNameStartRangeString = [self.urlString rangeOfString:localSeverString];
    NSString* StartRange = [self.urlString substringFromIndex:imageNameStartRangeString.location+imageNameStartRangeString.length];
    self.imageName = StartRange;
    self.title = StartRange;
    
    //标签图片
    UIImageView* imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:_imageUrl placeholderImage:nil];
    [self.view addSubview:imageView];
    
    textLabelSuperView = [[UIView alloc]init];
    //textLabelSuperView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:textLabelSuperView];
    
    
    UILabel* biaoqianLabel = [[UILabel alloc]init];
    biaoqianLabel.textColor = WXColor(104, 151, 57);
    biaoqianLabel.text = @"标签:";
    biaoqianLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:biaoqianLabel];
    
    UITextField* textField = [[UITextField alloc]init];
    textField.placeholder = @"填写完标签点击完成即生成";
    textField.returnKeyType = UIReturnKeyDone;
    textField.font = [UIFont systemFontOfSize:14];
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor redColor].CGColor;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    
    
    UIButton* submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:30/255.0 blue:37/255.0 alpha:1]];
    [submitBtn  addTarget:self action:@selector(submitTextToSever) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"标签完成" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5.0;
    [self.view addSubview:submitBtn];
    
    UILabel* recommendedLabel = [[UILabel alloc]init];
    recommendedLabel.textColor = WXColor(104, 151, 57);
    recommendedLabel.text = @"推荐标签";
    recommendedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:recommendedLabel];
    
    
    imageView.sd_layout
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(self.view, 20)
    .heightIs(150);
    
    biaoqianLabel.sd_layout
    .leftSpaceToView(self.view,20)
    .topSpaceToView(imageView, 10)
    .widthIs(40)
    .heightIs(40);
    
     textLabelSuperView.sd_layout
    .leftSpaceToView(biaoqianLabel, 0)
    .rightSpaceToView(self.view,20)
    .topSpaceToView(imageView, 10)
    .heightIs(40);
    
    self.allHeight = textLabelSuperView.frame.origin.y;
    textField.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(textLabelSuperView, 10)
    .heightIs(30);
    
    recommendedLabel.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(textField, 10)
    .widthIs(80)
    .heightIs(30);
    
    submitBtn.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(textField, 100)
    .heightIs(40);
    
    [self pushTheRecommendLabel];
    
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //将数组数据传给按钮，并将按钮的数据赋值到view上面去
    if ([textField.text isEqualToString:@""]||textField.text == nil ||[textField.text isEqual:[NSNull null]]) {
        [self.navigationController.view makeToast:@"请输入标签数据" duration:0.3  position:CSToastPositionCenter];
    }
    else{
        [self.buttonContentArray addObject:textField.text];
        textField.text = nil;
        NSArray* array = self.buttonContentArray;
        [self generateLabel:array];
    }
   
    return YES;
}

-(void)generateLabel:(NSArray*)titleArray{
    
    //保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat w = 0;
    //控制button距离父视图的高
    CGFloat h = self.allHeight;
       for (int i = 0; i < self.buttonContentArray.count; i++) {
         

           WXTextCustomButton * button = [[WXTextCustomButton alloc]init];
           [button setTitle:self.buttonContentArray[i] forState:UIControlStateNormal];
           button.titleLabel.font = [UIFont systemFontOfSize:14];
           [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
           [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
           [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
           button.tag = 4000+i;
           //根据文字计算大小
           NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
           CGFloat length = [self.buttonContentArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
           
            button.frame = CGRectMake(w, h+10, length+20, 20);
            w = button.frame.size.width+button.frame.origin.x+10;
            [textLabelSuperView addSubview:button];
            [self.createButtonArray addObject:button];
           
        }
    
}

/**
 删除标签数据

 @param sender <#sender description#>
 */
-(void)deleteButton:(UIButton*)sender{
    if (self.buttonContentArray.count > 0) {

        [self.buttonContentArray removeObject:sender.titleLabel.text];
             
        //textLabelSuperView.backgroundColor = [UIColor purpleColor];
        for(UIButton* button in textLabelSuperView.subviews){
            [button removeFromSuperview];
        }
        [self generateLabel:self.buttonContentArray];
    }
}

-(void)pushTheRecommendLabel{
    NSString* auth = [Auth appSign:1000000 userId:nil];
    TXQcloudFrSDK* sdk = [[TXQcloudFrSDK alloc]initWithName:[Conf instance].appId authorization:auth endPoint:[Conf instance].API_END_POINT];
//    UIImage* image = [UIImage imageNamed:@"timg.jpeg"];
//    id imagedd = image;
    
    NSLog(@"%@",self.urlString);
    NSLog(@"%@",self.imageUrl);
    
    [sdk imageTagValue:@"http://114.115.144.69:8081/images/1.jpg" cookie:nil seq:@"10000211" successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
   

}


-(void)submitTextToSever{
//    [self performSelectorOnMainThread:@selector(upDateViewWithData:) withObject:_nodeDataArray waitUntilDone:NO];
//    [self performSelectorOnMainThread:@selector(upDateButtonStatus:) withObject:_buttonStatusArray waitUntilDone:NO];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSString stringWithFormat:@"%@",self.imageName] forKey:@"picture"];
    for (int i = 0; i<self.buttonContentArray.count; i++) {
        [dic setObject:self.buttonContentArray[i] forKey:[NSString stringWithFormat:@"tag%d",i+1]];
        
    }
    self.block(dic);
    [self.navigationController popViewControllerAnimated:YES];
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
