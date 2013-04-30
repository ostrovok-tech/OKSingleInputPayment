//
//  OKDeletableTextField.h
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 4/29/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OKDeletableTextFieldDelegate;
@interface OKDeletableTextField : UITextField
@property (weak) id <OKDeletableTextFieldDelegate> okTextFieldDelegate;
@end


//create delegate protocol
@protocol OKDeletableTextFieldDelegate <NSObject>
@optional
- (void)textFieldDidDelete:(OKDeletableTextField *)textField;
@end