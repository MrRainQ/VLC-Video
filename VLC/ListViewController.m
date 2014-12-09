//
//  ListViewController.m
//  VLC
//
//  Created by sen5labs on 14-11-13.
//  Copyright (c) 2014年 sen5labs. All rights reserved.
//

#import "ListViewController.h"
#import "VideoTool.h"
#import "ChannelModel.h"
#import "ContainViewController.h"

@interface ListViewController ()
@property (nonatomic,strong) NSMutableArray *medias;
@end

@implementation ListViewController

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
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [VideoTool setVideos:self.medias];
    return self.medias.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    ChannelModel *ch = self.medias[indexPath.row];
    cell.textLabel.text = ch.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [VideoTool setPlayingVideo:[VideoTool videos][indexPath.row]];

    ContainViewController *view = [[ContainViewController alloc]init];
    
    [self.navigationController pushViewController:view animated:YES];
}



@end
