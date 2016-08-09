//
//  WBHttpRequest+WeiboGame.h
//  WeiboSDK
//
//  Created by insomnia on 15/3/11.
//  Copyright (c) 2015年 SINA iOS Team. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (WeiboGame)

/*!

 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameObject:(NSString*)userID
                 withAccessToken:(NSString*)accessToken
              andOtherProperties:(NSDictionary*)otherProperties
                           queue:(NSOperationQueue*)queue
           withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 

 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameAchievementObject:(NSString*)userID
                            withAccessToken:(NSString*)accessToken
                         andOtherProperties:(NSDictionary*)otherProperties
                                      queue:(NSOperationQueue*)queue
                      withCompletionHandler:(WBRequestHandler)handler;

/*!

 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameAchievementGain:(NSString*)userID
                          withAccessToken:(NSString*)accessToken
                       andOtherProperties:(NSDictionary*)otherProperties
                                    queue:(NSOperationQueue*)queue
                    withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 

 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameScoreGain:(NSString*)userID
                    withAccessToken:(NSString*)accessToken
                 andOtherProperties:(NSDictionary*)otherProperties
                              queue:(NSOperationQueue*)queue
              withCompletionHandler:(WBRequestHandler)handler;


/*!
 @method
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForGameScore:(NSString*)userID
                       withAccessToken:(NSString*)accessToken
                    andOtherProperties:(NSDictionary*)otherProperties
                                 queue:(NSOperationQueue*)queue
                 withCompletionHandler:(WBRequestHandler)handler;

/*!
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForFriendsGameScore:(NSString*)userID
                              withAccessToken:(NSString*)accessToken
                           andOtherProperties:(NSDictionary*)otherProperties
                                        queue:(NSOperationQueue*)queue
                        withCompletionHandler:(WBRequestHandler)handler;

/*!

 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForGameAchievementGain:(NSString*)userID
                                 withAccessToken:(NSString*)accessToken
                              andOtherProperties:(NSDictionary*)otherProperties
                                           queue:(NSOperationQueue*)queue
                           withCompletionHandler:(WBRequestHandler)handler;

@end
