//
//  AEPromoFieldObject.h
//  AnalyticsEngine
//
//  Created by Vincent Lee on 3/26/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEPromoFieldObject : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *creative;
@property (strong, nonatomic) NSString *position;

-(instancetype)initWithID:(NSString *)ID
                     name:(NSString *)name
                 creative:(NSString *)creative
                 position:(NSString *)position;

@end
