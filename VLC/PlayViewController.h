//
//  PlayViewController.h
//  VLC
//
//  Created by sen5labs on 14-11-12.
//  Copyright (c) 2014年 sen5labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@protocol PlayViewDelegate <NSObject>

- (void)rotateScreen:(BOOL)isRotate;

@end

@interface PlayViewController : UIViewController
@property (nonatomic, strong) VLCMediaPlayer *mediaPlayer;

@property (nonatomic,weak) id <PlayViewDelegate>delegate;
@end
