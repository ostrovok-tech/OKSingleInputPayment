//
//  CreditCardValidation.h
//  LuhnyBin
//
//  Created by Sonny Fazio on 11/22/11.
//  Copyright (c) 2011 SonsterMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCardValidation : NSObject
- (BOOL)validateCard:(NSString *)cardNumber;
+ (BOOL)validateCard:(NSString *)cardNumber;

@end