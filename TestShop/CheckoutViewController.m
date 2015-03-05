//
//  CheckoutViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/28/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "CheckoutViewController.h"
#import "ThankYouViewController.h"
#import "Cart.h"
#import "Item.h"
#import "TAGDataLayer.h"
#import "TAGManager.h"

@interface CheckoutViewController ()

@property (strong, nonatomic) NSString *screenName;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressField;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;
@property (weak, nonatomic) IBOutlet UITextField *creditCartNumberField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Checkout View";
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm"
                                                                    style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                     action:@selector(confirmButtonPressed:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[Cart singleton] prepareCartArrayForEcommerce];
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"openScreen",
                      @"screenName" : self.screenName,
                      @"ecommerce" : @{
                              @"checkout" : @{
                                      @"actionField" : @{
                                              @"step" : @2
                                              },
                                      @"products" : [Cart singleton].cartArrayForEcommerce
                                      }
                              }
                      }
     ];
}

-(void)confirmButtonPressed:(id)sender {
    if ([self checkIfAllFieldsAreFilled]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm"
                                                                                 message:@"Are you sure?"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              int r = arc4random();
                                                              NSString *transactionId = [NSString stringWithFormat:@"%f-%d", NSDate.date.timeIntervalSince1970, r];
                                                              TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
                                                              [dataLayer push:@{@"event" : @"transactionComplete",
                                                                                @"eventLabelName" : @"Checkout Complete",
                                                                                @"eventValueName" : [NSString stringWithFormat:@"%ld", (long)[Cart singleton].total],
                                                                                @"ecommerce" : @{
                                                                                        @"purchase" : @{
                                                                                                @"actionField" : @{
                                                                                                        @"id" : transactionId,
                                                                                                        @"affiliation" : @"Analytics Pros App Fruit Store",
                                                                                                        @"revenue" : [NSString stringWithFormat:@"%ld", (long)[Cart singleton].total],
                                                                                                        @"tax" : [NSString stringWithFormat:@"%f", (long)[Cart singleton].total * 0.065],
                                                                                                        @"shipping" : @"5",
                                                                                                        },
                                                                                                @"products" : [Cart singleton].cartArrayForEcommerce
                                                                                                }
                                                                                        }
                                                                                }
                                                               ];
                                                              ThankYouViewController *thankYouVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouVC"];
                                                              [self.navigationController pushViewController:thankYouVC animated:true];
                                                          }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
                                                           [dataLayer push:@{@"event" : @"buttonPressed",
                                                                             @"eventCategoryName" : @"Button",
                                                                             @"eventActionName" : @"Pressed",
                                                                             @"eventLabelName" : @"Cancel Checkout"}];
                                                       }];
        [alertController addAction:yesAction];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:true completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Please Fill Out All Fields"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
                                                           [dataLayer push:@{@"event" : @"buttonPressed",
                                                                             @"eventCategoryName" : @"Button",
                                                                             @"eventActionName" : @"Pressed",
                                                                             @"eventLabelName" : @"Fields not Filled"}];
                                                       }];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:true completion:nil];
    }

}

-(BOOL)checkIfAllFieldsAreFilled {
    if ([self.streetAddressField.text isEqualToString: @""] ||
        [self.creditCartNumberField.text  isEqualToString: @""] ||
        [self.cityField.text isEqualToString:@""] ||
        [self.stateField.text isEqualToString:@""] ||
        [self.zipCodeField.text isEqualToString:@""] ||
        [self.cvvField.text isEqualToString:@""]) {
        return false;
    }
    else {return true;}
}

@end
