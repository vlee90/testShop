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

-(instancetype)initWithName:(NSString *)name cost:(NSInteger)cost image:(UIImage *)image description:(NSString *)description;

@end
