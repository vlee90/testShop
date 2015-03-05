//
//  DetailViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "DetailViewController.h"
#import "TAGDataLayer.h"
#import "TAGManager.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSString *screenName;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = [NSString stringWithFormat:@"Detail View - %@", self.item.name];
    self.imageView.image = self.item.image;
    self.nameLabel.text = self.item.name;
    self.costLabel.text = [NSString stringWithFormat:@"$%ld.00", (long)self.item.cost];
    self.descriptionLabel.text = self.item.itemDescription;
    self.numberInCartLabel.text = [NSString stringWithFormat:@"%ld in Cart", (long)self.item.count];
    NSLog(@"ViewDIDLOAD");
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"openScreen",
                      @"screenName" : self.screenName}];
    
    
    [dataLayer push:@{@"event" : @"EEscreenSeen",
                      @"ecommerce" : @{
                              @"detail" : @{
                                  @"actionField" : @{
                                          @"list" : @"Front Page Shop"
                                          },
                                  @"products" : @[
                                          @{@"name" : self.item.name,
                                            @"id" : self.item.sku,
                                            @"price" : [NSString stringWithFormat:@"%ld", (long)self.item.cost],
                                            @"brand" : self.item.brand,
                                            @"category" : self.item.category,
                                            @"variant" : self.item.varient
                                            }
                                          ]
                                  }
                              }
                      }
     ];
    [dataLayer push:@{@"event" : @"EEscreenSeen",
                      @"ecommerce" : [NSNull null]}];
}

-(IBAction)buyButtonPressed:(id)sender {
    Cart *cart = [Cart singleton];
    self.item.count++;
    if ([cart.cartArray containsObject:self.item]) {
        NSInteger index = [cart.cartArray indexOfObject:self.item];
        [cart.cartArray replaceObjectAtIndex:index withObject:self.item];
    }
    else {
        [cart.cartArray addObject:self.item];
    }
    self.numberInCartLabel.text = [NSString stringWithFormat:@"%ld in Cart", (long)self.item.count];
    
    
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"addToCart",
                      @"ecommerce" : @{
                              @"actionField" : @{
                                      @"list" : @"Front Page Shop"
                                      },
                              @"currencyCode" : @"USD",
                              @"add" : @{
                                      @"products" : @[
                                              @{@"name" : self.item.name,
                                                @"id" : self.item.sku,
                                                @"price" : [NSString stringWithFormat:@"%ld", (long)self.item.cost],
                                                @"brand" : self.item.brand,
                                                @"category" : self.item.category,
                                                @"variant" : self.item.varient,
                                                @"quantity" : @1
                                                }
                                              ]
                                      }
                              }
                      }
     ];
    [dataLayer push:@{@"event" : @"EEscreenSeen",
                      @"ecommerce" : [NSNull null]}];}

@end
