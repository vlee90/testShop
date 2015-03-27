//
//  ThankYouViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "ThankYouViewController.h"
#import "Cart.h"
#import "Item.h"

@import AnalyticsEngine;

@interface ThankYouViewController ()

@property (strong, nonatomic) NSString *screenName;
@property (weak, nonatomic) IBOutlet UILabel *thankyouLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *fullRefundButton;
@property (weak, nonatomic) IBOutlet UIButton *partialRefundButton;

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  Additional non-GTM Code
    [self viewDidLoadHelper];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  Push dictionary that will  create App View hit.
    [AnalyticsEngine pushScreenWithName:@"Thank You View" fromViewController:self];
    
    //  Push a dictionary to that will create a checkout step.
    [AnalyticsEngine pushEnhancedEcommerceCheckoutStep:@3 withOption:nil withProducts:[[Cart singleton] productFieldObjectCart]];
}

- (IBAction)returnButtonPressed:(id)sender {
    //  Push dictionary that will create an event hit.
    NSDictionary *eventDictionary = @{@"event" : @"buttonPressed",
                                      @"eventCategoryName" : @"Button",
                                      @"eventActionName" : @"Pressed",
                                      @"eventLabelName" : @"Resume Shopping"};
    //  Removes all items from cart and sets the total transaction cost to 0
    [[Cart singleton].cartArray removeAllObjects];
    [Cart singleton].total = 0;
    //  Return to starting ViewController.
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)fullRefundButtonPressed:(id)sender {
    
    
    NSString *transactionid = [Cart singleton].transactionID;
    [AnalyticsEngine pushEnhancedEcommerceRefundWithTransactionID:transactionid forProducts:nil];
}

- (IBAction)partialRefundButtonPressed:(id)sender {
    if ([[Cart singleton] productFieldObjectCart] != nil) {
        AEProductFieldObject *firstProduct = [[Cart singleton] productFieldObjectCart][0];
        [AnalyticsEngine pushEnhancedEcommerceRefundWithTransactionID:[Cart singleton].transactionID forProducts:@[firstProduct]];
    }
    else {
        NSLog(@"Cart is empty");
    }

}

- (void)pushEnhancedEcommerceRefundWithTransactionID:(NSString *)ID forProducts:(NSArray *)productFieldObjects {
    NSDictionary *formattedDictionary = [NSDictionary new];
    if (productFieldObjects == nil) {
        formattedDictionary = @{@"event" : @"ae-refund",
                                @"ecommerce" : @{
                                        @"refund" : @{
                                                @"actionField" : @{
                                                        @"id" : ID}}}};
        AEEvent *event = [[AEEvent alloc] initWithDictionary:formattedDictionary];
        [AnalyticsEngine pushEvent:event];
    }
    else {
        NSMutableArray *productArray = [NSMutableArray new];
        for (AEProductFieldObject *product in productFieldObjects) {
            NSDictionary *productDiciontary = @{@"id" : product.ID,
                                                @"quantity" : product.quantity};
            [productArray addObject:productDiciontary];
        }
        formattedDictionary = @{@"event" : @"ae-refund",
                                @"ecommerce" : @{
                                        @"refund" : @{
                                                @"actionField" : @{
                                                        @"id" : ID},
                                                @"products" : productArray}}};
    }
#ifdef DEBUG
    NSLog(@"Pushing Enhanced Ecommerce Refund To DataLayer: %@", formattedDictionary);
#endif
}



//  Helper function that runs non GTM related code in viewDidLoad.
-(void)viewDidLoadHelper {
    self.thankyouLabel.adjustsFontSizeToFitWidth = true;
    self.returnButton.titleLabel.adjustsFontSizeToFitWidth = true;
    

}

//  Helper function that runs non GTM related code in viewDidAppear.
-(void)viewDidAppearHelper {
    
}

@end
