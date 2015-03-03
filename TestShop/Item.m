//
//  Item.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "Item.h"

@implementation Item

-(instancetype)initWithName:(NSString *)name cost:(NSInteger)cost image:(UIImage *)image description:(NSString *)description sku:(NSString *)sku brand:(NSString *)brand category:(NSString *)category varient:(NSString *)varient {
    if (self = [super init]) {
        self.name = name;
        self.cost = cost;
        self.image = image;
        self.itemDescription  = description;
        self.count = 0;
        self.sku = sku;
        self.brand = brand;
        self.category = category;
        self.varient = varient;
    }
    return self;
}

@end
