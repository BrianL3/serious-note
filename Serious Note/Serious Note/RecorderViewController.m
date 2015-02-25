//
//  RecorderViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "RecorderViewController.h"

@interface RecorderViewController () <AVAudioRecorderDelegate>
@property (strong, nonatomic) IBOutlet UIView *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (strong, nonatomic) NSError* lastError;
@property (strong, nonatomic) NSURL* audioFileLocation;
@property (strong, nonatomic) AVAudioRecorder* recorder;
@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"audioMemo.m4a", nil];
    self.audioFileLocation = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // create the recorder, fill up lastError if it failed
    NSError * __autoreleasing tmpError;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.audioFileLocation settings:recordSetting error: &tmpError];
    self.lastError = tmpError;
    
    // become the recorder's delegate, allow for metering, and prepare it to record
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
    
    self.audioFileLocation = self.recorder.url;
    
    //last bits of setup
    self.endButton.enabled = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonPressed:(id)sender {
    [self.recorder record];
    NSLog(@"The current status of the player: %s", self.recorder.recording ? "recording" : "not recording");

    self.startButton.enabled = false;
    self.endButton.enabled = true;
    
}

- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"the length of the recording was: %f", [self.recorder currentTime]);
    self.audioSet(self.audioFileLocation);
    [self.recorder stop];

    NSLog(@"Stop button was pressed, the status of the player: %s", self.recorder.recording ? "recording" : "not recording");

    self.endButton.enabled = false;
    self.startButton.enabled = true;
}
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)deleteAudioFile{
    NSError* tmpError;
    [[NSFileManager defaultManager]removeItemAtPath:self.audioFileLocation.absoluteString error:&tmpError];
}


@end
