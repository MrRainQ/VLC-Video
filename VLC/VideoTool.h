//
//  VideoTool.h
//  VLC
//
//  Created by sen5labs on 14-11-18.
//  Copyright (c) 2014年 sen5labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChannelModel;
@interface VideoTool : NSObject

+ (NSArray *)videos;


+ (void)setVideos:(NSArray *)videos;


+ (ChannelModel *)playingVideo;
+ (void)setPlayingVideo:(ChannelModel *)playingVideo;


+ (ChannelModel *)nextVideo;

+ (ChannelModel *)previousVideo;

@end
