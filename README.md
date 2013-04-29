OKSingleInputPayment
====================

A customizable implementation of [Square's](http://squareup.com) single input payment for iOS. There are similar versions of this field built for the web, for an example see Zachary’s implementation and write up [here](http://www.lukew.com/ff/entry.asp?1667). As I wrote this [@stripe](https://github.com/stripe) created [PaymentKit](https://github.com/stripe/PaymentKit), so be sure to check it out as it might be more polished. 

This field was designed so it could be easily localized for different regions. Zipcode/Name fields are optional and all placeholder text can be localized. There is an input accessory view you can optionally turn on which gives users a back/next/right toolbar for navigating the input. This accessory view will be automatically turned on when including the name field as there is no good way to detect when the form should be advanced.

![Screen 1](https://s3.amazonaws.com/rromanchuk-public/singleInput/single_input1.png "Optional cardholder's name")
![Screen 2](https://s3.amazonaws.com/rromanchuk-public/singleInput/single_input2.png "Optional cardholder's name")
![Screen 3](https://s3.amazonaws.com/rromanchuk-public/singleInput/single_input3.png "Optional cardholder's name")
![Screen 4](https://s3.amazonaws.com/rromanchuk-public/singleInput/single_input4.png "Optional cardholder's name")
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

// UIToolbar buttons for availible for customization
@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

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
@property (strong, readonly) NSString *cardName;
@property (strong, readonly) NSString *cardNumber;
@property (strong, readonly) NSString *cardCvc;
@property (strong, readonly) NSString *cardMonth;
@property (strong, readonly) NSString *cardYear;
@property (strong, readonly) NSString *cardZip;
@property (readonly) OKCardType cardType;

// Formatted version of the expiration eg "12/18"
@property (strong, readonly, getter = getFormattedExpiration) NSString *formattedExpiration;
// The UIToolbar used for the input accessory view
@property (strong, nonatomic, readonly) UIToolbar *accessoryToolBar;

```

## Optional OKSingleInputPaymentDelegate delegate methods 
```objective-c
- (void)formDidBecomeValid;
- (void)didChangePaymentStep:(OKPaymentStep)paymentStep;
```

## Todo
* DRY up code
* Use smarter formatters 
