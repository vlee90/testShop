//
//  AEProductFieldObject.h
//  AnalyticsEngine
//
//  Created by Vincent Lee on 3/26/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEProductFieldObject : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *variant;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSString *coupon;
@property (strong, nonatomic) NSNumber *position;

-(instancetype)initWithID:(NSString *)ID
                     name:(NSString *)name
                    brand:(NSString *)brand
                 category:(NSString *)category
                  variant:(NSString *)variant
                 position:(NSNumber *)position
                   coupon:(NSString *)coupon
                    price:(NSString *)price
                 quantity:(NSNumber *)quantity;

@end
