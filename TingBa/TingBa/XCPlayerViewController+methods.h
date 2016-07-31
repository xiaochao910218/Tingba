//
//  XCPlayerViewController+methods.h
//  ListenNovel
//
//  Created by 筱超 on 16/7/7.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCPlayerViewController.h"

@interface XCPlayerViewController (methods)
/**
 *  创建部分控件
 */
- (void)creatViews;

/**
 *  设置旋转图的Frame
 */
- (void)setRotatingViewFrame;

/**
 *  设置旋转图片、模糊图片
 *
 *  @param model 当前的音乐model
 */
- (void)setImageWith:(XCListModel *)model;

/**
 *  提示框
 *
 *  @param string 提示字符串
 */
- (void)progressHUDWith:(NSString *)string;


@end
