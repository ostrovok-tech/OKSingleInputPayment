single-input-payment
====================

A implementation of Square's single input payment for iOS


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
