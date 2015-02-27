//
//  Cart.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "Cart.h"

@implementation Cart

-(instancetype)init {
    if (self = [super init]) {
        self.cartArray = [NSMutableArray new];
    }
    return self;
}

@end
