//
//  ViewController.h
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/1/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKSingeInputPaymentField.h"
#import "OKSingleInputPayment.h"

@interface ViewController : UIViewController <OKSingleInputPaymentDelegate>

@property (weak, nonatomic) IBOutlet OKSingeInputPaymentField *singlePaymentField;
@property (weak, nonatomic) IBOutlet OKSingleInputPayment *singlePayment;

@end
