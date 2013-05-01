//
//  OKDeletableTextField.m
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 4/29/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "OKDeletableTextField.h"

@implementation OKDeletableTextField {
    NSInteger _previousLength;
    NSInteger _currentLength;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _currentLength = 0;
    _previousLength = 0;
}

- (void)deleteBackward {
    [super deleteBackward];
    //NSLog(@"in deleteBackward with text %@", self.text);
    _currentLength = self.text.length;
    if (_currentLength == 0 && _previousLength < 1) {
        if ([self.okTextFieldDelegate respondsToSelector:@selector(textFieldDidDelete:)]) [self.okTextFieldDelegate textFieldDidDelete:self];
    }
    
    _previousLength = self.text.length;
    
     
}

@end
