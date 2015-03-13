//
//  AEEvent.h
//  AnalyticsEngine
//
//  Created by John Clem on 9/26/14.
//  Copyright (c) 2014 Analytics Pros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEEvent : NSObject

/**
 *  Designated initializer
 *
 *  @param dict dictionary containing event information
 *
 *  @return AEEvent object, ready for datalayer push
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  name of the event in Google Tag Manager container
 */
@property (nonatomic, strong) NSString *eventName;

/**
 *  event parameters (seeded by designated initializer)
 */
@property (nonatomic, strong) NSDictionary *eventParams;

@end
