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
    [self.singlePaymentField setFrame:CGRectMake(self.singlePaymentField.frame.origin.x, self.singlePaymentField.frame.origin.y, self.singlePaymentField.frame.size.width, 80)];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
