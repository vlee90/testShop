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
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"openScreen",
                      @"screenName" : self.screenName}];
}

-(void)confirmButtonPressed:(id)sender {
    if ([self checkIfAllFieldsAreFilled]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm"
                                                                                 message:@"Are you sure?"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              //    Push event tag transaction complete to dataLayer.
                                                              TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
                                                              [dataLayer push:@{@"event" : @"buttonPressed",
                                                                                @"eventCategoryName" : @"Button",
                                                                                @"eventActionName" : @"Pressed",
                                                                                @"eventLabelName" : @"Checkout Complete"}];
                                                              //    Push transaction tag to the datalayer.
                                                              [self purchase];
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

-(void)purchase {
    //  Array to store all purchased items that are organized to be pushed to the dataLayer.
    NSMutableArray *purchaseArray = [[NSMutableArray alloc] init];
    //  Pulling items from the cart into the array that will be pushed to the dataLayer.
    for (Item *item in [Cart singleton].cartArray) {
        NSString *costString = [NSString stringWithFormat:@"%ld", (long)item.cost];
        NSString *countString = [NSString stringWithFormat:@"%ld", (long)item.count];
        [purchaseArray addObject:@{@"name" : item.name,
                                   @"sku" : item.sku,
                                   @"category" : item.category,
                                   @"price" : costString,
                                   @"currency" : @"USD",
                                   @"quantity" : countString}];
    }
    
    //  Push transaction with transaction items to the dataLayer.
    int r = arc4random();
    NSString *transactionId = [NSString stringWithFormat:@"%f-%d", NSDate.date.timeIntervalSince1970, r];
    NSString *totalString = [NSString stringWithFormat:@"%ld", (long)[Cart singleton].total];
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"transactionComplete",
                      @"transactionId" : transactionId,
                      @"transactionTotal" : totalString,
                      @"transactionAffiliation" : @"Analytics Pros Fruit Stand",
                      @"transactionTax" : @"6.5",
                      @"transactionShipping" : @"5",
                      @"transactionCurrency" : @"USD",
                      @"transactionProducts" : purchaseArray}];
    
    //  Reset transaction fields to null after pushing transaction. This is recommended because the data layer is persistent.
    [dataLayer push:@{@"event" : [NSNull null],
                      @"transactionId" : [NSNull null],
                      @"transactionTotal" : [NSNull null],
                      @"transactionAffiliation" : [NSNull null],
                      @"transactionTax" : [NSNull null],
                      @"transactionShipping" : [NSNull null],
                      @"transactionCurrency" : [NSNull null],
                      @"transactionProducts" : [NSNull null]}];
    
    
    
}

@end
