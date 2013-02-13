//
//  CreditCardValidation.m
//  LuhnyBin
//  Created for the SquareUp
//  Created by Sonny Fazio on 11/22/11.
//  Copyright (c) 2011 SonsterMedia. All rights reserved.
//
#define kMagicSubtractionNumber 48 // The ASCII value of 0

#import "CreditCardValidation.h"
@implementation CreditCardValidation

/* validateCard
 Counting from the check digit, which is the rightmost, and moving left, double the value of every second digit.
 Sum the digits of the products (e.g., 10 = 1 + 0 = 1, 14 = 1 + 4 = 5) together with the undoubled digits from the original number.
 If the total modulo 10 is equal to 0 (if the total ends in zero) then the number is valid according to the Luhn formula; else it is not valid.
 http://en.wikipedia.org/wiki/Luhn_algorithm
 */
- (BOOL)validateCard:(NSString *)cardNumber
{
	
	int Luhn = 0;
    
    // I'm running through my string backwards
	for (int i=0;i<[cardNumber length];i++)
    {
        NSUInteger count = [cardNumber length]-1; // Prevents Bounds Error and makes characterAtIndex easier to read
        int doubled = [[NSNumber numberWithUnsignedChar:[cardNumber characterAtIndex:count-i]] intValue] - kMagicSubtractionNumber;
        if (i % 2)
        {doubled = doubled*2;}
        
        NSString *double_digit = [NSString stringWithFormat:@"%d",doubled];
        
        if ([[NSString stringWithFormat:@"%d",doubled] length] > 1)
        {   Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:0]] intValue]-kMagicSubtractionNumber;
            Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:1]] intValue]-kMagicSubtractionNumber;}
        else
        {Luhn = Luhn + doubled;}
    }
    
	if (Luhn%10 == 0) // If Luhn/10's Remainder is Equal to Zero, the number is valid
        return true;
    else
		return false;
    
}

+ (BOOL)validateCard:(NSString *)cardNumber
{
	
	int Luhn = 0;
    
    // I'm running through my string backwards
	for (int i=0;i<[cardNumber length];i++)
    {
        NSUInteger count = [cardNumber length]-1; // Prevents Bounds Error and makes characterAtIndex easier to read
        int doubled = [[NSNumber numberWithUnsignedChar:[cardNumber characterAtIndex:count-i]] intValue] - kMagicSubtractionNumber;
        if (i % 2)
        {doubled = doubled*2;}
        
        NSString *double_digit = [NSString stringWithFormat:@"%d",doubled];
        
        if ([[NSString stringWithFormat:@"%d",doubled] length] > 1)
        {   Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:0]] intValue]-kMagicSubtractionNumber;
            Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:1]] intValue]-kMagicSubtractionNumber;}
        else
        {Luhn = Luhn + doubled;}
    }
    
	if (Luhn%10 == 0) // If Luhn/10's Remainder is Equal to Zero, the number is valid
        return true;
    else
		return false;
    
}


@end