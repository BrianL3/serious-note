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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString* oldText = self.textView.text;
    NSString* newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    self.doneButton.enabled = (newText.length > 0 || newText.length < 50);
    
    return true;
}

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
