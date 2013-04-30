//
//  OKDeletableTextField.m
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 4/29/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "OKDeletableTextField.h"

@implementation OKDeletableTextField {
    BOOL _isNowEmpty;
}

- (void)deleteBackward {
    [super deleteBackward];
    
    if (_isNowEmpty) {
        if ([self.okTextFieldDelegate respondsToSelector:@selector(textFieldDidDelete:)]) [self.okTextFieldDelegate textFieldDidDelete:self];
        _isNowEmpty = NO;
    }
    
    if (self.text.length == 0) {
        _isNowEmpty = YES;
    }
}

@end
