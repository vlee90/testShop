//
//  Item.h
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item : NSObject

@property (strong, nonatomic) NSString *name;
@property NSInteger cost;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *itemDescription;
@property NSInteger count;
@property (strong, nonatomic) NSString *sku;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *varient;

-(instancetype)initWithName:(NSString *)name cost:(NSInteger)cost image:(UIImage *)image description:(NSString *)description sku:(NSString *)sku brand:(NSString *)brand category:(NSString *)category varient:(NSString *)varient;

@end
