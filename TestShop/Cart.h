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
@property NSInteger total;
@property NSString *transactionID;

+(Cart *)singleton;
-(instancetype)init;

-(void)calculateTotal;
-(NSArray *)ecommerceCartArray;
-(NSInteger)totalNumberOfItemsInCart;
-(NSArray *)productFieldObjectCart;

@end
