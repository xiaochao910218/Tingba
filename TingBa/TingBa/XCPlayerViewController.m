//
//  XCPlayerViewController.m
//  ListenNovel
//
//  Created by 筱超 on 16/7/6.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCPlayerViewController.h"
#import "NSString+time.h"
#import "XCPlayerViewController+methods.h"
#import "CBAutoScrollLabel.h"
#import "XCListTableViewController.h"
#import "XCDataViewController.h"
#import "XCOneTableViewController.h"
#import "XCCommon.h"

@interface XCPlayerViewController ()
{
    AVPlayerItem *playerItem;
    id _playTimeObserver; // 播放进度观察者
    NSArray *_modelArray; // 歌曲数组
    NSArray *_randomArray; //随机数组
    NSInteger _index; // 播放标记
    BOOL isRemoveNot; // 是否移除通知
    AudioPlayerMode _playerMode; // 播放模式
    // 正在播放的model
    CGFloat _totalTime; // 总时间
}

@property (weak, nonatomic) IBOutlet UISlider *paceSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) CBAutoScrollLabel *titleView;

@property (weak, nonatomic) IBOutlet UILabel *playingTime; // 当前播放时间Label
@property (weak, nonatomic) IBOutlet UILabel *maxTime; // 总时间Label
@property (nonatomic, strong) AVPlayer *player;
@end
static XCPlayerViewController *audioVC;
@implementation XCPlayerViewController

-(CBAutoScrollLabel *)titleView{
    if (!_titleView) {
        _titleView=[[CBAutoScrollLabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH-64, 64)];
    }
    return _titleView;
}

+(XCPlayerViewController *)audioPlayerController{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioVC = [[XCPlayerViewController alloc] init];
        audioVC.view.backgroundColor = [UIColor whiteColor];
        audioVC.player = [[AVPlayer alloc]init];
        //后台播放
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    return audioVC;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.paceSlider setThumbImage:[UIImage imageNamed:@"Slider_控制点"] forState:UIControlStateNormal];
    [self creatViews];
   
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self setRotatingViewFrame];
}

- (void)updateAudioPlayer{
    if (isRemoveNot) {
        // 如果已经存在 移除通知、KVO，各控件设初始值
        [self removeObserverAndNotification];
        [self initialControls];
        isRemoveNot = NO;
    }
    XCListModel *model;
    // 判断是不是随机播放
    if (_playerMode == AudioPlayerModeRandomPlay) {
        // 如果是随机播放，判断随机数组是否有值
        if (_randomArray.count == 0) {
            // 如果随机数组没有值，播放当前音乐并给随机数组赋值
            model = [_modelArray objectAtIndex:_index];
            _randomArray = [_modelArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
                return arc4random() % _modelArray.count;
            }];
        }else{
            // 如果随机数组有值，从随机数组取值
            model = [_randomArray objectAtIndex:_index];
        }
    }else{
        model = [_modelArray objectAtIndex:_index];
    }
    _playingModel = model;
    // 更新界面歌曲信息：歌名，歌手，图片
    [self updateUIDataWith:model];
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.listAudioURL]];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self monitoringPlayback:playerItem];// 监听播放状态
    [self addEndTimeNotification];
    isRemoveNot = YES;
}
// 各控件设初始值
- (void)initialControls{
    [self stop];
    self.playingTime.text = @"00:00";
    self.paceSlider.value = 0.0f;
    [self.rotatingView removeAnimation];
}

- (void)updateUIDataWith:(XCListModel *)model{
//    self.titleView =[CBAutoScrollLabel alloc]initWithFrame:CGRectMake(0, 0,WIDTH, 60);
    self.titleView.text = model.listTitle;
    self.titleView.labelSpacing=30;
    self.titleView.pauseInterval=1.7;
    self.titleView.scrollSpeed=30;
    self.titleView.textAlignment=NSTextAlignmentCenter;
    self.titleView.fadeLength=12.f;
    self.titleView.scrollDirection=CBAutoScrollDirectionLeft;
    [self.titleView observeApplicationNotifications];
    self.navigationItem.titleView=self.titleView;
    self.navigationItem.title=@"播放器";
    [self setImageWith:model];
}
#pragma mark - KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            if ([_playingModel.listAudioURL containsString:@".mp3"]) {
                CMTime duration = item.duration;// 获取视频总长度
                [self setMaxDuratuin:CMTimeGetSeconds(duration)];
                self.maxTime.hidden=NO;
            }else{
                self.maxTime.hidden=YES;
            }

            [self play];
        }else if([playerItem status] == AVPlayerStatusFailed) {
            [self stop];
        }
    }
}
- (void)setMaxDuratuin:(float)duration{
    _totalTime = duration;
    self.paceSlider.maximumValue = duration;
    self.maxTime.text = [NSString convertTime:duration];
}

