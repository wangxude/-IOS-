//
//  WXPopView.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/1.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXPopView.h"

#import "WXTextCustomButton.h"

@interface WXPopView ()<UITextViewDelegate>
//编辑文本的按钮
@property(nonatomic,strong)NSMutableArray* editTextArray;

@property(nonatomic,assign) CGFloat allHeight;

@property(nonatomic,strong)UITextView* wxTextView;
@property(nonatomic,strong)NSMutableArray* buttonArray;
//显示的图片
@property(nonatomic,strong)UIImageView* leftImageView;
//显示的图片的名字
@property(nonatomic,strong)NSString* imageName;

@end

@implementation WXPopView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //编辑文本的数组
        self.editTextArray = [[NSMutableArray alloc]init];
        //编辑按钮
        self.buttonArray = [[NSMutableArray alloc]init];
        
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width-150)/2,10,150,30)];
        nameLabel.text = @"填写标签";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor redColor];
        [self addSubview:nameLabel];
        
       self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,40, (self.bounds.size.width-20), 120)];
        [self.leftImageView sd_setImageWithURL:_imageUrl placeholderImage:nil];
        [self addSubview:self.leftImageView];
        
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        self.layer.borderWidth=1.0f;
        self.layer.cornerRadius=10.0f;
        self.clipsToBounds=TRUE;
        //阴影部分
        _backgroundControlView = [[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundControlView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [_backgroundControlView addTarget:self
                         action:@selector(fadeOut)
               forControlEvents:UIControlEventTouchUpInside];
        
       
        

        self.wxTextView = [[UITextView alloc]init];
        self.wxTextView.frame = CGRectMake(10, self.leftImageView.bounds.size.height+nameLabel.bounds.size.height+20, self.bounds.size.width-20, 40);
        self.wxTextView.font = [UIFont systemFontOfSize:14];
        self.wxTextView.layer.borderWidth = 1;
        self.wxTextView.layer.borderColor = WXColor(179, 179, 179).CGColor;
        self.wxTextView.delegate = self;
        [self addSubview:self.wxTextView];
    
        
        //确定按钮
    
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10, self.bounds.size.height-45, self.bounds.size.width/2-15,40);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.tag = 700;
        _cancelButton.backgroundColor = WXColor(74, 143, 212);
       // _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.cornerRadius = 20;
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _defineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _defineButton.frame = CGRectMake(self.bounds.size.width/2+5, self.bounds.size.height-45, self.bounds.size.width/2-15, 40);
        [_defineButton setTitle:@"确定" forState:UIControlStateNormal];
        _defineButton.tag = 701;
        _defineButton.backgroundColor = WXColor(74, 143, 212);
       // _defineButton.layer.borderWidth = 1;
        _defineButton.layer.cornerRadius = 20;
        [_defineButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_defineButton];
        
        self.allHeight = self.leftImageView.bounds.size.height+nameLabel.bounds.size.height;

    }
    
   
    
    return self;
}

-(void)textViewDidChange:(UITextView *)textView{
    //默认文本框显示一行文字
    float currentLineNumber = 1;
    float textViewWidth = self.wxTextView.frame.size.width;//取得文本框的高度
    NSString* content = textView.text;
    NSDictionary* dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize contentSize = [content sizeWithAttributes:dict];
    float numLine = ceilf(contentSize.width/textViewWidth);
    
//    self.wxTextView.selectedRange = NSMakeRange(200, 0);
    if (numLine>currentLineNumber) {
        //如果发现当前文字长度对应的行数超过，文本框高度，则先调整view的高度和位置，然后调整输入框的高度，最后修改currentLineNum的值
        //self.frame
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self changeViewUp:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView isEqual:@""]||textView.text ==nil) {
        
    }
    else{
        //去除字符串中的空格
        NSString* string = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self.editTextArray addObject:string];
        [self changeViewUp:NO];
    }
    
}
-(void)changeViewUp:(BOOL)isUp{
    //开始动画
    [UIView beginAnimations:@"viewUp" context:nil];
    //设置时长
    [UIView setAnimationDuration:0.2f];
    //通过isUp来确定视图的移动方向
    int changedValue;
    if (isUp) {
        changedValue = -20;
    }
    else{
        changedValue = 20;
    }
    //设置动画内容
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+changedValue, self.frame.size.width, self.frame.size.height);
    //提交动画
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        textView.text = nil;
        [self addEditButton];
        
        return NO;
        
    }
    
    return YES;
    
}


-(void)addEditButton{
    CGFloat w = 15;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = self.allHeight+25;//用来控制button距离父视图的高
    for (int i = 0; i < self.editTextArray.count; i++) {
        WXTextCustomButton * button = [[WXTextCustomButton alloc]init];
        [button setTitle:self.editTextArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 4000+self.editTextArray.count;
        //根据文字计算大小
        NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat length = [self.editTextArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
        button.frame = CGRectMake(w, h, length+30, 30);
//        NSMutableString* mutableString = [[NSMutableString alloc]init];
//        for (int i = 1; i <= length; i++) {
//            [mutableString appendString:@" "];
//            
//        }
//        NSLog(@"%@",mutableString);
//        self.wxTextView.text = mutableString;
       
       // self.wxTextView.selectedRange = NSMakeRange(length, 0);
        if (15+w+length+15>self.bounds.size.width-20) {
            w = 15;
            h = h+ button.frame.size.height + 5;
            button.frame = CGRectMake(w, h, length + 30, 30);
        //self.wxTextView.selectedRange = NSMakeRange(w+length+30+5, 0);
        self.wxTextView.frame = CGRectMake(10, self.allHeight+20, self.bounds.size.width-20, 40+40);
        //self.wxTextView.text = @"                       ";
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height+40);
  

        }
        w = button.frame.size.width+ button.frame.origin.x + 10;
        
        
        [self addSubview:button];
        [self.buttonArray addObject:button];

      
          }
 
   

}


-(void)deleteButton:(UIButton*)sender{
    if (self.editTextArray.count > 0) {
        for (int i = 0; i<self.buttonArray.count; i++) {
            UIButton* button = self.buttonArray[i];
            [button removeFromSuperview];
        }

        NSLog(@"%@",sender.titleLabel.text);
        [self.editTextArray removeObject:sender.titleLabel.text];
//        [sender removeFromSuperview];
        NSLog(@"%@",self.editTextArray);
        [self addEditButton];
    }
}

-(void)addANewTag:(UIButton*)sender{
    NSLog(@"%@",sender);
}

-(void)buttonClick:(UIButton*)sender{
    [self fadeOut];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
   
    [dic setObject:[NSString stringWithFormat:@"%@",self.imageName] forKey:@"picture"];
    for (int i = 0; i<self.editTextArray.count; i++) {
        [dic setObject:self.editTextArray[i] forKey:[NSString stringWithFormat:@"tag%d",i+1]];
        
    }
 
    self.block(dic);
}

-(void)fadeIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0.0;
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)fadeOut{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_backgroundControlView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

-(void)showView{
    [self.leftImageView sd_setImageWithURL:_imageUrl placeholderImage:nil];
    
    NSRange imageNameStartRangeString = [self.urlString rangeOfString:localSeverString];
    NSString* StartRange = [self.urlString substringFromIndex:imageNameStartRangeString.location+imageNameStartRangeString.length];
    
    self.imageName = StartRange;
    
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:_backgroundControlView];
    [keyWindow addSubview:self];
    self.center = CGPointMake(keyWindow.bounds.size.width/2.0,  keyWindow.bounds.size.height/2.5);
    [self fadeIn];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    NSLog(@"点击视图");
  }


@end

