//
//  OKSingeInputPaymentField.m
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/1/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "OKSingeInputPaymentField.h"

@interface OKSingeInputPaymentField()
@property (strong, nonatomic) UILabel *expirationLabel;
@property (strong, nonatomic) UILabel *cvcLabel;
@property (strong, nonatomic) UILabel *zipLabel;
@property (strong, nonatomic) UILabel *lastFourLabel;

@property (strong, nonatomic) NSString *trimmedNumber;
@property (strong, nonatomic) NSString *lastFour;


@property (strong, nonatomic) UIImageView *leftViewImageView;
@property (strong, nonatomic) UIView *leftViewContainerView;


@property BOOL ccNumberInvalid;
@property BOOL isOnBackSide;

@end

@implementation OKSingeInputPaymentField

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

//- (void)awakeFromNib {
//    //[super awakeFromNib];
//    //[self setupLeftView];
//    NSLog(@"awake from nib");
//}
//
//- (void)didAddSubview:(UIView *)subview {
//    [super didAddSubview:subview];
//    NSLog(@"didaddsubview");
//
//}
//

- (void)commonInit:(CGRect)frame {
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    self.cardType = OKCardTypeUnknown;
    self.paymentStep = OKPaymentStepCCNumber;
    self.placeholder = @"4111 1111 1111 1111";
    self.font = [UIFont fontWithName:@"Helvetica" size:25];
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.background = [[UIImage imageNamed:@"field_cell"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    self.borderStyle = UITextBorderStyleNone;
    self.accessoryToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    [self setupAccessoryToolbar];
    
    
    
    UIImage *creditCard = [UIImage imageNamed:@"credit_card_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, creditCard.size.width + 10, creditCard.size.height + 10)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = creditCard;
    self.leftViewImageView = imageView;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.leftView.frame.origin.x, self.leftView.frame.origin.y, self.leftViewImageView.frame.size.width, self.leftViewImageView.frame.size.height)];
    view.backgroundColor = [UIColor blueColor];
    [view addSubview:self.leftViewImageView];
    self.leftViewContainerView = view;
    self.leftView = self.leftViewContainerView;
    //self.leftView = imageView;

    self.leftViewMode = UITextFieldViewModeAlways;
    
    // include zip?
    self.includeZipCode = YES;
    
    // default placeholder
    self.expirationPlaceholder = @"MM/YY";
    self.cvcPlaceholder = @"CVC";
    self.zipPlaceholder = @"55128";
    self.paddingBetweenPlaceholders = 5;
    self.isOnBackSide = NO;
}

- (void)setupLeftView {
    //setup left view
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftViewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"credit_card_icon"]];
    //self.leftViewImageView.contentMode = UIViewContentModeCenter;
    //self.leftViewImageView.image = creditCardIcon;
    
    self.leftViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0 )];
    [self.leftViewContainerView addSubview:self.leftViewImageView];
    self.leftViewContainerView.backgroundColor = [UIColor blueColor];
    self.leftView = self.leftViewContainerView;
}

- (void)setupExpiration {
    
    CGSize lastFourSize = [@"1111" sizeWithFont:self.font];
    
    
    
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, totalWidth, self.frame.size.height)];
    //view.backgroundColor = [UIColor blueColor];
    //[view addSubview:imageView];
    
    self.lastFourLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.leftViewImageView.frame.origin.x + self.leftViewImageView.frame.size.width), 0, lastFourSize.width, self.frame.size.height)];
    self.lastFourLabel.text = self.lastFour;
    self.lastFourLabel.backgroundColor = [UIColor yellowColor];
    self.lastFourLabel.font = self.font;
    float totalWidth = self.leftViewContainerView.frame.size.width + 10 + self.lastFourLabel.frame.size.width;
    [self.leftViewContainerView setFrame:CGRectMake(self.leftViewContainerView.frame.origin.x, self.leftViewContainerView.frame.origin.y, totalWidth, self.leftViewContainerView.frame.size.height)];
    [self.leftViewContainerView addSubview:self.lastFourLabel];

   }


- (void)moveExpirationToLeftView {
    [self.leftViewContainerView setFrame:CGRectMake(self.leftViewContainerView.frame.origin.x, self.leftViewContainerView.frame.origin.y,  self.leftViewContainerView.frame.size.width + self.expirationLabel.frame.size.width, self.leftViewContainerView.frame.size.height)];
    [self.expirationLabel removeFromSuperview];
    self.expirationLabel.text = [NSString stringWithFormat:@"%@/%@", self.cardMonth, self.cardYear];
    self.expirationLabel.hidden = NO;
    self.expirationLabel.font = self.font;
    [self.expirationLabel setFrame:CGRectMake((self.lastFourLabel.frame.origin.x + self.lastFourLabel.frame.size.width) + 10, 0, self.expirationLabel.frame.size.width, self.expirationLabel.frame.size.height)];
    [self.leftViewContainerView addSubview:self.expirationLabel];
}

