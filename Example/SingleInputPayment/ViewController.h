//
//  ViewController.h
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/1/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKSingleInputPayment.h"

@interface ViewController : UIViewController <OKSingleInputPaymentDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentStep;

@property (weak, nonatomic) IBOutlet OKSingleInputPayment *singlePayment;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *cvcLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;

@end
