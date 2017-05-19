//
//  ViewController.h
//  MusicTask
//
//  Created by apple on 19/05/17.
//  Copyright © 2017 Mizpahsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>

@interface ViewController : UIViewController
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *backwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLbl;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

