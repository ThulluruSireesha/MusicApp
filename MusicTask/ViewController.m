//
//  ViewController.m
//  MusicTask
//
//  Created by apple on 19/05/17.
//  Copyright © 2017 Mizpahsoft. All rights reserved.
//

#import "ViewController.h"
#import "songTableViewCell.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>
{
    NSMutableArray*songName;
    NSMutableArray*songArr;
     NSArray *itemsFromGenericQuery;
    BOOL playing;
    int index;
}
@property (weak, nonatomic) IBOutlet UITableView *songsTblView;
@property MPMusicPlayerController *musicPlayerController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
    _playView.hidden=YES;
    songName=[[NSMutableArray alloc]init];
    songArr=[[NSMutableArray alloc]init];
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSInteger MediaType = [[song valueForProperty: MPMediaItemPropertyMediaType] integerValue];
        if (MediaType==1) {
            [songArr addObject:[song valueForProperty:MPMediaItemPropertyAssetURL]];
            [songName addObject:songTitle];
        }
    }
    self.songsTblView.delegate=self;
    self.songsTblView.dataSource=self;
   
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:nil error:nil];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"nextTrackCommand handler for event %@", event);
        [self.musicPlayerController skipToNextItem];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
  
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return songArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    songTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"songCell"];
    cell.songLbl.text=[songName objectAtIndex:indexPath.row];

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     _playView.hidden=NO;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[songArr objectAtIndex:indexPath.row] error:nil];
    index=(int)indexPath.row;
    self.countLabel.text =[NSString stringWithFormat:@"%d of %d",index+1,(int)songArr.count];
    self.songLbl.text=[songName objectAtIndex:indexPath.row];
    self.audioPlayer.delegate=self;
   self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer prepareToPlay];
     [self.audioPlayer play];
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
   
        [self.audioPlayer play];
         [_playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
         commandCenter.playCommand.enabled = YES;
        playing=YES;
        self.slider.maximumValue = [self.audioPlayer duration];
        self.slider.value = 0.0;
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];

      
    
        
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"download"]];
    
    [songInfo setObject:[songName objectAtIndex:index] forKey:MPMediaItemPropertyTitle];
    [songInfo setObject:@"t" forKey:MPMediaItemPropertyArtist];
    [songInfo setObject:[NSNumber numberWithDouble:self.audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
    [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
    
    [playingInfoCenter setNowPlayingInfo:songInfo];
    [MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand.enabled = YES;
    [[MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"previousTrackCommand handler for event %@", event);
        [self.musicPlayerController skipToPreviousItem];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"playCommand handler for event %@", event);
        [self.audioPlayer play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [MPRemoteCommandCenter sharedCommandCenter].playCommand.enabled = YES;
    
    
    [[MPRemoteCommandCenter sharedCommandCenter].pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"pauseCommand handler for event %@", event);
        [self.audioPlayer pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [MPRemoteCommandCenter sharedCommandCenter].pauseCommand.enabled = YES;
    
    
    

}
- (void)updateTime:(NSTimer *)timer {
    self.slider.value = self.audioPlayer.currentTime;
   
    
}
-(IBAction)playbuttonclicked:(UIButton *)sender{
    if(playing==YES)
    {
        [self.audioPlayer pause];
         [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
       
          playing=NO;
        
    }
    else if (playing==NO)
        
    {
        [self.audioPlayer play];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];

        playing=YES;
        
    }

   
}
- (IBAction)backwardAction:(id)sender {
    if (index>0)
    {
        index--;
        self.countLabel.text =[NSString stringWithFormat:@"%d of %d",index+1,(int)songArr.count];
        self.songLbl.text=[songName objectAtIndex:index];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[songArr objectAtIndex:index] error:nil];
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
}
- (IBAction)forwarAction:(id)sender {
    if (index<[songArr count]-1)
    {
        index++;
        self.countLabel.text =[NSString stringWithFormat:@"%d of %d",index+1,(int)songArr.count];
          self.songLbl.text=[songName objectAtIndex:index];
         self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[songArr objectAtIndex:index] error:nil];
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        
    }

}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //Increment index but don't go out of bounds
    index = ++index % [songArr count];
    [self playCurrentSong];
}
-(void) playCurrentSong
{
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[songArr objectAtIndex:index]  error:&error];
    if(error !=nil)
    {
        NSLog(@"%@",error);
        //Also possibly increment sound index and move on to next song
    }
    else
    {
        self.songLbl.text = [songArr objectAtIndex:index];
        [_audioPlayer setDelegate:self];
        [_audioPlayer prepareToPlay]; //This is not always needed, but good to include
        [_audioPlayer play];
    }
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    _audioPlayer.currentTime = _slider.value;
}
@end
