//
//  XCPlayerViewController+methods.m
//  ListenNovel
//
//  Created by 筱超 on 16/7/7.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCPlayerViewController+methods.h"
@implementation XCPlayerViewController (methods)
- (void)creatViews{
    self.rotatingView = [[XCRotatingView alloc] init];
    self.rotatingView.imageView.image = [UIImage imageNamed:@"音乐_播放器_默认唱片头像"];
    [self.view addSubview:self.rotatingView];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.userInteractionEnabled = NO;
    [self.view addSubview:self.HUD];
}

- (void)progressHUDWith:(NSString *)string{
    self.HUD.labelText = string;
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:2.0f];
}

- (void)setRotatingViewFrame{
    CGFloat height_i4 = KScreenHeight - topHeight - downHeight;
    if (KScreenHeight < 500) {
        self.rotatingView.frame = CGRectMake(0, 0, height_i4*0.8, height_i4*0.8);
    }else{
        self.rotatingView.frame = CGRectMake(0, 0, KScreenWidth *0.8, KScreenWidth*0.8);
    }
    self.rotatingView.center = CGPointMake(KScreenWidth/2, height_i4/2 + topHeight);
    [self.rotatingView setRotatingViewLayoutWithFrame:self.rotatingView.frame];
}


- (void)setImageWith:(XCListModel *)model{
    /**
     *  添加旋转动画
     */
    [self.rotatingView addAnimation];
    NSString *str=model.listCoverImage;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://img4.mypsd.com.cn/20110316/Mypsd_13966_201103161738560005B.jpg";
    }
    self.underImageView.image = [UIImage imageNamed:@"音乐_播放器_默认模糊背景"];
    [self.rotatingView.imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"音乐_播放器_默认唱片头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.underImageView.image = [image applyDarkEffect];
        }
    }];
}

@end
