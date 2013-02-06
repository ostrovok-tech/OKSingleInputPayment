//
//  OKSingleInputPayment.m
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/6/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "OKSingleInputPayment.h"

@interface OKSingleInputPayment()
@property (strong, nonatomic) UITextField *cardNumberTextField;
@property (strong, nonatomic) UITextField *expirationTextField;
@property (strong, nonatomic) UITextField *cvcTextField;
@property (strong, nonatomic) UITextField *zipTextField;
@property (strong, nonatomic) UILabel *lastFourLabel;

@property (strong, nonatomic) NSString *trimmedNumber;
@property (strong, nonatomic) NSString *lastFour;


@property (strong, nonatomic) UIImageView *containerView;
@property (strong, nonatomic) UIImageView *leftCardView;

@property (strong, nonatomic) UITextField *activeTextField;


@property OKCardType displayingCardType;
@property OKPaymentStep paymentStep;

@property BOOL ccNumberInvalid;

@property (strong, nonatomic) UIToolbar *accessoryToolBar;

@end

@implementation OKSingleInputPayment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit:frame];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit:self.frame];
    }
    return self;
}

- (void)awakeFromNib  {
    UIImage *background = [[UIImage imageNamed:@"field_cell"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = background;
    self.containerView = imageView;
    [self addSubview:self.containerView];
    
        
    self.leftCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"credit_card_icon"]];
    self.leftCardView.backgroundColor = [UIColor blueColor];
    [self.leftCardView setFrame:CGRectMake(10, (self.frame.size.height / 2) - (self.leftCardView.frame.size.height/2), self.leftCardView.frame.size.width, self.leftCardView.frame.size.height)];
    
    int padding = 5;
    self.cardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + padding, (self.frame.size.height / 2) - ((self.frame.size.height * 0.9) /2), self.frame.size.width - ((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + padding), self.frame.size.height * 0.9)];
    self.cardNumberTextField.backgroundColor = [UIColor yellowColor];
    self.cardNumberTextField.font = self.textFieldFont;
    self.cardNumberTextField.delegate = self;
    self.cardNumberTextField.adjustsFontSizeToFitWidth = YES;
    self.cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.cardNumberTextField.placeholder = self.numberPlaceholder;
    self.cardNumberTextField.inputAccessoryView = self.accessoryToolBar;
    [self.cardNumberTextField addTarget:self action:@selector(cardNumberTextFieldValueChanged) forControlEvents:UIControlEventEditingChanged];

    [self addSubview:self.cardNumberTextField];
    [self addSubview:self.leftCardView];
    
    float availSpace = self.frame.size.width - ((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + (padding * 4));
    float widthPerField = availSpace / 4; 
    
    //CGSize expextedLabelSize = [@"2384" sizeWithFont:self.textFieldFont];
    self.lastFourLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    self.lastFourLabel.backgroundColor = [UIColor greenColor];
    self.lastFourLabel.hidden = YES;
    [self addSubview:self.lastFourLabel];
    
    self.expirationTextField = [[UITextField alloc] initWithFrame:CGRectMake((self.lastFourLabel.frame.origin.x + self.lastFourLabel.frame.size.width) + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    self.expirationTextField.backgroundColor = [UIColor greenColor];
    self.expirationTextField.font = self.textFieldFont;
    self.expirationTextField.placeholder = self.expirationPlaceholder;
    self.expirationTextField.adjustsFontSizeToFitWidth = YES;
    self.expirationTextField.delegate = self;
    self.expirationTextField.hidden = YES;
    [self addSubview:self.expirationTextField];
    
    
    self.cvcTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.expirationTextField.frame.origin.x + self.expirationTextField.frame.size.width + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    self.cvcTextField.backgroundColor = [UIColor greenColor];
    self.cvcTextField.placeholder = self.cvcPlaceholder;
    self.cvcTextField.font = self.textFieldFont;
    self.cvcTextField.adjustsFontSizeToFitWidth = YES;
    self.cvcTextField.delegate = self;
    self.cvcTextField.hidden = YES;
    [self addSubview:self.cvcTextField];
    
    self.zipTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.cvcTextField.frame.origin.x + self.cvcTextField.frame.size.width + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    self.zipTextField.backgroundColor = [UIColor greenColor];
    self.zipTextField.adjustsFontSizeToFitWidth = YES;
    self.zipTextField.placeholder = self.zipPlaceholder;
    self.zipTextField.font = self.textFieldFont;
    self.zipTextField.delegate = self;
    self.zipTextField.hidden = YES;
    [self addSubview:self.zipTextField];
}

- (void)commonInit:(CGRect)frame {
    self.textFieldFont = [UIFont fontWithName:@"Helvetica" size:28];
    self.includeZipCode = YES;
    self.paymentStep = OKPaymentStepCCNumber;
    self.displayingCardType = OKCardTypeUnknown;
    self.expirationPlaceholder = @"mm/yy";
    self.cvcPlaceholder = @"cvc";
    self.numberPlaceholder = @"4111 1111 1111 1111";
    self.accessoryToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    [self setupAccessoryToolbar];
}

- (void)setupBackSide {
    self.cardNumberTextField.hidden = YES;
    self.lastFourLabel.hidden = self.expirationTextField.hidden = self.cvcTextField.hidden = NO;
    if (self.includeZipCode)
        self.zipTextField.hidden = NO;
    
    self.lastFourLabel.text = [NSString stringWithFormat:@"%@/%@", self.cardMonth, self.cardYear];
}

- (IBAction)next:(id)sender {
    if (self.activeTextField == self.cardNumberTextField) {
        [self setupBackSide];
        [self.expirationTextField becomeFirstResponder];
    } else if (self.activeTextField == self.expirationTextField) {
        [self.cvcTextField becomeFirstResponder];
    } else if (self.activeTextField == self.cvcTextField) {
        if (self.includeZipCode)
            [self.zipTextField becomeFirstResponder];
    }
}

- (IBAction)previous:(id)sender {
    if (self.activeTextField == self.cardNumberTextField) {
        [self setupBackSide];
    }
}


- (void)setupAccessoryToolbar {
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previous:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTyping:)];
    self.accessoryToolBar.items = @[flexibleSpace, previousButton, nextButton];
}