#pragma mark - _playTimeObserver
- (void)monitoringPlayback:(AVPlayerItem *)item {
    WS(ws);
    //这里设置每秒执行30次
    _playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 计算当前在第几秒
        float currentPlayTime = (double)item.currentTime.value/item.currentTime.timescale;
        [ws updateVideoSlider:currentPlayTime];
    }];
}

- (void)updateVideoSlider:(float)currentTime{
    [self setLockViewWith:_playingModel currentTime:currentTime];
    self.paceSlider.value = currentTime;
    self.playingTime.text = [NSString convertTime:currentTime];
}

-(void)addEndTimeNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)playbackFinished:(NSNotification *)notification{
    if (_playerMode == AudioPlayerModeSinglePlay) {
        playerItem = [notification object];
        [playerItem seekToTime:kCMTimeZero];
        [self.player play];
    }else{
        [self nextIndexAdd];
        [self updateAudioPlayer];
    }
}

- (void)initWithArray:(NSArray *)array index:(NSInteger)index{
    _index = index;
    _modelArray = array;
    _randomArray = nil;
    [self updateAudioPlayer];
}
- (IBAction)changeSlider:(id)sender {
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(self.paceSlider.value, 1);
    [playerItem seekToTime:dragedCMTime];
}
- (IBAction)previousClick:(UIButton *)sender {
     [self inASong];
}

- (void)inASong{
    if (_playerMode != AudioPlayerModeSinglePlay) {
        [self previousIndexSub];
    }
    [self updateAudioPlayer];
}

- (IBAction)playAndPauseClick:(UIButton *)sender {
     [self playerStatus];
    
}
- (void)playerStatus{
    if (_isPlaying) {
        [self stop];
    }else{
        [self play];
    }
}

- (IBAction)nextClick:(UIButton *)sender {
     [self theNextSong];
}
- (void)theNextSong{
    if (_playerMode != AudioPlayerModeSinglePlay) {
        [self nextIndexAdd];
    }
    [self updateAudioPlayer];
}

- (void)nextIndexAdd{
    _index++;
    if (_index == _modelArray.count) {
        _index = 0;
    }
}

- (void)previousIndexSub{
    _index--;
    if (_index < 0) {
        _index = _modelArray.count -1;
    }
}
- (void)play{
    _isPlaying = YES;
    [self.player play];
    [self.playButton setImage:[UIImage imageNamed:@"MusicPlayer_播放"] forState:UIControlStateNormal];
    // 开始旋转
    [self.rotatingView resumeLayer];
}

- (void)stop{
    _isPlaying = NO;
    [self.player pause];
    [self.playButton setImage:[UIImage imageNamed:@"MusicPlayer_暂停"] forState:UIControlStateNormal];
    // 停止旋转
    [self.rotatingView pauseLayer];
}
#pragma mark - 移除通知&KVO
- (void)removeObserverAndNotification{
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [playerItem removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
#pragma mark - 后台UI设置
- (void)setLockViewWith:(XCListModel*)model currentTime:(CGFloat)currentTime
{
    NSMutableDictionary *musicInfo = [NSMutableDictionary dictionary];
    // 设置Singer
//    [musicInfo setObject:model.singer forKey:MPMediaItemPropertyArtist];
    // 设置歌曲名
    [musicInfo setObject:model.listTitle forKey:MPMediaItemPropertyTitle];
    // 设置封面
    MPMediaItemArtwork *artwork;
    artwork = [[MPMediaItemArtwork alloc] initWithImage:self.rotatingView.imageView.image];
    [musicInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //音乐剩余时长
    [musicInfo setObject:[NSNumber numberWithDouble:_totalTime] forKey:MPMediaItemPropertyPlaybackDuration];
    //音乐当前播放时间
    [musicInfo setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:musicInfo];
}

- (IBAction)backList:(UIButton *)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCOneTableViewController *men=[sb instantiateViewControllerWithIdentifier:@"onetabvc"];
    men.url=self.menuUrl;
    men.img=self.menuImg;
    men.des=self.overview;
//    [self presentViewController:men animated:YES completion:nil];
    [self.navigationController pushViewController:men animated:YES];
}


@end
