//
//  InputAlertView.m
//  Feedoo
//
//  Created by Jinxiao on 13-3-30.
//  Copyright (c) 2013年 debugeek. All rights reserved.
//

#import "InputAlertView.h"

#import <QuartzCore/QuartzCore.h>

@interface InputAlertView () <UIAlertViewDelegate>
@property (weak, nonatomic, readonly) UITextField *inputField;
@end

typedef enum _InputAlertViewButtonIndex : NSInteger
{
    InputAlertViewButtonIndexCancel     = 0,
    InputAlertViewButtonIndexConfirm    = 1,
} InputAlertViewButtonIndex;

@implementation InputAlertView

- (id)initWithAlertTitle:(NSString *)title confirmButtonTitle:(NSString *)confirmButtonTitle confirmActionBlock:(ConfirmActionBlock)confirmActionBlock cancelButtonTitle:(NSString *)cancelButtonTitle cancelActionBlock:(CancelActionBlock)cancelActionBlock
{
    self = [super initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
    if(self)
    {
        self.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        self.inputField.delegate = self;
        self.inputField.returnKeyType = UIReturnKeySend;
        
        _cancelActionBlock = [cancelActionBlock copy];
        _confirmActionBlock = [confirmActionBlock copy];
    }
    
    return self;
    
}

- (UITextField *)inputField
{
    return [self textFieldAtIndex:0];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.inputField.placeholder = placeholder;
}

- (void)show
{
    [super show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1f*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self.inputField becomeFirstResponder];
    });
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case InputAlertViewButtonIndexConfirm:
        {
            if(_confirmActionBlock)
            {
                _confirmActionBlock(self.inputField.text);
            }
            break;
        }
        case InputAlertViewButtonIndexCancel:
        {
            if(_cancelActionBlock)
            {
                _cancelActionBlock();
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL result = NO;
    if([textField.text length] > 0)
    {
        result = YES;
        
        [self dismissWithClickedButtonIndex:InputAlertViewButtonIndexConfirm animated:YES];
    }
    
    return result;
}

- (void)dealloc
{
    _confirmActionBlock = NULL;
    _cancelActionBlock = NULL;
    
}

@end