#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.cvcTextField) {
        [self setCvcCard];
    }
    self.activeTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"Text: %@, replacementString: %@, Length of text %d", textField.text, string, textField.text.length);
    
    if ([string isEqualToString:@" "])
        return NO;
    
    if (self.paymentStep == OKPaymentStepCCNumber) {
        if (textField.text.length == 0) {
            NSLog(@"first number entered");
            if ([string isEqualToString:@"4"]) {
                NSLog(@"IT'S A VISA");
                [self setVisaCard];
            } else if ([string isEqualToString:@"5"]) {
                NSLog(@"IT'S A MASTERCARD");
                [self setMasterCard];
            } else {
                NSLog(@"IT'S UNKNOWN");
                [self setUnkownCard];
            }
        }
        
        if ((textField.text.length == 4 || textField.text.length == 9 || textField.text.length == 14) && string.length != 0) {
            textField.text = [textField.text stringByAppendingFormat:@" %@", string];
            return NO;
        } else if (textField.text.length == 19 && ![string isEqualToString:@""]) {
            return NO;
        }
    } else if (self.paymentStep == OKPaymentStepExpiration) {
//        if ([string isEqualToString:@"/"]) {
//            if (textField.text.length == 1) {
//                self.text = [@"0" stringByAppendingFormat:@"%@/", self.text];
//                return NO;
//            } else {
//                
//            }
//        } else if (textField.text.length == 1 && ![string isEqualToString:@""]) {
//            self.text = [self.text stringByAppendingFormat:@"%@/", string];
//            return NO;
//        }
        
        
    }
    
    
    return YES;
}

- (void)cardNumberTextFieldValueChanged {
    if (self.ccNumberInvalid) {
        [self resetFieldState];
    }
    self.trimmedNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.trimmedNumber.length == 16) {
        NSLog(@"validate card. Number: %@", self.trimmedNumber);
        [self validateCardNumber];
    }
}