- (void)moveCvcToLeftView {
    [self.leftViewContainerView setFrame:CGRectMake(self.leftViewContainerView.frame.origin.x, self.leftViewContainerView.frame.origin.y,  self.leftViewContainerView.frame.size.width + self.cvcLabel.frame.size.width, self.leftViewContainerView.frame.size.height)];
    [self.cvcLabel removeFromSuperview];
    self.cvcLabel.text = self.cardCvc;
    self.cvcLabel.font = self.font;
    self.cvcLabel.hidden = NO;
    [self.cvcLabel setFrame:CGRectMake((self.expirationLabel.frame.origin.x + self.expirationLabel.frame.size.width) + 10, 0, self.cvcLabel.frame.size.width, self.cvcLabel.frame.size.height)];
    [self.leftViewContainerView addSubview:self.cvcLabel];

}


- (void)setupAccessoryToolbar {
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(previousStep)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTyping:)];
    self.accessoryToolBar.items = @[flexibleSpace, previousButton, nextButton];
    self.inputAccessoryView = self.accessoryToolBar;
}

- (IBAction)focusExpiration:(id)sender {
    
}

- (IBAction)focusCvc:(id)sender {
    
}

- (IBAction)focusZip:(id)sender {
    
}

- (void)setupBack {
    [self setupLabels];
    self.placeholder = nil;
    self.text = nil;
}

- (void)nextStep {
    switch (self.paymentStep) {
        case OKPaymentStepCCNumber:
            [self setupExpiration];
            [self setupLabels];
            self.placeholder = nil;
            self.text = nil;
            self.paymentStep = OKPaymentStepExpiration;
            break;
            
        case OKPaymentStepExpiration:
            [self moveExpirationToLeftView];
            self.paymentStep = OKPaymentStepSecurityCode;
            self.text = nil;
            break;
            
        case OKPaymentStepSecurityCode:
            [self moveCvcToLeftView];
            self.text = nil;
            break;
        default:
            break;
    }
}

- (void)previousStep {
    switch (self.paymentStep) {
        case OKPaymentStepCCNumber:
            //[self testLeftView];
            //[self setupLabels];
            self.paymentStep = OKPaymentStepExpiration;
            break;
            
        case OKPaymentStepExpiration:
            
            break;
            
        case OKPaymentStepSecurityCode:
            
            break;
        default:
            break;
    }
    
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

#pragma mark - Validation methods
- (void)validateCardNumber {
    if (self.cardType == OKCardTypeUnknown) {
        NSLog(@"Invalid card type");
        [self invalidFieldState];
        return;
    }
    
    self.cardNumber = self.trimmedNumber;
    self.lastFour = [self.cardNumber substringFromIndex: [self.cardNumber length] - 4];
    [self nextStep];
    //self.cardNumber =
}

- (void)validateExpiration {
    [self nextStep];
}

- (void)validateCvc {
    [self nextStep];
}

- (void)step2 {
    
    //[self setupLabels];
}


- (void)setupLabels {
    CGSize expirationSize = [self.expirationPlaceholder sizeWithFont:self.font];
    CGSize cvcSize = [self.cvcPlaceholder sizeWithFont:self.font];
    CGSize zipSize = [self.zipPlaceholder sizeWithFont:self.font];
    CGSize lastFourSize = [@"1111" sizeWithFont:self.font];
    
    self.backgroundColor = [UIColor blueColor];
    
    UITextRange *range = [self selectedTextRange];
    CGRect selectionStartRect = [self caretRectForPosition:range.start];
    
    float widthOfLabels;
    float availSpace;
    float leftMargin = self.leftView.frame.size.width;
    float currentWidthOfLabels;
    if (self.includeZipCode) {
        availSpace = (self.frame.size.width - leftMargin ) - (self.paddingBetweenPlaceholders * 3);
        widthOfLabels = availSpace / 3;
        currentWidthOfLabels = expirationSize.width + cvcSize.width + zipSize.width;
    } else {
        availSpace = (self.frame.size.width - leftMargin) - (self.paddingBetweenPlaceholders * 2);
        widthOfLabels = availSpace / 2;
        currentWidthOfLabels = expirationSize.width + cvcSize.width;
    }
    NSLog(@"total space: %f, width of label: %f, current size of labels: %f", availSpace, widthOfLabels, currentWidthOfLabels);
    
    self.expirationLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + self.paddingBetweenPlaceholders, selectionStartRect.origin.y, widthOfLabels, selectionStartRect.size.height)];
    self.expirationLabel.font = self.font;
    self.expirationLabel.textColor = [UIColor grayColor];
    self.expirationLabel.text = self.expirationPlaceholder;
    self.expirationLabel.backgroundColor = [UIColor yellowColor];
    //[self.expirationLabel sizeToFit];
    self.expirationLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.expirationLabel];
    
    self.cvcLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.expirationLabel.frame.origin.x + self.expirationLabel.frame.size.width) + self.paddingBetweenPlaceholders, self.expirationLabel.frame.origin.y, widthOfLabels, self.expirationLabel.frame.size.height)];
    self.cvcLabel.font = self.font;
    self.cvcLabel.text = self.cvcPlaceholder;
    self.cvcLabel.backgroundColor = [UIColor yellowColor];
    self.cvcLabel.textColor = [UIColor grayColor];
    //[self.cvcLabel sizeToFit];
    self.cvcLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.cvcLabel];
    
    if (self.includeZipCode) {
        self.zipLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.cvcLabel.frame.origin.x + self.cvcLabel.frame.size.width) + self.paddingBetweenPlaceholders, self.expirationLabel.frame.origin.y, widthOfLabels, self.expirationLabel.frame.size.height)];
        self.zipLabel.font = self.font;
        self.zipLabel.text = self.zipPlaceholder;
        self.zipLabel.backgroundColor = [UIColor yellowColor];
        self.zipLabel.textColor = [UIColor grayColor];
        self.zipLabel.adjustsFontSizeToFitWidth = YES;
        //[self.zipLabel sizeToFit];
        [self addSubview:self.zipLabel];
    }
    
}

