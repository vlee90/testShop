//
//  AETransaction.h
//  AnalyticsEngine
//
//  Created by John Clem on 9/22/14.
//  Copyright (c) 2014 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Transaction Object compatible with standard and enhanced flavors of GA ecommerce
 */
@interface AETransaction : NSObject

/**
 *  Unique transaction identifier
 *
 *  Maps to transactionId field in Google Analytics eCommerce
 *
 *  Required Property
 */
@property (nonatomic, strong) NSString *transactionId;

/**
 *  Partner or store
 *
 *  Maps to transactionAffiliation field in Google Analytics eCommerce
 */
@property (nonatomic, strong) NSString *affiliation;

/**
 *  Total value of the transaction
 *
 *  Maps to transactionTotal field in Google Analytics eCommerce
 */
@property (nonatomic, strong) NSString *total;

/**
 *  Tax amount for the transaction
 *
 *  Maps to transactionTax field in Google Analytics eCommerce
 */
@property (nonatomic, strong) NSString *tax;

/**
 *  Shipping cost for the transaction
 *
 *  Maps to transactionShipping field in Google Analytics eCommerce
 */
@property (nonatomic, strong) NSString *shipping;

/**
 *  Currency of the transaction (e.g. @"USD")
 *
 *  Maps to transactionCurrency field in Google Analytics eCommerce
 */
@property (nonatomic, strong) NSString *currency;

/**
 *  List of items purchased in the transaction	an array of AEProducts containing item variables
 *
 *  Items in the array are assumed to be of type AEProduct
 *
 *  Maps to transactionProducts field in Google Analytics eCommerce
 */
@property (nonatomic, strong) NSArray *products;

/**
 *  Initialize a new transaction object with the required transactionId property in-place
 *
 *  @param transactionId Unique transaction identifier
 *
 *  @return new AETransaction object
 */
- (instancetype)initWithTransactionId:(NSString *)transactionId;

/**
 *  Convenience initializer
 *
 *  @param transactionId Unique transaction identifier
 *  @param affiliation   Partner or Store
 *  @param total         Total value of the transaction
 *  @param tax           Tax amount for the transaction
 *  @param shipping      Shipping cost for the transaction
 *  @param currency      Currency of the transaction (e.g. @"USD")
 *  @param products      List of items purchased in the transaction	an array of AEProducts containing item variables
 *
 *  @return new AETransaction object
 */



- (instancetype)initWithTransactionId:(NSString *)transactionId
                          affiliation:(NSString *)affiliation
                                total:(NSString *)total
                                  tax:(NSString *)tax
                             shipping:(NSString *)shipping
                             currency:(NSString *)currency
                             products:(NSArray  *)products;

@end
