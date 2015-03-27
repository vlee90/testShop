//
//  AEImpressionFieldObject.h
//  AnalyticsEngine
//
//  Created by Vincent Lee on 3/26/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEImpressionFieldObject : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *list;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *variant;
@property (strong, nonatomic) NSNumber *position;
@property (strong, nonatomic) NSString *price;

-(instancetype)initWithID:(NSString *)ID name:(NSString *)name
                     list:(NSString *)list
                    brand:(NSString *)brand
                 category:(NSString *)category
                  variant:(NSString *)variant
                 position:(NSNumber *)position
                    price:(NSString *)price;

@end