#pragma mark - Set card types
- (void)setCvcCard {
    [UIView transitionWithView:self.leftView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        ((UIImageView *)self.leftView).image = [UIImage imageNamed:@"cvc_icon"];
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
    
}

- (void)setUnkownCard {
    if (self.cardType == OKCardTypeUnknown)
        return;
    self.cardType = OKCardTypeUnknown;
    [UIView transitionWithView:self.leftView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.leftViewImageView.image = [UIImage imageNamed:@"credit_card_icon"];
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
}
- (void)setMasterCard {
    if (self.cardType == OKCArdTypeMastercard)
        return;
    //self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mastercard_icon" ]];
    self.cardType = OKCArdTypeMastercard;
    
    [UIView transitionWithView:self.leftView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        //((UIImageView *)self.leftView).image = [UIImage imageNamed:@"mastercard_icon"];
        self.leftViewImageView.image = [UIImage imageNamed:@"mastercard_icon"];
        
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
    
}

- (void)setVisaCard {
    if (self.cardType == OKCardTypeVisa)
        return;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.cardType = OKCardTypeVisa;
    //self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visa_icon" ]];
    
    
    //    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
    //        self.leftViewImageView.image = [UIImage imageNamed:@"visa_icon"];
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
    [UIView transitionWithView:self.leftView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft  animations:^{
        self.leftViewImageView.image = [UIImage imageNamed:@"visa_icon"];
    } completion:^(BOOL finished) {
        //self.leftView = visaView;
    }];
}

- (void)textFieldChanged {
    NSLog(@"value changed");
    
    if (self.paymentStep == OKPaymentStepCCNumber) {
        if (self.ccNumberInvalid) {
            [self resetFieldState];
        }
        self.trimmedNumber = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (self.trimmedNumber.length == 16) {
            NSLog(@"validate card. Number: %@", self.trimmedNumber);
            [self validateCardNumber];
        }
    } else if (self.paymentStep == OKPaymentStepExpiration) {
        self.expirationLabel.hidden = YES;
        if (self.text.length == 5) {
            NSArray *expirationParts = [self.text componentsSeparatedByString:@"/"];
            self.cardMonth = expirationParts[0];
            self.cardYear = expirationParts[1];
            [self validateExpiration];
        }
    } else if (self.paymentStep == OKPaymentStepSecurityCode) {
        self.cvcLabel.hidden = YES;
        if (self.text.length == 3) {
            self.cardCvc = self.text;
            [self validateCvc];
        }
    }
    
}

#pragma mark - UITextFieldDelegate methods

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
        } else if (textField.text.length > 19) {
            NSLog(@"Length is greater than 19");
            return NO;
        }
        
    } else if (self.paymentStep == OKPaymentStepExpiration) {
        if ([string isEqualToString:@"/"]) {
            if (textField.text.length == 1) {
                self.text = [@"0" stringByAppendingFormat:@"%@/", self.text];
                return NO;
            } else {
                
            }
        } else if (textField.text.length == 1 && ![string isEqualToString:@""]) {
            self.text = [self.text stringByAppendingFormat:@"%@/", string];
            return NO;
        }
        
        
    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}


#pragma mark - Field styles
- (void)invalidFieldState {
    self.background = [[UIImage imageNamed:@"field_cell_error"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    self.ccNumberInvalid = YES;
    [self shakeAnimation:self];
}

- (void)resetFieldState {
    self.background = [[UIImage imageNamed:@"field_cell"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    self.ccNumberInvalid = NO;
}
@end
