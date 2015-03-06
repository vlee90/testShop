//
//  Shop.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "Shop.h"
#import "Item.h"

@implementation Shop

//  Singleton pattern
+(Shop *)singleton {
    
    static dispatch_once_t pred;
    static Shop *shared;
    
    dispatch_once(&pred, ^{
        shared = [[Shop alloc] initWithAllItems];
    });
    return shared;
}


//  Sets all the items in the shop. May need better process if the amount grows.
-(instancetype)initWithAllItems {
    if (self = [super init]) {
        Item *item0 = [[Item alloc] initWithName:@"Apple"
                                            cost:3
                                           image:[UIImage imageNamed:@"Apple"]
                                     description:@"Nice shiney red apple!"
                                             sku:@"1"
                                           brand:@"Analytics Pros"
                                        category:@"Fruit"
                                         varient:@"Red"];
        Item *item1 = [[Item alloc] initWithName:@"Avacado"
                                            cost:5
                                           image:[UIImage imageNamed:@"Avacado"]
                                     description:@"Filling food!"
                                             sku:@"2"
                                           brand:@"Analytics Pros"
                                        category:@"Fruit"
                                         varient:@"Large"];
        Item *item2 = [[Item alloc] initWithName:@"Egg"
                                            cost:2
                                           image:[UIImage imageNamed:@"Egg"]
                                     description:@"Great way to start the morning!"
                                             sku:@"3"
                                           brand:@"Newegg"
                                        category:@"Produce"
                                         varient:@"White"];
        Item *item3 = [[Item alloc] initWithName:@"Orange"
                                            cost:3
                                           image:[UIImage imageNamed:@"Orange"]
                                     description:@"Great source of vitamins!"
                                             sku:@"4"
                                           brand:@"Analytics Pros"
                                        category:@"Fruit"
                                         varient:@"Large"];
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:item0];
        [array addObject:item1];
        [array addObject:item2];
        [array addObject:item3];
        self.shopItems = [NSArray arrayWithArray:array];
    }
    return self;
}

@end
