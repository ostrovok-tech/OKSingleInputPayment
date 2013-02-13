single-input-payment
====================

A customizable implementation of Square's single input payment for iOS. 


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
    self.singlePayment.namePlaceholder = @"Владелец карты";
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
/**
*  Optionally include the zipcode field. This is an optional field as not all locales support this field..
*  This expects a zip code > 4 characters long
*/
@property (nonatomic) BOOL includeZipCode;

/**
 * Optionally use an inputaccessory view with previous<->next and done buttons. This will always be used when enabling
 * the optional name field as the user needs a way to move forward 
 */ 
@property (nonatomic) BOOL useInputAccessory;

/**
 * Optionally include the cardholder's name field. Turning this field on requires the input accessory view since there is no
 * good way to advance the user's form postion based on input validation
 */
@property (nonatomic) BOOL includeName;

@property (strong, nonatomic) NSString *cvcPlaceholder;
@property (strong, nonatomic) NSString *zipPlaceholder;
@property (strong, nonatomic) NSString *numberPlaceholder;
@property (strong, nonatomic) NSString *monthYearSeparator;
@property (strong, nonatomic) NSString *monthPlaceholder;
@property (strong, nonatomic) NSString *yearPlaceholder;
@property (strong, nonatomic) NSString *namePlaceholder;

@property (strong, nonatomic) UIFont *placeholderFont;

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

## Optional OKSingleInputPaymentDelegate delegate methods 
```objective-c
- (void)formDidBecomeValid;
- (void)didChangePaymentStep:(OKPaymentStep)paymentStep;
```

## Todo
* Support all types of cards 
* Allow previous field movement by deletion 
* Figure out a better way to retreive cardholder's name 
