//
//  AppDelegate.m
//  TingBa
//
//  Created by 筱超 on 16/7/16.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonMarco.h"
#import "XCListTableViewController.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
@interface AppDelegate ()<WeiboSDKDelegate, QQApiInterfaceDelegate,WeiboSDKDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [self init3rdParty];
    return YES;
}

- (void)init3rdParty
{
    [WXApi registerApp:APP_KEY_WEIXIN];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:APP_KEY_WEIBO];
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        //        return [TencentOAuth HandleOpenURL:url];
        return [QQApiInterface handleOpenURL:url delegate:self];
        
    }else if([[url absoluteString] hasPrefix:@"wb"]) {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else if([[url absoluteString] hasPrefix:@"wx"]) {
        
        XCListTableViewController *vc = (XCListTableViewController *)self.window.rootViewController;
        return [WXApi handleOpenURL:url delegate:vc];
        
    }
    
    return NO;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }else if([[url absoluteString] hasPrefix:@"wb"]) {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else{
        
        XCListTableViewController *vc = (XCListTableViewController *)self.window.rootViewController;
        return [WXApi handleOpenURL:url delegate:vc];
        
    }
}

#pragma mark - 实现代理回调
/**
 *  微博
 *
 *  @param response 响应体。根据 WeiboSDKResponseStatusCode 作对应的处理.
 *  具体参见 `WeiboSDKResponseStatusCode` 枚举.
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
//    NSString *message;
//    switch (response.statusCode) {
//        case WeiboSDKResponseStatusCodeSuccess:
//            message = @"分享成功";
//            break;
//        case WeiboSDKResponseStatusCodeUserCancel:
//            message = @"取消分享";
//            break;
//        case WeiboSDKResponseStatusCodeSentFail:
//            message = @"分享失败";
//            break;
//        default:
//            message = @"分享失败";
//            break;
//    }
//    UIAlertController *alertCV=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {}];[alertCV addAction:action];
//    XCListTableViewController *vc = (XCListTableViewController *)self.window.rootViewController;
//    [vc presentViewController:alertCV animated:YES completion:nil];
    if ([response isKindOfClass:WBAuthorizeResponse.class])  //微博登录的回调
    {
        if ([_weiboDelegate respondsToSelector:@selector(weiboLoginByResponse:)]) {
            [_weiboDelegate weiboLoginByResponse:response];
        }
    }

}

/**
 *  处理来至QQ的请求
 *
 *  @param req QQApi请求消息基类
 */
- (void)onReq:(QQBaseReq *)req
{
    
}

/**
 *  处理来至QQ的响应
 *
 *  @param resp 响应体，根据响应结果作对应处理
 */
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)onResp:(QQBaseResp *)resp
{
    NSString *message;
    if([resp.result integerValue] == 0) {
        message = @"分享成功";
    }else{
        message = @"分享失败";
    }
    UIAlertController *alertCV=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {}];[alertCV addAction:action];
    XCListTableViewController *vc = (XCListTableViewController *)self.window.rootViewController;
    [vc presentViewController:alertCV animated:YES completion:nil];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
