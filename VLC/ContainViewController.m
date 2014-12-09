//
//  ViewController.m
//  VLC
//
//  Created by sen5labs on 14-11-11.
//  Copyright (c) 2014年 sen5labs. All rights reserved.
//

#import "ContainViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "PlayViewController.h"
#import "VideoTool.h"
#import "ChannelModel.h"
@interface ContainViewController ()<PlayViewDelegate>

@property (nonatomic,strong) PlayViewController *player;
@property (nonatomic,assign) BOOL isFullScreen;
@property (nonatomic,strong) NSArray *dataList;

@end

@implementation ContainViewController


- (BOOL)prefersStatusBarHidden
{
    return _isFullScreen;
}

- (void)back
{
    [self.player.mediaPlayer stop];
     self.player = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (PlayViewController *)player
{
    if (!_player) {
        _player = [[PlayViewController alloc]init];
        _player.delegate = self;
    }
    return _player;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.player.view.frame = CGRectMake(0, 64, 320, 180);
    [self.view addSubview:self.player.view];    
}

- (void)rotateScreen:(BOOL)isRotate
{
    _isFullScreen = isRotate;
    self.navigationController.navigationBarHidden = isRotate;
}

@end
