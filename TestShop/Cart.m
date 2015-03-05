//
//  Cart.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "Cart.h"
#import "Shop.h"
#import "Item.h"

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
        self.cartArray = [NSMutableArray new];
    }
    return self;
}

-(void)calculateTotal {
    self.total = 0;
    for (NSInteger i = 0; i < self.cartArray.count; i++) {
        Item *item = [self.cartArray objectAtIndex:i];
        NSInteger subtotal = item.count * item.cost;
        self.total += subtotal;
    }
}

-(NSArray *)ecommerceCartArray {
    //  Pulling items from the cart into the array that will be pushed to the dataLayer.
    NSMutableArray * cartArrayForEcommerce = [NSMutableArray new];
    for (Item *item in [Cart singleton].cartArray) {
        NSString *costString = [NSString stringWithFormat:@"%ld", (long)item.cost];
        NSString *countString = [NSString stringWithFormat:@"%ld", (long)item.count];
        [cartArrayForEcommerce addObject:@{@"name" : item.name,
                                   @"sku" : item.sku,
                                   @"category" : item.category,
                                   @"price" : costString,
                                   @"currency" : @"USD",
                                   @"quantity" : countString,
                                   @"brand" : item.brand,
                                   @"category" : item.category,
                                   @"variant" : item.varient,
                                   @"quantity" : countString,
                                   @"coupon" : @""}];
    }
    return cartArrayForEcommerce;
}

-(NSInteger)totalNumberOfItemsInCart {
    NSInteger totalNumberOfItems = 0;
    for (int i = 0; i < self.cartArray.count; i++) {
        Item *item = [self.cartArray objectAtIndex:i];
        totalNumberOfItems += item.count;
    }
    return totalNumberOfItems;
}

@end
