//
//  NSString+CCValidation.m
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/15/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "NSString+CCValidation.h"

@implementation NSString (CCValidation)
- (NSMutableArray *) toCharArray {
    
	NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
	for (int i=0; i < [self length]; i++) {
		NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
		[characters addObject:ichar];
	}
    
	return characters;
}

- (BOOL)luhnCheck {
    
	NSMutableArray *stringAsChars = [self toCharArray];
    
	BOOL isOdd = YES;
	int oddSum = 0;
	int evenSum = 0;
    
	for (int i = [self length] - 1; i >= 0; i--) {
        
		int digit = [(NSString *)[stringAsChars objectAtIndex:i] intValue];
        
		if (isOdd)
			oddSum += digit;
		else
			evenSum += digit/5 + (2*digit) % 10;
        
		isOdd = !isOdd;
	}
    
	return ((oddSum + evenSum) % 10 == 0);
}

@end
