//
//  OKSingleInputPayment.m
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/6/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

/*
 A good reference on detecting credit cards from http://stackoverflow.com/a/72801
 
Using a regular expression like the ones below: Credit for original expressions

Visa: ^4[0-9]{12}(?:[0-9]{3})?$ Visa card numbers start with a 4. New cards have 16 digits. Old cards have 13.
MasterCard: ^5[1-5][0-9]{14}$ MasterCard numbers start with the numbers 51 through 55. All have 16 digits.
American Express: ^3[47][0-9]{13}$ American Express card numbers start with 34 or 37 and have 15 digits.
Diners Club: ^3(?:0[0-5]|[68][0-9])[0-9]{11}$ Diners Club card numbers begin with 300 through 305, 36 or 38. All have 14 digits. There are Diners Club cards that begin with 5 and have 16 digits. These are a joint venture between Diners Club and MasterCard, and should be processed like a MasterCard.
Discover: ^6(?:011|5[0-9]{2})[0-9]{12}$ Discover card numbers begin with 6011 or 65. All have 16 digits.
JCB: ^(?:2131|1800|35\d{3})\d{11}$ JCB cards beginning with 2131 or 1800 have 15 digits. JCB cards beginning with 35 have 16 digits.

The following expression can be used to validate against all card types, regardless of brand: 
 ^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$
*/

#import "OKSingleInputPayment.h"
#import "NSString+CCValidation.h"

@interface OKSingleInputPayment() {
    CGFloat maximumFontForCardNumber;
    CGFloat maximumFontForFields;
    CGFloat maximumWidthSpace;
    CGFloat widthPerField;
    NSInteger numberOfFields;
    NSInteger padding;
    BOOL _fieldInvalid;
}

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *cardNumberTextField;
@property (strong, nonatomic) UITextField *expirationTextField;
@property (strong, nonatomic) UITextField *cvcTextField;
@property (strong, nonatomic) UITextField *zipTextField;
@property (strong, nonatomic) UILabel *lastFourLabel;



@property (strong, nonatomic) NSString *trimmedNumber;
@property (strong, nonatomic) NSString *lastFour;
@property NSInteger minYear;
@property NSInteger maxYear;

@property (strong, nonatomic) UIImageView *leftCardView;
@property (strong, nonatomic) UITextField *activeTextField;


@property OKCardType displayingCardType;
@property OKPaymentStep paymentStep;


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
        numberOfFields = 4;
        [self commonInit:self.frame];
    }
    return self;
}


