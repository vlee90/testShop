//
//  ThankYouViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "ThankYouViewController.h"
#import "Cart.h"
#import "TAGDataLayer.h"
#import "TAGManager.h"

@interface ThankYouViewController ()

@property (strong, nonatomic) NSString *screenName;
@property (weak, nonatomic) IBOutlet UILabel *thankyouLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

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
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"screen-open",
                      @"screen-name" : @"Thank You View"}];
    
    //  Reset ecommerce values.
    [dataLayer push:@{@"event" : @"reset-ecommerce",
                      @"ecommerce" : [NSNull null]}];
    
    //  Push dictionary to dataLayer that will create checkout step hit.
    [dataLayer push:@{@"event" : @"thank-you-seen",
                      @"ecommerce" : @{
                              @"checkout" : @{
                                      @"actionField" : @{
                                              @"step" : @3
                                              }
                                      }
                              }
                      }
     ];
    
    //  Reset ecommerce values.
    [dataLayer push:@{@"event" : @"reset-ecommerce",
                      @"ecommerce" : [NSNull null]}];
}

- (IBAction)returnButtonPressed:(id)sender {
    //  Push dictionary that will create an event hit.
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"button-pressed",
                      @"event-category-name" : @"Button",
                      @"event-action-name" : @"Pressed",
                      @"event-label-name" : @"Resume Shopping"}];
    
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
