//
//  ThankYouViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "ThankYouViewController.h"
#import "Cart.h"

@import AnalyticsEngine;
/*
 /Users/vincentlee/Desktop
 $(PROJECT_DIR)/TestShop
 $(inherited)
 */

@interface ThankYouViewController ()

@property (strong, nonatomic) NSString *screenName;
@property (weak, nonatomic) IBOutlet UILabel *thankyouLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  Sets screen name for App View
    self.screenName = @"Thank You View";
    
    //  Additional non-GTM Code
    [self viewDidLoadHelper];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  Push dictionary that will  create App View hit.
    [AnalyticsEngine pushScreenWithName:self.screenName fromViewController:self];
    
    //  Reset ecommerce values.
    NSDictionary *resetDictionary = @{@"event" : @"EEscreenSeen",
                                      @"ecommerce" : [NSNull null]};
    
    //  Push dictionary to dataLayer that will create checkout step hit.
    NSDictionary *checkoutStepDictionary =  @{@"event" : @"thankYouSeen",
                                              @"ecommerce" : @{
                                                      @"checkout" : @{
                                                              @"actionField" : @{
                                                                      @"step" : @3
                                                                      }
                                                              }
                                                      }
                                              };
    
    //  Reset ecommerce values.
}

- (IBAction)returnButtonPressed:(id)sender {
    //  Push dictionary that will create an event hit.
    NSDictionary *eventDictionary = @{@"event" : @"buttonPressed",
                                      @"eventCategoryName" : @"Button",
                                      @"eventActionName" : @"Pressed",
                                      @"eventLabelName" : @"Resume Shopping"};
    
    //  Return to starting ViewController.
    [self.navigationController popToRootViewControllerAnimated:true];
}

//  Helper function that runs non GTM related code in viewDidLoad.
-(void)viewDidLoadHelper {
    self.thankyouLabel.adjustsFontSizeToFitWidth = true;
    self.returnButton.titleLabel.adjustsFontSizeToFitWidth = true;
    
    //  Removes all items from cart and sets the total transaction cost to 0
    [[Cart singleton].cartArray removeAllObjects];
    [Cart singleton].total = 0;
}

//  Helper function that runs non GTM related code in viewDidAppear.
-(void)viewDidAppearHelper {
    
}

@end
