//
//  DetailViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "DetailViewController.h"
@import AnalyticsEngine;

@interface DetailViewController ()

@property (nonatomic, strong) NSString *screenName;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidLoadHelper];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //  Push screen name and event to fire an App View Tag to the dataLayer.
    [AnalyticsEngine pushScreenWithName:[NSString stringWithFormat:@"Detail View - %@", self.item.name] fromViewController:self];
    
    //  Push a dictionary that will create a Enhanced Ecommerce detail hit.
    AEProductFieldObject *product = [self.item productFieldObjectWithPosition:nil coupon:nil];
    [AnalyticsEngine pushEnhancedEcommerceProductDetail:@[product] onList:@"Front Page Shop"];
}

-(IBAction)buyButtonPressed:(id)sender {
    Cart *cart = [Cart singleton];
    
    //  Increment viewControllers item.
    self.item.count++;
    
    //  Increment/add item in cart singleton.
    if ([cart.cartArray containsObject:self.item]) {
        //  Replace item in cart with incremented item.
        NSInteger index = [cart.cartArray indexOfObject:self.item];
        [cart.cartArray replaceObjectAtIndex:index withObject:self.item];
    }
    else {
        //Add item if item wasn't in cart.
        [cart.cartArray addObject:self.item];
    }
    
    //  Update the UI count.
    self.numberInCartLabel.text = [NSString stringWithFormat:@"%ld in Cart", (long)self.item.count];
    
    
    //  Push dictionary that will create an add hit when pushed to the dataLayer.
    AEProductFieldObject *product = [self.item productFieldObjectWithPosition:nil coupon:nil];
    [AnalyticsEngine pushEnhancedEcommerceAddProduct:@[product] onList:nil];
}

//  Helper function that runs non GTM related code in viewDidLoad.
-(void)viewDidLoadHelper {
    self.imageView.image = self.item.image;
    self.nameLabel.text = self.item.name;
    self.costLabel.text = [NSString stringWithFormat:@"$%ld.00", (long)self.item.cost];
    self.descriptionLabel.text = self.item.itemDescription;
    self.numberInCartLabel.text = [NSString stringWithFormat:@"%ld in Cart", (long)self.item.count];
}

//  Helper function that runs non GTM related code in viewDidAppear.
-(void)viewDidAppearHelper {
    
}
@end
