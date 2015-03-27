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

@import AnalyticsEngine;

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
@property (weak, nonatomic) IBOutlet UISwitch *freeShippingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *freeShippingLabel;

@property (strong, nonatomic) NSString *shippingFee;
@property (strong, nonatomic) NSString *shippingOption;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  Additional non-GTM code.
    [self viewDidLoadHelper];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  Get all products in cart. They are formatted in a way that Enhanced Ecommerce will understand.
//    NSArray *productArray = [[NSArray alloc] initWithArray:[[Cart singleton] productFieldObjectCart]];
    
    //  Sent hit for App View.
    [AnalyticsEngine pushScreenWithName:@"Checkout View" fromViewController:self];
    
    //  Push dictionary that will create a checkout step hit.
    
//    NSMutableArray *AEProductFieldArray = [NSMutableArray new];
//    for (Item* item in productArray) {
//        AEProductFieldObject *product = [item productFieldObjectWithPosition:nil coupon:nil];
//        [AEProductFieldArray addObject:product];
//    }
    //  Push a dictionary to that will create a checkout step.
    [AnalyticsEngine pushEnhancedEcommerceCheckoutStep:@2 withOption:self.shippingOption withProducts:[[Cart singleton] productFieldObjectCart]];
    
    
    AEPromoFieldObject *promo = [[AEPromoFieldObject alloc] initWithID:@"FREE_SHIPPING_PROMO" name:@"Free Shipping Promo" creative:@"bottom" position:@"slot1"];
    //  Push dictionary that will create a promoView hit.
    [AnalyticsEngine pushEnhancedEcommercePromoImpression:@[promo]];
}

//  Will change shipping state based on Switch Value.
- (IBAction)shippingSwitchValuedChanged:(id)sender {
    if ([self.freeShippingSwitch isOn]) {
        //  Free Shipping On
        self.freeShippingLabel.alpha = 1.0;
        self.shippingFee = @"0";
        self.shippingOption = @"Free Shipping";
        
        //  Push dictionary to create a promoClick hit.
        AEPromoFieldObject *promo = [[AEPromoFieldObject alloc] initWithID:@"FREE_SHIPPING_PROMO" name:@"Free Shipping Promo" creative:@"bottom" position:@"slot1"];
        [AnalyticsEngine pushEnhancedEcommercePromoSelections:@[promo]];
    }
    else {
        //  Free Shipping Off
        self.freeShippingLabel.alpha = 0.2;
        self.shippingFee = @"5";
        self.shippingOption = @"Standard Shipping";
    }
}

-(void)confirmButtonPressed:(id)sender {
    //  Checks to see if all TextFields are filled out.
    if ([self checkIfAllFieldsAreFilled]) {
        //  Create AlertController that will pop up when to double check if user wants to checkout.
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm"
                                                                                 message:@"Are you sure?"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              //    Random transactionID generater
                                                              int r = arc4random();
                                                              NSString *transactionId = [NSString stringWithFormat:@"%f-%d", NSDate.date.timeIntervalSince1970, r];
                                                              [Cart singleton].transactionID = transactionId;
                                                              AEEnhancedEcommerceTransaction *transaction = [[AEEnhancedEcommerceTransaction alloc] initWithID:transactionId affiliation:@"Analytics Pros App Fruit Store" revenue:[NSString stringWithFormat:@"%ld", (long)[Cart singleton].total] tax:[NSString stringWithFormat:@"%f", (long)[Cart singleton].total * 0.065] shipping:self.shippingFee coupon:@"COUPON CODE" products:[[Cart singleton] productFieldObjectCart]];
                                                              
                                                              
                                                              
                                                              [AnalyticsEngine pushEnhancedEcommercePurchaseWithTransaction:transaction];
                                                              
                                                              //    Segue to ThankYouViewController.
                                                              ThankYouViewController *thankYouVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouVC"];
                                                              [self.navigationController pushViewController:thankYouVC animated:true];
                                                          }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           //   Push dictionary that will create Event hit
                                                           NSDictionary *eventDictionary =  @{@"event" : @"buttonPressed",
                                                                                              @"eventCategoryName" : @"Button",
                                                                                              @"eventActionName" : @"Pressed",
                                                                                              @"eventLabelName" : @"Cancel Checkout"};
                                                       }];
        [alertController addAction:yesAction];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:true completion:nil];
    }
    //  Options if user did not fill out all textFields.
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Please Fill Out All Fields"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           //   Push dictionary that will create an Event tag.
                                                           NSDictionary *eventDictionary = @{@"event" : @"buttonPressed",
                                                                                             @"eventCategoryName" : @"Button",
                                                                                             @"eventActionName" : @"Pressed",
                                                                                             @"eventLabelName" : @"Fields not Filled"};
                                                       }];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:true completion:nil];
    }
    
}

//  Checks if all TextFields are filled.
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

//  Helper function that runs non GTM related code in viewDidLoad.
-(void)viewDidLoadHelper {
    self.shippingFee = @"5";
    self.shippingOption = @"Standard Shipping";
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(confirmButtonPressed:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
}

//  Helper function that runs non GTM related code in viewDidAppear.
-(void)viewDidAppearHelper {
    
}

@end
