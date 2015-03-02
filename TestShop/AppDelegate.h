//
//  AppDelegate.h
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import <UIKit/UIKit.h>

//  Forward declaration of classes.
@class TAGManager;
@class TAGContainer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//  Create public properties of the forwardly declared classes.
@property (strong, nonatomic) TAGManager *tagManager;
@property (strong, nonatomic) TAGContainer *container;


@end

