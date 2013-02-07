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


@interface OKSingleInputPayment : UIView <UITextFieldDelegate>
@property (strong, nonatomic) UIFont *textFieldFont;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cardCvc;
@property (strong, nonatomic) NSString *cardMonth;
@property (strong, nonatomic) NSString *cardYear;
@property OKCardType cardType;

@property BOOL includeZipCode;
@property (strong, nonatomic) NSString *expirationPlaceholder;
@property (strong, nonatomic) NSString *cvcPlaceholder;
@property (strong, nonatomic) NSString *zipPlaceholder;
@property (strong, nonatomic) NSString *numberPlaceholder;

@property (strong, nonatomic) UIFont *placeholderFont;


@end


@protocol OKSingleInputPaymentDelegate <NSObject>


@end