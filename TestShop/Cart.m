//
//  Cart.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "Cart.h"
#import "Shop.h"

@implementation Cart

+(Cart *)singleton {
    
    static dispatch_once_t pred;
    static Cart *shared;
    
    dispatch_once(&pred, ^{
        shared = [[Cart alloc] init];
    });
    return shared;
}

-(instancetype)init {
    if (self = [super init]) {
        Shop *shop = [Shop singleton];
        self.cartArray = [shop.shopItems mutableCopy];
    }
    return self;
}

@end
