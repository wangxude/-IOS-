//
//  path.h
//  基于IOS的图片认知分类系统
//
//  Created by 王旭 on 2017/4/19.
//  Copyright © 2017年 kys-5. All rights reserved.
//

#ifndef path_h
#define path_h

//服务器地址
#define Host @"http://114.115.144.69:8088/pic/"
//本地服务器地址
#define LocalHost @"http://172.18.74.9:8088/"
//验证码接口
#define VerificationCodeInterface @"verifyCode"
//登录接口
#define LoginInterface @"loginCheck"
//注册接口
#define registerInterface @"register"
//返回图片接口
#define returnImageInterface @"getImg"
//上传图片验证接口
//#define upLoadPicturesToVerify @"validate"
//请求图库图片的接口
#define queryAtlasPicturesInterface @"search"

//上传图片标签的接口
#define upLoadPictures @"uploadIndex"

//我喜欢的图片的接口
#define myFavoritePictures @"getFavorite"
//标记我喜欢的图片
#define markMyFavoritePicture @"favorite"
//标记我不喜欢的图片
#define markMyDisFavoritePicture @"disFavorite"
//得到图片标签(单个)接口
#define getOnePictureLabel @"getIndex"
//导出图片接口
#define exportPicturesInterface @"exportImg"

#define deleteTheDamagedImage @"removeImg"


#define localSeverString @"http://172.18.74.9:8081/images/"
#define severString @"http://114.115.144.69:8081/images/"



#endif /* path_h */
