//
//  OKSingleInputPayment.h
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/6/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OKPaymentStepCCNumber,
    OKPaymentStepExpiration,
    OKPaymentStepSecurityCode,
    OKPaymentStepSecurityZip
} OKPaymentStep;

typedef enum {
    OKCardTypeVisa,
    OKCArdTypeMastercard,
    OKCardTypeUnknown,
    OKCardTypeCvc
} OKCardType;

@protocol OKSingleInputPaymentDelegate;

@interface OKSingleInputPayment : UIView <UITextFieldDelegate>
@property (strong, nonatomic) UIFont *defaultFont;
@property (strong, nonatomic) UIColor *defaultFontColor;
@property (strong, readonly) NSString *cardNumber;
@property (strong, readonly) NSString *cardCvc;
@property (strong, readonly) NSString *cardMonth;
@property (strong, readonly) NSString *cardYear;
@property (strong, readonly) NSString *cardZip;

@property (readonly) OKCardType cardType;

@property BOOL includeZipCode;
@property (strong, nonatomic) NSString *cvcPlaceholder;
@property (strong, nonatomic) NSString *zipPlaceholder;
@property (strong, nonatomic) NSString *numberPlaceholder;
@property (strong, nonatomic) NSString *monthYearSeparator;
@property (strong, nonatomic) NSString *monthPlaceholder;
@property (strong, nonatomic) NSString *yearPlaceholder;

@property (strong, nonatomic) UIFont *placeholderFont;

@property (weak, nonatomic) id <OKSingleInputPaymentDelegate> delegate;


@end


@protocol OKSingleInputPaymentDelegate <NSObject>

@optional
- (void)paymentDetailsValid;
- (void)didChangePaymentStep:(OKPaymentStep)paymentStep;

@end