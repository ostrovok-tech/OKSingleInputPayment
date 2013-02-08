single-input-payment
====================

An implementation of Square's single input payment for iOS


## Usage
### Using without storyboard
```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
    OKSingleInputPayment *inputField = [[OKSingleInputPayment alloc] initWithFrame:CGRectMake(20, 100, 280, 50)];
    self.singlePayment.monthPlaceholder = @"мм";
    self.singlePayment.yearPlaceholder = @"гг";
    [self.view addSubview:inputField];

}

```

### Using with storyboard
Drag a UIView into your scene and add the custom class OKSingleInputPayment, wire up your IBOutlets as normal.

```objective-c
#import <UIKit/UIKit.h>
#import "OKSingleInputPayment.h"

@interface ViewController : UIViewController <OKSingleInputPaymentDelegate>

@property (weak, nonatomic) IBOutlet OKSingleInputPayment *singlePayment;

@end

```


## Configurable Properties 

```objective-c
@property (strong, nonatomic) UIFont *defaultFont;
@property (strong, nonathomic) UIColor *defaultFontColor;
@property (strong, nonatomic) UIFont *placeholderFont;
@property (strong, nonatomic) NSString *cvcPlaceholder;
@property (strong, nonatomic) NSString *zipPlaceholder;
@property (strong, nonatomic) NSString *numberPlaceholder;
@property (strong, nonatomic) NSString *monthYearSeparator;
@property (strong, nonatomic) NSString *monthPlaceholder;
@property (strong, nonatomic) NSString *yearPlaceholder;

@property BOOL includeZipCode;
@property BOOL useInputAccessory
```

## Readable properties
```objective-c
@property (strong, readonly) NSString *cardNumber;
@property (strong, readonly) NSString *cardCvc;
@property (strong, readonly) NSString *cardMonth;
@property (strong, readonly) NSString *cardYear;
@property (strong, readonly) NSString *cardZip;
@property (readonly) OKCardType cardType;
```

## Optional <OKSingleInputPaymentDelegate> delegate methods 
```objective-c
- (void)paymentDetailsValid;
- (void)didChangePaymentStep:(OKPaymentStep)paymentStep;
```
