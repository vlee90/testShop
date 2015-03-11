//
//  AEProduct.h
//  AnalyticsEngine
//
//  Created by John Clem on 9/22/14.
//  Copyright (c) 2014 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEProduct : NSObject

/**
 *  product name (required)
 */
@property (nonatomic, strong) NSString *name;

/**
 *  product SKU
 */
@property (nonatomic, strong) NSString *sku;

/**
 *  product category
 */
@property (nonatomic, strong) NSString *category;

/**
 *  convert your price value to a string for Google Analytics compatibility e.g. NSString *priceString = [@(49.99) stringValue]
 */
@property (nonatomic, strong) NSString *price;

/**
 *  currency used for purchase (e.g. @"USD")
 */
@property (nonatomic, strong) NSString *currency;

/**
 *  quantity of items
 */
@property (nonatomic, strong) NSString *quantity;

/**
 *  initialize a new product object with the required name property in-place
 *
 *  @param name name of purchased product
 *
 *  @return new AEProduct object
 */
- (instancetype)initWithName:(NSString *)name;

/**
 *  convenience initializer
 *
 *  @param name     product name (required)
 *  @param sku      product SKU
 *  @param category product category
 *  @param price    convert your price value to a string for Google Analytics compatibility e.g. NSString *priceString = [@(49.99) stringValue]
 *  @param currency used for purchase (e.g. @"USD")
 *
 *  @return new AEProduct object
 */
- (instancetype)initWithName:(NSString *)name
                         SKU:(NSString *)sku
                    category:(NSString *)category
                       price:(NSString *)price
                    currency:(NSString *)currency;
@end