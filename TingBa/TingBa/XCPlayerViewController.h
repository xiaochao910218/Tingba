//
//  XCPlayerViewController.h
//  ListenNovel
//
//  Created by 筱超 on 16/7/6.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XCListModel.h"
#import "XCRotatingView.h"
#import "UIImage+ImageEffects.h"
#import "AudioPlayer.pch"
#import "XCRadioModel.h"
static CGFloat topHeight = 64.0+20.0;
static CGFloat downHeight = 100.0+16.0;
@interface XCPlayerViewController : UIViewController

typedef NS_ENUM(NSInteger, AudioPlayerMode) {
    /**
     *  顺序播放
     */
    AudioPlayerModeOrderPlay,
    /**
     *  随机播放
     */
    AudioPlayerModeRandomPlay,
    /**
     *  单曲循环
     */
    AudioPlayerModeSinglePlay,
};
+(XCPlayerViewController *)audioPlayerController;

@property (strong, nonatomic) XCRotatingView *rotatingView;
/**
 *  背景模糊图
 */
@property (weak, nonatomic) IBOutlet UIImageView *underImageView;
/**
 *  第三方提示MBProgressHUD
 */
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (nonatomic) BOOL isPlaying;
@property (strong, nonatomic)NSString *menuUrl;
@property (strong, nonatomic)NSString *menuImg;
@property (strong, nonatomic)XCListModel *playingModel;
@property (strong, nonatomic)XCRadioModel *radioModel;
- (void)initWithArray:(NSArray *)array index:(NSInteger)index;
/**
 *  开始播放
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)stop;

/**
 *  播放/暂停按钮点击事件执行的方法
 */
- (void)playerStatus;

/**
 *  上一曲
 */
- (void)inASong;

/**
 *  下一曲
 */
- (void)theNextSong;
@end
