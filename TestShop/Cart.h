//
//  Cart.h
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject

@property (strong, nonatomic) NSMutableArray *cartArray;

-(instancetype)init;

@end
