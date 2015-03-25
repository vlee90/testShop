//
//  AppDelegate.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "AppDelegate.h"
#import "TAGContainerOpener.h"
#import "TAGManager.h"
#import "ShopViewController.h"

#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isContainerOpen = false;
    
    //  Get singleton of TAGManager
    self.tagManager = [TAGManager instance];
    
    //  Set Logger Level
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
    
    //  If your inital ViewController is dependent on app design. Should be first viewController with viewDidLoad/viewDidAppear, etc.
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    //Open Container
//    NSTimeInterval timeout = 0.000000000000000000000001;
    [TAGContainerOpener openContainerWithId:@"GTM-NJNM8T"
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferFresh
                                    timeout:nil
                                   notifier:(ShopViewController<TAGContainerOpenerNotifier> *)navController.viewControllers[0]];
    
#ifdef DEBUG
    NSTimeInterval dispatchTime = 5;
    [self.tagManager setDispatchInterval:dispatchTime];
#endif
    NSURL *url = [[NSURL alloc] initWithString:@"MFSkaterBrad://hostName?utm_campaign=test-shop-sale&utm_source=test-shop&utm_medium=referral&utm_term=seattle&utm_content=app-link"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSLog(@"URL Shall be Opened: %@", [url absoluteString]);
        [[UIApplication sharedApplication] openURL:url];
    }
    
    return YES;
}



#ifdef DEBUG
//  More PREVIEW Code
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *urlString = [url absoluteString];
    NSLog(@"Handling URL: %@", urlString);
    
    return YES;
    
//    NSString *urlString = [url absoluteString];
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-60094916-4"];
//    GAIDictionaryBuilder *hitParams = [[GAIDictionaryBuilder alloc] init];
//    [[hitParams setCampaignParametersFromUrl:urlString] build];
//    if (![hitParams valueForKey:kGAICampaignSource] && [url host].length != 0) {
//        [hitParams setValue:sourceApplication forKey:kGAICampaignMedium];
//        [hitParams setValue:[url host] forKey:kGAICampaignSource];
//    }
//    
//    NSDictionary *hitParamDict = [hitParams build];
//    NSLog(@"%@", hitParamDict);
//    [tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamDict] build]];
//    
//    if ([self.tagManager previewWithUrl:url]) {
//        return YES;
//    }
//    
//    return NO;
}
#endif


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
