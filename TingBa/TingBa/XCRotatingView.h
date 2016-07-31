//
//  XCRotatingView.h
//  ListenNovel
//
//  Created by 筱超 on 16/7/7.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCRotatingView : UIView
@property (nonatomic, strong) UIImageView *imageView;

- (void)setRotatingViewLayoutWithFrame:(CGRect)frame;
// 添加动画
- (void)addAnimation;
// 停止
-(void)pauseLayer;
// 恢复
-(void)resumeLayer;
// 移除动画
- (void)removeAnimation;
@end
