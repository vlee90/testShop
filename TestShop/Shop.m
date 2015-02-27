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

+(Shop *)singleton {
    
    static dispatch_once_t pred;
    static Shop *shared;
    
    dispatch_once(&pred, ^{
        shared = [[Shop alloc] initWithAllItems];
    });
    return shared;
}

-(instancetype)initWithAllItems {
    if (self = [super init]) {
        Item *item0 = [[Item alloc] initWithName:@"Apple"
                                            cost:3
                                           image:[UIImage imageNamed:@"Apple"]
                                     description:@"Nice shiney red apple!"];
        Item *item1 = [[Item alloc] initWithName:@"Avacado"
                                            cost:5
                                           image:[UIImage imageNamed:@"Avacado"]
                                     description:@"Filling food!"];
        Item *item2 = [[Item alloc] initWithName:@"Egg"
                                            cost:2
                                           image:[UIImage imageNamed:@"Egg"]
                                     description:@"Great way to start the morning!"];
        Item *item3 = [[Item alloc] initWithName:@"Orange"
                                            cost:3
                                           image:[UIImage imageNamed:@"Orange"]
                                     description:@"Great source of vitamins!"];
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
