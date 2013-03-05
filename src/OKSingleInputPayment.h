/*
* Copyright (c) 2013 Ostrovok.ru
*
* Permission is hereby granted, free of charge, to any person 
* obtaining a copy of this software and associated documentation 
* files (the "Software"), to deal in the Software without restriction, 
* including without limitation the rights to use, copy, modify, merge, 
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so, 
* subject to the following conditions:

* The above copyright notice and this permission notice shall be included 
* in all copies or substantial portions of the Software.

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
* OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import <UIKit/UIKit.h>

typedef enum {
    OKPaymentStepName,
    OKPaymentStepCCNumber,
    OKPaymentStepExpiration,
    OKPaymentStepSecurityCode,
    OKPaymentStepSecurityZip
} OKPaymentStep;

typedef enum {
    OKCardTypeVisa,
    OKCArdTypeMastercard,
    OKCardTypeAmericanExpress,
    OKCardTypeDiscover,
    OKCardTypeJCB,
    OKCardTypeDinersClub,
    OKCardTypeUnknown,
    OKCardTypeCvc
} OKCardType;

@protocol OKSingleInputPaymentDelegate;

@interface OKSingleInputPayment : UIView <UITextFieldDelegate>

@property (strong, readonly) NSString *cardNumber;
@property (strong, readonly) NSString *cardCvc;
@property (strong, readonly) NSString *cardMonth;
@property (strong, readonly) NSString *cardYear;
@property (strong, readonly, getter = getFormattedExpiration) NSString *formattedExpiration;
@property (strong, readonly) NSString *cardZip;
@property (strong, readonly) NSString *cardName;
@property (strong, nonatomic, readonly) UIToolbar *accessoryToolBar;

@property (readonly) BOOL isValid;


@property (readonly) OKCardType cardType;

/**
*  Optionally include the zipcode field. This is an optional field as not all locales support this field..
*  This expects a zip code > 4 characters long
*/
@property (nonatomic) BOOL includeZipCode;

/**
 * Optionally use an inputaccessory view with previous<->next and done buttons. This will always be used when enabling
 * the optional name field as the user needs a way to move forward 
 */ 
@property (nonatomic) BOOL useInputAccessory;

/**
 * Optionally include the cardholder's name field. Turning this field on requires the input accessory view since there is no
 * good way to advance the user's form postion based on input validation
 */
@property (nonatomic) BOOL includeName;


@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) UIImageView *containerView;
@property (strong, nonatomic) UIImage *containerBGImage;
@property (strong, nonatomic) UIImage *containerErrorImage;

@property (strong, nonatomic) NSString *cvcPlaceholder;
@property (strong, nonatomic) NSString *zipPlaceholder;
@property (strong, nonatomic) NSString *numberPlaceholder;
@property (strong, nonatomic) NSString *monthYearSeparator;
@property (strong, nonatomic) NSString *monthPlaceholder;
@property (strong, nonatomic) NSString *yearPlaceholder;
@property (strong, nonatomic) NSString *namePlaceholder;

@property (strong, nonatomic) UIFont *placeholderFont;
@property (strong, nonatomic) UIFont *defaultFont;
@property (strong, nonatomic) UIColor *defaultFontColor;

@property (weak, nonatomic) id <OKSingleInputPaymentDelegate> delegate;


- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)done:(id)sender;
@end


@protocol OKSingleInputPaymentDelegate <NSObject>

@optional
- (void)formDidBecomeValid;
- (void)didChangePaymentStep:(OKPaymentStep)paymentStep;

@end