//
//  CommonMarco.h
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#ifndef XMShare_CommonMarco_h
#define XMShare_CommonMarco_h

///  APP KEY
#define APP_KEY_WEIXIN            @"wxd930ea5d5a258f4f"

#define APP_KEY_QQ                @"222222"

#define APP_KEY_WEIBO             @"4032180399"

#define APP_KEY_WEIBO_RedirectURL @"https://api.weibo.com/oauth2/default.html"

///  分享图片
#define SHARE_IMG [UIImage imageNamed:@"logo.png"]

#define SHARE_IMG_COMPRESSION_QUALITY 0.5

///  Common size
#define SIZE_OF_SCREEN    [[UIScreen mainScreen] bounds].size


/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;

#define showAlert(_msg){UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];[alert show];}

#endif