- (void)textFieldChanged {
    NSLog(@"value changed");
    
    if (self.paymentStep == OKPaymentStepCCNumber) {
        if (self.ccNumberInvalid) {
            [self resetFieldState];
        }
        self.trimmedNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (self.trimmedNumber.length == 16) {
            NSLog(@"validate card. Number: %@", self.trimmedNumber);
            [self validateCardNumber];
        }
    }
//    } else if (self.paymentStep == OKPaymentStepExpiration) {
//        self.expirationLabel.hidden = YES;
//        if (self.text.length == 5) {
//            NSArray *expirationParts = [self.text componentsSeparatedByString:@"/"];
//            self.cardMonth = expirationParts[0];
//            self.cardYear = expirationParts[1];
//            [self validateExpiration];
//        }
//    } else if (self.paymentStep == OKPaymentStepSecurityCode) {
//        self.cvcLabel.hidden = YES;
//        if (self.text.length == 3) {
//            self.cardCvc = self.text;
//            [self validateCvc];
//        }
//    }
    
}

#pragma mark - Validation methods
- (void)validateCardNumber {
    if (self.cardType == OKCardTypeUnknown) {
        NSLog(@"Invalid card type");
        [self invalidFieldState];
        return;
    }
    
    self.cardNumber = self.trimmedNumber;
    self.lastFour = [self.cardNumber substringFromIndex: [self.cardNumber length] - 4];
    [self next:self];
}
    
#pragma mark - Set card types
- (void)setCvcCard {
    if (self.displayingCardType == OKCardTypeCvc)
        return;
    self.displayingCardType = OKCardTypeCvc;
    [UIView transitionWithView:self.leftCardView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.leftCardView.image = [UIImage imageNamed:@"cvc_icon"];
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
    
}

- (void)setUnkownCard {
    if (self.displayingCardType == OKCardTypeUnknown)
        return;
    self.cardType = self.displayingCardType = OKCardTypeUnknown;
    
    [UIView transitionWithView:self.leftCardView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.leftCardView.image = [UIImage imageNamed:@"credit_card_icon"];
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
}
- (void)setMasterCard {
    if (self.displayingCardType == OKCArdTypeMastercard)
        return;
    //self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mastercard_icon" ]];
    self.cardType = self.displayingCardType = OKCArdTypeMastercard;
    
    [UIView transitionWithView:self.leftCardView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        //((UIImageView *)self.leftView).image = [UIImage imageNamed:@"mastercard_icon"];
        self.leftCardView.image = [UIImage imageNamed:@"mastercard_icon"];
        
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
    
}

- (void)setVisaCard {
    if (self.displayingCardType == OKCardTypeVisa)
        return;
    
    self.cardType = self.displayingCardType = OKCardTypeVisa;
    
    [UIView transitionWithView:self.leftCardView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft  animations:^{
        self.leftCardView.image = [UIImage imageNamed:@"visa_icon"];
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
}


- (void)shakeAnimation:(UIView *) view {
    const int reset = 5;
    const int maxShakes = 6;
    
    //pass these as variables instead of statics or class variables if shaking two controls simultaneously
    static int shakes = 0;
    static int translate = reset;
    
    [UIView animateWithDuration:0.09-(shakes*.01) // reduce duration every shake from .09 to .04
                          delay:0.01f//edge wait delay
                        options:(enum UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{view.transform = CGAffineTransformMakeTranslation(translate, 0);}
                     completion:^(BOOL finished){
                         if(shakes < maxShakes){
                             shakes++;
                             
                             //throttle down movement
                             if (translate>0)
                                 translate--;
                             
                             //change direction
                             translate*=-1;
                             [self shakeAnimation:view];
                         } else {
                             view.transform = CGAffineTransformIdentity;
                             shakes = 0;//ready for next time
                             translate = reset;//ready for next time
                             return;
                         }
                     }];
}

#pragma mark - Field styles
- (void)invalidFieldState {
    self.containerView.image = [[UIImage imageNamed:@"field_cell_error"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    self.ccNumberInvalid = YES;
    [self shakeAnimation:self.containerView];
}

- (void)resetFieldState {
    self.containerView.image = [[UIImage imageNamed:@"field_cell"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    self.ccNumberInvalid = NO;
}


@end
