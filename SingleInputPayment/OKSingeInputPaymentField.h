//
//  OKSingeInputPaymentField.h
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/1/13.
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

@interface OKSingeInputPaymentField : UITextField <UITextFieldDelegate>
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cardCvc;
@property (strong, nonatomic) NSString *cardMonth;
@property (strong, nonatomic) NSString *cardYear;

@property (strong, nonatomic) UIToolbar *accessoryToolBar;

@property OKCardType cardType;
@property OKPaymentStep paymentStep;

@property (strong, nonatomic) NSString *expirationPlaceholder;
@property (strong, nonatomic) NSString *cvcPlaceholder;
@property (strong, nonatomic) NSString *zipPlaceholder;
@property (strong, nonatomic) UIFont *placeholderFont;

@property float paddingBetweenPlaceholders;

@property BOOL includeZipCode;

@end


@protocol OKSingleInputPaymentFieldDelegate <NSObject>


@end