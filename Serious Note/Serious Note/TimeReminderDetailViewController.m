//
//  TimeReminderDetailViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "TimeReminderDetailViewController.h"

@interface TimeReminderDetailViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *textView;

@end

@implementation TimeReminderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneButton.enabled = false;
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
