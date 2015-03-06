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

//  Singleton Pattern
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

//  Determiens the total cost of transaction for items in the cart.
-(void)calculateTotal {
    self.total = 0;
    for (NSInteger i = 0; i < self.cartArray.count; i++) {
        Item *item = [self.cartArray objectAtIndex:i];
        NSInteger subtotal = item.count * item.cost;
        self.total += subtotal;
    }
}

//  Returns an array of all items in the cart that is formatted for Enhanced Ecommerce use.
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

//  Returns the amount of items in the cart.
-(NSInteger)totalNumberOfItemsInCart {
    NSInteger totalNumberOfItems = 0;
    for (int i = 0; i < self.cartArray.count; i++) {
        Item *item = [self.cartArray objectAtIndex:i];
        totalNumberOfItems += item.count;
    }
    return totalNumberOfItems;
}

@end
