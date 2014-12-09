//
//  PlayViewController.m
//  VLC
//
//  Created by sen5labs on 14-11-12.
//  Copyright (c) 2014年 sen5labs. All rights reserved.
//

#import "PlayViewController.h"
#import "VideoTool.h"
#import "ChannelModel.h"
#import "UIView+RQ.h"
@interface PlayViewController ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UIView *activityView ;

@property (nonatomic,assign) BOOL isPlay;
@property (nonatomic,assign) BOOL isRotation;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *stateTimer;
@property (nonatomic,strong) ChannelModel *playingVideo;

@property (nonatomic,strong) NSMutableArray *medias;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator; // 加载指示器


@end

@implementation PlayViewController

#pragma mark - 懒加载
- (VLCMediaPlayer *)mediaPlayer
{
    if (!_mediaPlayer) {
        VLCMediaPlayer *mediaPlayer = [[VLCMediaPlayer alloc] init];
        mediaPlayer.drawable = self.movieView;
        self.mediaPlayer = mediaPlayer;
    }
    return _mediaPlayer;
}

- (NSMutableArray *)medias
{
    if (!_medias) {
        // 播放列表
        NSMutableArray *medias = [NSMutableArray array];
        for (int i = 0; i<=16; i++) {
            NSString *bundleName = [NSString stringWithFormat:@"minion_0%d.mp4",i % 5 + 1];
            ChannelModel *chan = [[ChannelModel alloc]init];
            chan.name = bundleName;
            [medias addObject:chan];
        }
        self.medias = medias;
    }
  
    return _medias;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.movieView setImage:@"videoview_cover"];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
						  UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];

    [self playVideo];

    [self addTimer];
    
    [self addStateTimer];
}


#pragma mark - 播放状态监听器
- (void)addStateTimer
{
    self.stateTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(monitorPlayStates) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.stateTimer forMode:NSRunLoopCommonModes];
}

- (void)monitorPlayStates
{
    if ([self.mediaPlayer isPlaying]) {
      [self removeStateTimer];
        [self.activityIndicator stopAnimating];
    }else{
         [self.activityIndicator startAnimating];
    }
}

- (void)removeStateTimer
{
    [self.stateTimer invalidate];
    self.stateTimer = nil;
}


//******************************************************************************
#pragma mark - 播放器按钮的控制操作
#pragma mark  重置播放器
- (void)resetVideo
{
    [self.mediaPlayer stop];
    self.mediaPlayer = nil;
}

#pragma make 播放
- (void)playVideo
{
    self.playingVideo = [VideoTool playingVideo];
   
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.playingVideo.name withExtension:nil];
    VLCMedia *media = [VLCMedia mediaWithURL:url];
    self.mediaPlayer.media = media;
    
    [self.mediaPlayer play];
}

#pragma mark 开始暂停
- (IBAction)startPauseBtnClick:(UIButton *)sender {
    
    NSLog(@"state %d",[self.mediaPlayer state]);
    sender.selected = self.mediaPlayer.isPlaying;
    if (self.mediaPlayer.isPlaying) {
        [self.mediaPlayer pause];
    } else {
        [self.mediaPlayer play];
    }
}


#pragma mark 上一台
- (IBAction)prevChannelAction:(UIButton *)sender {
    
    [self resetVideo];
    
    [VideoTool setPlayingVideo:[VideoTool previousVideo]];
    
    [self addStateTimer];
    
    [self playVideo];
}

#pragma mark 下一台
- (IBAction)nextChannelAction:(UIButton *)sender{
    
    [self resetVideo];
    
    [VideoTool setPlayingVideo:[VideoTool nextVideo]];

    [self addStateTimer];
    
    [self playVideo];
}

#pragma mark  横竖屏切换
- (IBAction)fullScreen:(UIButton *)sender{
    
    self.isRotation = !self.isRotation;
    sender.selected = self.isRotation;
    if ([_delegate respondsToSelector:@selector(rotateScreen:)]) {
        [_delegate rotateScreen:self.isRotation];
    }
    if (self.isRotation) {

            self.view.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
            self.view.center =  CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
            self.movieView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
        
            [UIView animateWithDuration:0.2f animations:^{
                CGAffineTransform  transform = CGAffineTransformRotate(self.view.transform, M_PI / 2);
                self.view.transform = transform;
            }];
    }else{

            [UIView animateWithDuration:0.2f animations:^{
                CGAffineTransform  transform = CGAffineTransformRotate(self.view.transform,- M_PI / 2);
                self.view.transform = transform;
            }];
            self.view.frame = CGRectMake(0, 64, kScreenWidth, 180);
            self.movieView.frame = CGRectMake(0, 0, kScreenWidth, 180);
    }
}

//******************************************************************************
// top 和 bottom 部分的控制
#pragma mark - 时间计时器
- (void)addTimer
{
    self.timer = [NSTimer timerWithTimeInterval:10.f target:self selector:@selector(hiddenTopAndBottomView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)hiddenTopAndBottomView
{
    [UIView animateWithDuration:.2f animations:^{
        self.topView.alpha = 0.0f;
        self.bottomView.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [self removeTimer];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.topView.alpha == 0.0f) {
        self.topView.alpha = 1.0f;
        self.bottomView.alpha = 1.0f;
        [self addTimer];
    }else{
        self.topView.alpha = 0.0f;
        self.bottomView.alpha = 0.0f;
    }
}

@end
