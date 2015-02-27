//
//  Item.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "Item.h"

@implementation Item

-(instancetype)initWithName:(NSString *)name cost:(NSInteger)cost image:(UIImage *)image description:(NSString *)description {
    if (self = [super init]) {
        _name = name;
        _cost = cost;
        _image = image;
        _itemDescription  = description;
    }
    return self;
}

@end
