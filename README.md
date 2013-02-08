single-input-payment
====================

A implementation of Square's single input payment for iOS


## Usage
```objective-c
OKSingleInputPayment *inputField = [[OKSingleInputPayment alloc] initWithFrame:CGRectMake(20, 60, 280, 50)];
inputField.textFieldFont = [UIFont fontWithName:@"Helvetica" size:28];

```

## Configurable Properties 
```objective-c
@property (strong, nonatomic) UIFont *defaultFont;
@property (strong, nonatomic) UIColor *defaultFontColor;
@property (strong, nonatomic) UIFont *placeholderFont;
@property BOOL includeZipCode;
@property (strong, nonatomic) NSString *cvcPlaceholder;
@property (strong, nonatomic) NSString *zipPlaceholder;
@property (strong, nonatomic) NSString *numberPlaceholder;
@property (strong, nonatomic) NSString *monthYearSeparator;
@property (strong, nonatomic) NSString *monthPlaceholder;
@property (strong, nonatomic) NSString *yearPlaceholder;
```

## Optional delegate methods 
```objective-c
- (void)paymentDetailsValid;
- (void)didChangePaymentStep:(OKPaymentStep)paymentStep;
```
