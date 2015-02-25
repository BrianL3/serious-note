//
//  TimeReminderDetailViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "TimeReminderDetailViewController.h"
#import "RecipientSelectionViewController.h"

@interface TimeReminderDetailViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property BOOL hasAudio;
@property (strong, nonatomic) NSURL* audioFileLocation;
@property (strong, nonatomic) Reminder* myReminder;
@end

@implementation TimeReminderDetailViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneButton.enabled = false;
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.textView.text > 0 || self.hasAudio == true){
        self.doneButton.enabled = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: TEXTFIELD DELEGATE


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
  if (range.length + range.location > textField.text.length)
  {
    self.doneButton.enabled = false;
    return false;
  }
  
  NSUInteger newLength = textField.text.length + (string.length - range.length);
  if (newLength <= 50) {
    self.doneButton.enabled = true;
  }
  
  else // length limit exceeded - let user know
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text Length Exceeded" message:@"Text is limitd to 50 characters" delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  }
  
  return (newLength > 50) ? false : true;
  
} // shouldChangeCharactersInRange


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textView resignFirstResponder];
    return true;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ADD_AUDIO_TO_TIME"]){
        RecorderViewController *modalVC = [[RecorderViewController alloc] init];
        modalVC = segue.destinationViewController;
        // completion block instead of delegate pattern
        modalVC.audioSet = ^(NSURL *response) {
            self.hasAudio = true;
            self.audioFileLocation = response;
            NSLog(@"the audio was properly set to following filepath:%@", response);
        };
    }
    if ([segue.identifier isEqualToString:@"TIME_CHOOSE_RECIPIENT"]) {
        RecipientSelectionViewController* destinationVC = [[RecipientSelectionViewController alloc] init];
        destinationVC = segue.destinationViewController;
        NSData* audioData;
        if(self.audioFileLocation){
            audioData = [[NSData alloc] initWithContentsOfURL:self.audioFileLocation];
        }
        
        self.myReminder = [[Reminder alloc] initWithTime:self.selectedDate withText:self.textView.text withAudio: audioData withVideo:nil];
        destinationVC.selectedReminder = self.myReminder;
        
     // create a new reminder, set the new VC's thing to the new reminder
    }
    
}


@end