- (void)commonInit:(CGRect)frame {
    self.defaultFont = [UIFont fontWithName:@"Helvetica" size:28];
    self.defaultFontColor = [UIColor blackColor];
    
    self.paymentStep = OKPaymentStepCCNumber;
    self.displayingCardType = OKCardTypeUnknown;
    _cardType = OKCardTypeUnknown;
    _includeZipCode = YES;
    _nameFieldType = OKNameFieldNone;
    _isValid = NO;
    _fieldInvalid = NO;
    numberOfFields = 4;
    padding = 5;
    
    self.monthPlaceholder = @"mm";
    self.yearPlaceholder = @"yy";
    self.monthYearSeparator = @"/";
    self.cvcPlaceholder = @"cvc";
    self.zipPlaceholder = @"zipcode";
    self.numberPlaceholder = @"4111 1111 1111 1111";
    self.namePlaceholder = @"Cardholder's Name";
    self.useInputAccessory = YES;
    
    [self updatePlaceholders];
    
    
    NSDateComponents *yearComponent = [[NSDateComponents alloc] init];
    yearComponent.year = 20;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDate *future = [theCalendar dateByAddingComponents:yearComponent toDate:[NSDate date] options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy"];
    self.minYear = [[formatter stringFromDate:date] integerValue];
    self.maxYear = [[formatter stringFromDate:future] integerValue];
       
    self.containerBGImage = [[UIImage imageNamed:@"OKSingleInputPayment.bundle/field_cell"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    self.containerErrorImage = [[UIImage imageNamed:@"OKSingleInputPayment.bundle/field_cell_error"] resizableImageWithCapInsets:(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = self.containerBGImage;
    self.containerView = imageView;
    self.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
    
    
    self.leftCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OKSingleInputPayment.bundle/credit_card_icon"]];
    self.leftCardView.backgroundColor = [UIColor blueColor];
    [self.leftCardView setFrame:CGRectMake(10, (self.frame.size.height / 2) - (self.leftCardView.frame.size.height/2), self.leftCardView.frame.size.width, self.leftCardView.frame.size.height)];
    
    
    self.cardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + padding, (self.frame.size.height / 2) - ((self.frame.size.height * 0.9) /2), self.frame.size.width - ((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + padding) - 5, self.frame.size.height * 0.9)];
    [self.numberPlaceholder sizeWithFont:self.defaultFont minFontSize:self.cardNumberTextField.minimumFontSize actualFontSize:&maximumFontForCardNumber forWidth:self.cardNumberTextField.frame.size.width lineBreakMode:NSLineBreakByClipping];

    //self.cardNumberTextField.backgroundColor = [UIColor yellowColor];
    self.cardNumberTextField.font = [self fontWithNewSize:self.defaultFont newSize:maximumFontForCardNumber];
    self.cardNumberTextField.delegate = self;
    self.cardNumberTextField.adjustsFontSizeToFitWidth = YES;
    self.cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.cardNumberTextField.backgroundColor = [UIColor clearColor];
    self.cardNumberTextField.inputAccessoryView = self.accessoryToolBar;
    [self.cardNumberTextField addTarget:self action:@selector(cardNumberTextFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    self.cardNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.nameTextField = [[UITextField alloc] initWithFrame:self.cardNumberTextField.frame];
    self.nameTextField.font = [self fontWithNewSize:self.defaultFont newSize:maximumFontForCardNumber];
    self.nameTextField.delegate = self;
    self.nameTextField.adjustsFontSizeToFitWidth = YES;
    self.nameTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.backgroundColor = [UIColor clearColor];
    self.nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTextField.inputAccessoryView = self.accessoryToolBar;
    self.nameTextField.hidden = YES;
    [self.nameTextField addTarget:self action:@selector(nameTextFieldValueChanged) forControlEvents:UIControlEventEditingChanged];

    [self addSubview:self.nameTextField];
    [self addSubview:self.cardNumberTextField];
    [self addSubview:self.leftCardView];
    
    maximumWidthSpace = self.frame.size.width - ((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + (padding * numberOfFields));
    widthPerField = maximumWidthSpace / numberOfFields;
    
    [@"12345" sizeWithFont:self.defaultFont minFontSize:self.cardNumberTextField.minimumFontSize actualFontSize:&maximumFontForFields forWidth:widthPerField lineBreakMode:NSLineBreakByClipping];
    self.lastFourLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    //self.lastFourLabel.backgroundColor = [UIColor greenColor];
    self.lastFourLabel.backgroundColor = [UIColor clearColor];
    self.lastFourLabel.hidden = YES;
    self.lastFourLabel.adjustsFontSizeToFitWidth = YES;
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previous:)];
    [self.lastFourLabel addGestureRecognizer:tg];
    self.lastFourLabel.userInteractionEnabled = YES;
    [self addSubview:self.lastFourLabel];
    
    self.expirationTextField = [[UITextField alloc] initWithFrame:CGRectMake((self.lastFourLabel.frame.origin.x + self.lastFourLabel.frame.size.width) + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    //self.expirationTextField.backgroundColor = [UIColor greenColor];
    self.expirationTextField.backgroundColor = [UIColor clearColor];
    self.expirationTextField.adjustsFontSizeToFitWidth = YES;
    self.expirationTextField.delegate = self;
    self.expirationTextField.hidden = YES;
    self.expirationTextField.inputAccessoryView = self.accessoryToolBar;
    self.expirationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.expirationTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.expirationTextField addTarget:self action:@selector(expirationTextFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    
    [self addSubview:self.expirationTextField];
    
    
    self.cvcTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.expirationTextField.frame.origin.x + self.expirationTextField.frame.size.width + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    //self.cvcTextField.backgroundColor = [UIColor greenColor];
    self.cvcTextField.backgroundColor = [UIColor clearColor];
    self.cvcTextField.adjustsFontSizeToFitWidth = YES;
    self.cvcTextField.delegate = self;
    self.cvcTextField.hidden = YES;
    self.cvcTextField.inputAccessoryView = self.accessoryToolBar;
    self.cvcTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.cvcTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.cvcTextField addTarget:self action:@selector(cvcTextFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    
    [self addSubview:self.cvcTextField];
    
    self.zipTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.cvcTextField.frame.origin.x + self.cvcTextField.frame.size.width + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    //self.zipTextField.backgroundColor = [UIColor greenColor];
    self.zipTextField.backgroundColor = [UIColor clearColor];
    self.zipTextField.adjustsFontSizeToFitWidth = YES;
    self.zipTextField.delegate = self;
    self.zipTextField.hidden = YES;
    self.zipTextField.inputAccessoryView = self.accessoryToolBar;
    self.zipTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.zipTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.zipTextField addTarget:self action:@selector(zipTextFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.zipTextField];
    
    [self updateDefaultFonts];

}

- (void)adjustFields {
        
    maximumWidthSpace = self.frame.size.width - ((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + (padding * numberOfFields));
    widthPerField = maximumWidthSpace / numberOfFields;
    [@"12345" sizeWithFont:self.defaultFont minFontSize:self.cardNumberTextField.minimumFontSize actualFontSize:&maximumFontForFields forWidth:widthPerField lineBreakMode:NSLineBreakByClipping];
    
    [self.lastFourLabel setFrame:CGRectMake((self.leftCardView.frame.origin.x + self.leftCardView.frame.size.width) + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    [self.expirationTextField setFrame:CGRectMake((self.lastFourLabel.frame.origin.x + self.lastFourLabel.frame.size.width) + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    [self.cvcTextField setFrame:CGRectMake(self.expirationTextField.frame.origin.x + self.expirationTextField.frame.size.width + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
    if (self.includeZipCode)
        [self.zipTextField setFrame:CGRectMake(self.cvcTextField.frame.origin.x + self.cvcTextField.frame.size.width + padding, self.cardNumberTextField.frame.origin.y, widthPerField, self.cardNumberTextField.frame.size.height)];
}


#pragma mark - Setters for updating placholders when client overrides defaults
- (void)setYearPlaceholder:(NSString *)yearPlaceholder {
    
    _yearPlaceholder = yearPlaceholder;
    [self updatePlaceholders];
}

- (void)setMonthPlaceholder:(NSString *)monthPlaceholder {
    _monthPlaceholder = monthPlaceholder;
    [self updatePlaceholders];
}

- (void)setMonthYearSeparator:(NSString *)monthYearSeparator {
    _monthYearSeparator = monthYearSeparator;
    [self updatePlaceholders];
}

- (void)setZipPlaceholder:(NSString *)zipPlaceholder {
    _zipPlaceholder = zipPlaceholder;
    [self updatePlaceholders];
}

- (void)setNumberPlaceholder:(NSString *)numberPlaceholder {
    _numberPlaceholder = numberPlaceholder;
    [self updatePlaceholders];
}

- (void)setNamePlaceholder:(NSString *)namePlaceholder {
    _namePlaceholder = namePlaceholder;
    [self updatePlaceholders];
}

- (void)setCvcPlaceholder:(NSString *)cvcPlaceholder {
    _cvcPlaceholder = cvcPlaceholder;
    [self updatePlaceholders];
}

- (void)setIncludeZipCode:(BOOL)includeZipCode {
    if (includeZipCode) {
        numberOfFields = 4;
    } else {
        numberOfFields = 3;
    }
    _includeZipCode = includeZipCode;
}

- (void)setNameFieldType:(OKNameFieldType)nameFieldType {
    _nameFieldType = nameFieldType;
    if (nameFieldType == OKNameFieldFirst) {
        [self setupName];
    } else {
        [self setupCardNumber];
    }
}

- (void)setUseInputAccessory:(BOOL)useInputAccessory {
    _useInputAccessory = useInputAccessory;
    if (useInputAccessory) {
        [self setupAccessoryToolbar];
    } else {
        [self removeAccessoryToolbar];
    }
}


- (void)setDefaultFont:(UIFont *)defaultFont {
    _defaultFont = defaultFont;
    [self updateDefaultFonts];
}

- (void)setDefaultFontColor:(UIColor *)defaultFontColor {
    _defaultFontColor = defaultFontColor;
    [self updateFontColors];
}

- (NSString *)getFormattedExpiration {
    return [NSString stringWithFormat:@"%@%@%@", self.cardMonth, self.monthYearSeparator, self.cardYear];
}

// If the user defined font is within the maximum for a particular field, take
- (void)updateDefaultFonts {
    
    CGFloat newCardFontSize =  (maximumFontForCardNumber > self.defaultFont.pointSize) ? self.defaultFont.pointSize : maximumFontForCardNumber;
    CGFloat newFieldFontSize = (maximumFontForFields > self.defaultFont.pointSize) ? self.defaultFont.pointSize : maximumFontForFields;
    
    self.nameTextField.font = self.cardNumberTextField.font = [self fontWithNewSize:self.defaultFont newSize:newCardFontSize];
    self.lastFourLabel.font = self.expirationTextField.font = self.cvcTextField.font = self.zipTextField.font = [self fontWithNewSize:self.defaultFont newSize:newFieldFontSize];
}

- (UIFont *)fontWithNewSize:(UIFont *)font newSize:(CGFloat)pointSize {
    NSString *fontName = font.fontName;
    UIFont *newFont = [UIFont fontWithName:fontName size:pointSize];
    return newFont;
}

- (void)updateFontColors {
    self.nameTextField.textColor = self.cardNumberTextField.textColor = self.lastFourLabel.textColor = self.expirationTextField.textColor = self.cvcTextField.textColor = self.zipTextField.textColor = self.defaultFontColor;
}

- (void)updatePlaceholders {
    self.expirationTextField.placeholder = [NSString stringWithFormat:@"%@%@%@", self.monthPlaceholder, self.monthYearSeparator, self.yearPlaceholder];
    self.cvcTextField.placeholder = self.cvcPlaceholder;
    self.zipTextField.placeholder = self.zipPlaceholder;
    self.cardNumberTextField.placeholder = self.numberPlaceholder;
    self.nameTextField.placeholder = self.namePlaceholder;
}

#pragma mark - 
- (void)setupBackSide {
    self.cardNumberTextField.hidden = self.nameTextField.hidden = YES;
    self.lastFourLabel.hidden = self.expirationTextField.hidden = self.cvcTextField.hidden = NO;
    if (self.includeZipCode)
        self.zipTextField.hidden = NO;
    
    self.lastFourLabel.text = self.lastFour;
}

- (void)setupCardNumber {
    self.lastFourLabel.hidden = self.expirationTextField.hidden = self.cvcTextField.hidden = self.zipTextField.hidden = self.nameTextField.hidden = YES;
    self.cardNumberTextField.hidden = NO;
}

- (void)setupName {
    self.lastFourLabel.hidden = self.expirationTextField.hidden = self.cvcTextField.hidden = self.zipTextField.hidden = self.cardNumberTextField.hidden = YES;
    self.nameTextField.hidden = NO;
}

#pragma mark - InputAccessory actions
- (IBAction)next:(id)sender {
    OKPaymentStep invalidField;
    BOOL isValid = [self isValid:&invalidField];
    
    if (self.activeTextField == self.nameTextField) {
        if (self.nameFieldType == OKNameFieldLast && isValid) {
            if (self.nameFieldType == OKNameFieldLast) {
                if ([self.delegate respondsToSelector:@selector(formDidBecomeValid)]){
                    [self.delegate formDidBecomeValid];
                }
            } else {
                [self setupCardNumber];
                [self.cardNumberTextField becomeFirstResponder];
            }
        } else {
            [self hintForInvalidStep:invalidField];
        }
    } else if (self.activeTextField == self.cardNumberTextField) {
        if (![self isValidCardNumber]){
            [self hintForInvalidStep:OKPaymentStepCCNumber];
            return;
        }
        [self setupBackSide];
        [self.expirationTextField becomeFirstResponder];
    } else if (self.activeTextField == self.expirationTextField) {
        [self.cvcTextField becomeFirstResponder];
    } else if (self.activeTextField == self.cvcTextField) {
        if (self.includeZipCode) {
            [self.zipTextField becomeFirstResponder];
        } else if (self.nameFieldType == OKNameFieldLast) {
            [self setupName];
            [self.nameTextField becomeFirstResponder];
        } else {
            if ([self.delegate respondsToSelector:@selector(formDidBecomeValid)] && isValid){
                [self.delegate formDidBecomeValid];
            }
        }
    } else if (self.activeTextField == self.zipTextField && isValid) {
        if (self.nameFieldType == OKNameFieldLast) {
            [self setupName];
            [self.nameTextField becomeFirstResponder];
        } else {
            if ([self.delegate respondsToSelector:@selector(formDidBecomeValid)]){
                [self.delegate formDidBecomeValid];
            }
        }
        
    }
}

- (IBAction)previous:(id)sender {
    if (self.activeTextField == self.cardNumberTextField && self.nameFieldType == OKNameFieldFirst) {
        [self setupName];
        [self.nameTextField becomeFirstResponder];
    } else if (self.activeTextField == self.expirationTextField) {
        [self setupCardNumber];
        [self.cardNumberTextField becomeFirstResponder];
    } else if (self.activeTextField == self.cvcTextField) {
        [self.expirationTextField becomeFirstResponder];
    } else if (self.activeTextField == self.zipTextField) {
        [self.cvcTextField becomeFirstResponder];
    } else if (self.activeTextField == self.nameTextField) {
        if (self.nameFieldType == OKNameFieldLast) {
            [self setupBackSide];
            if (self.includeZipCode) {
                [self.zipTextField becomeFirstResponder];
            } else {
                [self.cvcTextField becomeFirstResponder];
            }
        }
    }
}

- (IBAction)done:(id)sender {
    OKPaymentStep invalidField;
    BOOL isValid = [self isValid:&invalidField];
    if (isValid) {
        if ([self.delegate respondsToSelector:@selector(formDidBecomeValid)]){
            [self.delegate formDidBecomeValid];
        }
    } else {
        [self hintForInvalidStep:invalidField];
    }
}

- (void)setupAccessoryToolbar {
    _accessoryToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previous:)];
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.accessoryToolBar.items = @[self.previousButton, self.nextButton, flexibleSpace, self.doneButton];
    self.cardNumberTextField.inputAccessoryView = self.expirationTextField.inputAccessoryView = self.cvcTextField.inputAccessoryView = self.zipTextField.inputAccessoryView = self.accessoryToolBar;

}

- (void)removeAccessoryToolbar {
    self.nameTextField.inputAccessoryView = self.cardNumberTextField.inputAccessoryView = self.expirationTextField.inputAccessoryView = self.cvcTextField.inputAccessoryView = self.zipTextField.inputAccessoryView = nil;
}



#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
        self.paymentStep = OKPaymentStepName;
        [self animateLeftView:self.cardType];
    } if (textField == self.cardNumberTextField) {
        self.paymentStep = OKPaymentStepCCNumber;
        [self animateLeftView:self.cardType];
    } else if (textField == self.cvcTextField) {
        [self animateLeftView:OKCardTypeCvc];
        self.paymentStep = OKPaymentStepSecurityCode;
    } else if (textField == self.expirationTextField) {
        self.paymentStep = OKPaymentStepExpiration;
        [self animateLeftView:self.cardType];
    } else if (textField == self.zipTextField) {
        self.paymentStep = OKPaymentStepZip;
        [self animateLeftView:self.cardType];
    }
    
    if ([self.delegate respondsToSelector:@selector(didChangePaymentStep:)]) {
        [self.delegate didChangePaymentStep:self.paymentStep];
    }
    
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:self];
    return NO;
}

// A much smarter card number formatter repurposed from stripe/PaymentKit  
- (NSString *)formattedCardNumber:(NSString *)number type:(OKCardType)type {
    NSRegularExpression *regex;
    
    if (type == OKCardTypeAmericanExpress) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d{1,4})(\\d{1,6})?(\\d{1,5})?" options:0 error:NULL];
    } else {
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d{1,4})" options:0 error:NULL];
    }
    
    NSArray *matches = [regex matchesInString:number options:0 range:NSMakeRange(0, number.length)];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:matches.count];
    
    for (NSTextCheckingResult *match in matches) {
        for (int i=1; i < [match numberOfRanges]; i++) {
            NSRange range = [match rangeAtIndex:i];
            
            if (range.length > 0) {
                NSString* matchText = [number substringWithRange:range];
                [result addObject:matchText];
            }
        }
    }
    
    return [result componentsJoinedByString:@" "];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //NSLog(@"Text: %@, replacementString: %@, Length of text %d, location: %d, length: %d", textField.text, string, textField.text.length, range.location, range.length);
    
    // This is lazy and should be refactored. Don't allow the user to move the cursor around the text field as text formatting can't handle it very gracefully
    if(range.location < textField.text.length && !((textField.text.length - range.location) == 1  && [string isEqualToString:@""])) return NO;
    
    if ([string isEqualToString:@" "] && textField != self.nameTextField)
        return NO;
    
    // User is hitting the delete button on the last character of the field
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
        textField.text = nil;
        [self previous:self];
        return NO;
    }
    
    if (self.activeTextField == self.cardNumberTextField) {
        //if (textField.text.length == 0) {
            NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            resultString = [resultString stringByReplacingOccurrencesOfString:@"\\D"
                                              withString:@""
                                                 options:NSRegularExpressionSearch
                                                   range:NSMakeRange(0, resultString.length)];
            
                        
            if (resultString.length < 2) {
                _cardType = OKCardTypeUnknown;
            }
            else if (resultString.length > 16)
                return NO;
            else {
                NSString *firstTwo = [resultString substringWithRange:NSMakeRange(0, 2)];
                
                int range = [firstTwo integerValue];
                
                if (range >= 40 && range <= 49) {
                    [self animateLeftView:OKCardTypeVisa];
                    _cardType = OKCardTypeVisa;
                } else if (range >= 50 && range <= 59) {
                    [self animateLeftView:OKCArdTypeMastercard];
                    _cardType = OKCArdTypeMastercard;
                } else if (range == 34 || range == 37) {
                    [self animateLeftView:OKCardTypeAmericanExpress];
                    _cardType = OKCardTypeAmericanExpress;
                } else if (range == 60 || range == 62 || range == 64 || range == 65) {
                    [self animateLeftView:OKCardTypeDiscover];
                    _cardType = OKCardTypeDiscover;
                } else if (range == 35) {
                    [self animateLeftView:OKCardTypeJCB];
                    _cardType = OKCardTypeJCB;
                } else if (range == 30 || range == 36 || range == 38 || range == 39) {
                    [self animateLeftView:OKCardTypeDinersClub];
                    _cardType = OKCardTypeDinersClub;
                } else {
                    [self animateLeftView:OKCardTypeUnknown];
                    _cardType = OKCardTypeUnknown;
                }

            //}
            
            self.cardNumberTextField.text = [self formattedCardNumber:resultString type:_cardType];
            [self cardNumberTextFieldValueChanged];
            return NO;
        }
        
    } else if (self.activeTextField == self.expirationTextField) {
        if (textField.text.length == 5 && ![string isEqualToString:@""]) {
            return NO;
        }
        
        if ([string integerValue] > 1 && textField.text.length == 0 && ![string isEqualToString:@"0"]) {
            textField.text = [@"0" stringByAppendingFormat:@"%@/", string];
            return NO;
        }
        
        // If the first number is a one, the only valid
        if (textField.text.length == 1 && [string integerValue] > 2) {
            return NO;
        }
        
        if ([string isEqualToString:@"/"]) {
            if (textField.text.length == 1) {
                textField.text = [@"0" stringByAppendingFormat:@"%@/", textField.text];
                return NO;
            } else {
                
            }
        } else if (textField.text.length == 1 && ![string isEqualToString:@""]) {
            textField.text = [textField.text stringByAppendingFormat:@"%@/", string];
            return NO;
        }
    } else if (self.activeTextField == self.cvcTextField) {
        if (textField.text.length == 4 && ![string isEqualToString:@""]) {
            return NO;
        }

    } else if (self.activeTextField == self.zipTextField) {
        if (textField.text.length == 10 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
}


- (void)expirationTextFieldValueChanged {
    if (_fieldInvalid)
        [self resetFieldState];
    
    if (self.expirationTextField.text.length == 5) {
        NSArray *expirationParts = [self.expirationTextField.text componentsSeparatedByString:self.monthYearSeparator];
        _cardMonth = expirationParts[0];
        _cardYear = expirationParts[1];
        if ([self isValidExpiration]) {
            [self next:self];
        }
    }

}

- (void)cvcTextFieldValueChanged {
    if (_fieldInvalid)
        [self resetFieldState];
    
    _cardCvc = self.cvcTextField.text;
    if (self.cvcTextField.text.length > 2) {
        [self next:self];
    }
}

- (void)zipTextFieldValueChanged {
    if (_fieldInvalid)
        [self resetFieldState];
    
    if (self.zipTextField.text.length > 4) {
        _cardZip = self.zipTextField.text;
        if ([self isValidZip]) {
            [self next:self];
        }
    }
}

- (void)cardNumberTextFieldValueChanged {
    if (_fieldInvalid)
        [self resetFieldState];
    
    self.trimmedNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"trimmed NUmber %@", self.trimmedNumber);
    
    if (self.cardType == OKCArdTypeMastercard) {
        if (self.trimmedNumber.length == 16 && [self isValidCardNumber]) {
            [self next:self];
        }
    } else if (self.cardType == OKCardTypeVisa) {
        if ((self.trimmedNumber.length > 12 && self.trimmedNumber.length < 20) && [self isValidCardNumber]) {
            [self next:self];
        }
    } else if (self.cardType == OKCardTypeAmericanExpress) {
        if (self.trimmedNumber.length == 15 && [self isValidCardNumber])
            [self next:self];
    } else if (self.cardType == OKCardTypeDiscover) {
        if (self.trimmedNumber.length == 16 && [self isValidCardNumber])
            [self next:self];
    } else if (self.cardNumberTextField.text.length > 2 && [self isValidCardNumber]) {
        [self next:self];
    }
    
}

- (void)nameTextFieldValueChanged {
    if (_fieldInvalid)
        [self resetFieldState];
    
    if ([self.delegate respondsToSelector:@selector(nameFieldDidChange:)]) {
        [self.delegate nameFieldDidChange:self.nameTextField.text];
    }
    
    if (self.nameTextField.text.length > 0) {
        _cardName = self.nameTextField.text;
    }
}

#pragma mark - Validation methods
- (void)hintForInvalidStep:(OKPaymentStep)invalidField {
    
    switch (invalidField) {
        case OKPaymentStepCCNumber:
            [self setupCardNumber];
            [self.cardNumberTextField becomeFirstResponder];
            [self invalidFieldState];
            break;
        case OKPaymentStepExpiration:
            [self setupBackSide];
            [self.expirationTextField becomeFirstResponder];
            [self invalidFieldState];
            break;
        case OKPaymentStepSecurityCode:
            [self setupBackSide];
            [self.cvcTextField becomeFirstResponder];
            [self invalidFieldState];
            break;
        case OKPaymentStepZip:
            [self setupBackSide];
            [self.zipTextField becomeFirstResponder];
            [self invalidFieldState];
            break;
        case OKPaymentStepName:
            [self setupName];
            [self.nameTextField becomeFirstResponder];
            [self invalidFieldState];
            break;
        default:
            break;
    }
    
}

- (BOOL)isValid:(OKPaymentStep *)invalidStep {
           
    if (![self isValidCardNumber]) {
        *invalidStep = OKPaymentStepCCNumber;
        return NO;
    }
    
    if (![self isValidExpiration]) {
        *invalidStep = OKPaymentStepCCNumber;
        return NO;
    }
    
    if (![self isValidCvc]) {
        *invalidStep = OKPaymentStepSecurityCode;
        return NO;
    }
    
    if (![self isValidZip]) {
        *invalidStep = OKPaymentStepZip;
        return NO;
    }
    
    if (![self isValidName]) {
        *invalidStep = OKPaymentStepName;
        return NO;
    }

    
    return YES;

}

- (BOOL)isValidCardNumber {
    if (self.cardType == OKCardTypeUnknown) {
        [self invalidFieldState];
        return NO;
    } else if ( self.cardType == OKCardTypeVisa) {
        if (self.trimmedNumber.length == 16 && ![self.trimmedNumber luhnCheck]) {
            [self invalidFieldState];
            return NO;
        } else if (![self.trimmedNumber luhnCheck]) {
            return NO;
        }
    } else if (self.cardType == OKCArdTypeMastercard) {
        if (![self.trimmedNumber luhnCheck]) {
            [self invalidFieldState];
            return NO;
        }
    } else if (self.cardType == OKCardTypeAmericanExpress) {
        if (self.trimmedNumber.length == 15 && ![self.trimmedNumber luhnCheck]) {
            [self invalidFieldState];
            return NO;
        }
    } else if (self.cardType == OKCardTypeDiscover) {
        if (self.trimmedNumber.length == 16 && ![self.trimmedNumber luhnCheck]) {
            [self invalidFieldState];
            return NO;
        }
    }
    
    _cardNumber = self.trimmedNumber;
    self.lastFour = [self.cardNumber substringFromIndex: [self.cardNumber length] - 4];
    return YES;
}

- (BOOL)isValidExpiration {

    if (self.expirationTextField.text.length == 5 && [self.cardMonth integerValue] < 13 && [self.cardMonth integerValue] > 0 && [self.cardYear integerValue] >= self.minYear && [self.cardYear integerValue] <= self.maxYear) {
        return YES;
    }
    [self invalidFieldState];
    return NO;
}

- (BOOL)isValidZip {
    if (self.zipTextField.text.length > 5 || !self.includeZipCode)
        return YES;
    
    return NO;
}

- (BOOL)isValidCvc {
    if (self.cvcTextField.text.length)
        return YES;
    return NO;
}

- (BOOL)isValidName {
    if ((self.nameTextField.text.length > 0) || (_nameFieldType == OKNameFieldNone)) {
        return YES;
    }
    return NO;
}
    


#pragma mark - Animation methods

- (void)animateLeftView:(OKCardType)cardType {
    if (self.displayingCardType != cardType) {
        self.displayingCardType = cardType;
        [UIView transitionWithView:self.leftCardView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft  animations:^{
            self.leftCardView.image = [self imageForCardType:cardType];
        } completion:^(BOOL finished) {
            //self.leftView = visaView;
        }];
    }
}

- (UIImage *)imageForCardType:(OKCardType)cardType {
    UIImage *image;
    switch (cardType) {
        case OKCardTypeVisa:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/visa_icon"];
            break;
        case OKCArdTypeMastercard:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/mastercard_icon"];
            break;
        case OKCardTypeAmericanExpress:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/amex_icon"];
            break;
        case OKCardTypeDiscover:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/discover_icon"];
            break;
        case OKCardTypeDinersClub:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/diner_icon"];
            break;
        case OKCardTypeJCB:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/jcb_icon"];
            break;
        case OKCardTypeUnknown:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/credit_card_icon"];
            break;
        case OKCardTypeCvc:
            image = [UIImage imageNamed:@"OKSingleInputPayment.bundle/cvc_icon"];
            break;
        default:
            break;
    }
    return image;
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
    self.containerView.image = self.containerErrorImage;
    _fieldInvalid = YES;
    [self shakeAnimation:self.activeTextField.textInputView];
    self.activeTextField.textColor = [UIColor redColor];
}

- (void)resetFieldState {
    self.containerView.image = self.containerBGImage;
    self.activeTextField.textColor = self.defaultFontColor;
    _fieldInvalid = NO;
    
}

@end
