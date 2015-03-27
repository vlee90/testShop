//
//  AEEnhancedEcommerceTransaction.h
//  AnalyticsEngine
//
//  Created by Vincent Lee on 3/26/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEEnhancedEcommerceTransaction : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *affiliation;
@property (strong, nonatomic) NSString *revenue;
@property (strong, nonatomic) NSString *tax;
@property (strong, nonatomic) NSString *shipping;
@property (strong, nonatomic) NSString *coupon;
@property (strong, nonatomic) NSArray *productArray;

-(instancetype)initWithID:(NSString *)ID
              affiliation:(NSString *)affiliation
                  revenue:(NSString *)revenue
                      tax:(NSString *)tax
                 shipping:(NSString *)shipping
                   coupon:(NSString *)coupon
                 products:(NSArray *)products;

@end
