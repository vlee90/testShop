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

-(AEProductFieldObject *)productFieldObjectWithPosition:(NSNumber *)position coupon:(NSString *)coupon {
    AEProductFieldObject *product = [[AEProductFieldObject alloc] initWithID:self.sku name:self.name brand:self.brand category:self.category variant:self.varient position:position coupon:coupon price:[NSString stringWithFormat:@"$%ld.00", (long)self.cost] quantity:[[NSNumber alloc] initWithInteger:self.count]];
    return product;
}

-(AEImpressionFieldObject *)impressionFieldObjectWithPosition:(NSNumber *)position onList:(NSString *)list {
    AEImpressionFieldObject *impression = [[AEImpressionFieldObject alloc] initWithID:self.sku name:self.name list:list brand:self.brand category:self.category variant:self.varient position:position price:[NSString stringWithFormat:@"$%ld.00", (long)self.cost]];
    return impression;
}

@end
