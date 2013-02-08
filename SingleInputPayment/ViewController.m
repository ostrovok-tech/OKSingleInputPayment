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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
