//
//  AppDelegate.h
//  TingBa
//
//  Created by 筱超 on 16/7/16.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
//@protocol QQShareDelegate <NSObject>
//
//-(void)shareSuccssWithQQCode:(NSInteger)code;
//@end
@protocol WeiBoDelegate <NSObject>

//登录的代理
-(void)weiboLoginByResponse:(WBBaseResponse *)response;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak  , nonatomic) id<WeiBoDelegate> weiboDelegate;
//@property (weak  , nonatomic) id<QQShareDelegate> qqDelegate;


@end

