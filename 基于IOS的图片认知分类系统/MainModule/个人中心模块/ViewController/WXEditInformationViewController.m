//
//  WXEditInformationViewController.m
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/5/10.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#import "WXEditInformationViewController.h"

@interface WXEditInformationViewController ()<UITextFieldDelegate,UIActionSheetDelegate,
             UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property(nonatomic,strong)UITableView* syPersonTableView;
//头像
@property(nonatomic,strong)UIButton* iconButton;
//名字
@property(nonatomic,strong)UITextField* nameTextField;
//性别
@property(nonatomic,strong)UITextField* sexTextField;
//个性签名
@property(nonatomic,strong)UITextField* signatureTextField;

@property(nonatomic,strong)NSArray* titleArray;

@end

@implementation WXEditInformationViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人信息";
    
    self.titleArray = @[@"头像",@"名字",@"性别",@"个性签名"];
    
    self.syPersonTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.syPersonTableView.delegate = self;
    self.syPersonTableView.dataSource = self;
    [self.view addSubview:_syPersonTableView];
    
    
    
    
    UIButton *submitbtn=[[UIButton alloc]initWithFrame:CGRectMake(30,ScreenHeight*0.4, ScreenWidth - 60, ScreenHeight/15)];
    [submitbtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:30/255.0 blue:37/255.0 alpha:1]];
    [submitbtn  addTarget:self action:@selector(submitPictures) forControlEvents:UIControlEventTouchUpInside];
    [submitbtn setTitle:@"确定" forState:UIControlStateNormal];
    submitbtn.layer.cornerRadius = 5.0;
    [_syPersonTableView addSubview:submitbtn];
    // Do any additional setup after loading the view.
}

-(void)submitPictures{
    
    [[NSUserDefaults standardUserDefaults]setObject:self.nameTextField.text forKey:@"WXName"];
    [[NSUserDefaults standardUserDefaults]setObject:self.sexTextField.text forKey:@"WXSex"];
    [[NSUserDefaults standardUserDefaults]setObject:self.signatureTextField.text forKey:@"WXSign"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (self.sendBlock) {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"name",[NSString stringWithFormat:@"%@",self.nameTextField.text]
                             ,@"sex",[NSString stringWithFormat:@"%@",self.sexTextField.text],@"sign",
                             [NSString stringWithFormat:@"%@",self.signatureTextField.text],nil];
        _sendBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"goodCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    else{
        
        //删除cell中的子对象，防止覆盖的问题
        while ([cell.contentView.subviews lastObject]!=NULL) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
    }
    //移除之前的cell
    for (UIView* subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    if (indexPath.row == 0) {
        self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconButton.frame = CGRectMake(ScreenWidth-ScreenWidth/5-8, 4, 42, 42);
        self.iconButton.layer.cornerRadius = 21;
        self.iconButton.layer.masksToBounds = YES;
        [self.iconButton addTarget:self action:@selector(relacePicture) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage* image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"localIconDataWX"]];
        
        [self.iconButton setBackgroundImage:image forState:UIControlStateNormal];
        [cell.contentView addSubview:self.iconButton];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 1){
        self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-160, 2, 150, 46)];
        self.nameTextField.placeholder = @"请输入名字";
        self.nameTextField.font = [UIFont systemFontOfSize:15];
        self.nameTextField.textAlignment = NSTextAlignmentRight;
        self.nameTextField.delegate = self;
        [cell.contentView addSubview:self.nameTextField];
    }
    else if (indexPath.row == 2){
        self.sexTextField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-160, 2, 150, 46)];
        self.sexTextField.placeholder = @"请输入性别";
        self.sexTextField.font = [UIFont systemFontOfSize:15];
        self.sexTextField.textAlignment = NSTextAlignmentRight;
        self.sexTextField.delegate = self;
        [cell.contentView addSubview:self.sexTextField];
    }
    else{
        self.signatureTextField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-160, 2, 150, 46)];
        self.signatureTextField.placeholder = @"请输入个性签名";
        self.signatureTextField.font = [UIFont systemFontOfSize:15];
        self.signatureTextField.textAlignment = NSTextAlignmentRight;
        self.signatureTextField.delegate = self;
        [cell.contentView addSubview:self.signatureTextField];
        
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
    
}

-(void)relacePicture{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"编辑头像"
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        //打开照相机
        [self takePhoto];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        
        //打开本地相册
        [self takeLocalPhoto];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//打开张相机
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController* picker1 = [[UIImagePickerController alloc]init];
        picker1.delegate = self;
        picker1.sourceType = sourceType;
        picker1.allowsEditing = YES;
        [self.navigationController presentViewController:picker1 animated:YES completion:nil];
        
    }
}
//打开本地相册
-(void)takeLocalPhoto{
    UIImagePickerController* localPicker = [[UIImagePickerController alloc]init];
    localPicker.delegate = self;
    localPicker.allowsEditing = YES;
    [self.navigationController presentViewController:localPicker animated:YES completion:nil];
    
}


#pragma mark-UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.iconButton setBackgroundImage:image forState:UIControlStateNormal];
    
    NSData* imageData = UIImagePNGRepresentation(image);
    
    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:@"localIconDataWX"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

//UITextField的协议方法，当结束编辑时监听
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
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
