//
//  ViewController.m
//  SingleInputPayment
//
//  Created by Ryan Romanchuk on 2/1/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.singlePayment.monthPlaceholder = @"мм";
    self.singlePayment.yearPlaceholder = @"гг";
    self.singlePayment.namePlaceholder = @"Владелец карты";
    self.singlePayment.delegate = self;
    
    self.currentStep.text = @"";
    self.singlePayment.includeZipCode = NO;
    self.singlePayment.includeName = YES;
    self.singlePayment.defaultFont = [UIFont fontWithName:@"Copperplate" size:28];
    self.singlePayment.previousButton.title = NSLocalizedString(@"назад", @"Move to the previous input");
    self.singlePayment.nextButton.title = NSLocalizedString(@"вперед", @"Move to the next input");
    self.singlePayment.doneButton.title = NSLocalizedString(@"Готово", @"Form is finished button");
    //OKSingleInputPayment *inputField = [[OKSingleInputPayment alloc] initWithFrame:CGRectMake(20, 120, 280, 50)];
    //[self.view addSubview:inputField];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark OKSingleInputPaymentDelegate methods

- (void)didChangePaymentStep:(OKPaymentStep)paymentStep {
    switch (paymentStep) {
        case OKPaymentStepName:
            self.currentStep.text = @"Cardholder's name";
            break;
        case OKPaymentStepCCNumber:
            self.currentStep.text = @"CC Number";
            break;
        case OKPaymentStepExpiration:
            self.currentStep.text = @"Expiration Info";
            break;
        case OKPaymentStepSecurityCode:
            self.currentStep.text = @"CVC code";
            break;
        case OKPaymentStepSecurityZip:
            self.currentStep.text = @"Zipcode";
            break;
        default:
            break;
    }
}

- (void)formDidBecomeValid {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Valid Form" message:@"Form is valid!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
    self.nameLabel.text = self.singlePayment.cardName;
    self.cardNumber.text = self.singlePayment.cardNumber;
    self.expLabel.text = self.singlePayment.formattedExpiration;
    self.cvcLabel.text = self.singlePayment.cardCvc;
    self.zipcodeLabel.text = self.singlePayment.cardZip;
}

@end
