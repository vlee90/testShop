//
//  AnalyticsEngine.h
//  AnalyticsEngine
//
//  Created by John Clem on 9/22/14.
//  Copyright (c) 2014 Analytics Pros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEProduct.h"
#import "AEEvent.h"
#import "AETransaction.h"
#import "AEAnalyzer.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIEcommerceFields.h"
#import "GAIFields.h"
#import "TAGContainer.h"
#import "TAGContainerOpener.h"
#import "TAGDataLayer.h"
#import "TAGLogger.h"
#import "TAGManager.h"

/**
 *  Project version number for AnalyticsEngine.
 */
FOUNDATION_EXPORT double AnalyticsEngineVersionNumber;

/**
 *  Project version string for AnalyticsEngine.
 */
FOUNDATION_EXPORT const unsigned char AnalyticsEngineVersionString[];


@interface AnalyticsEngine : NSObject


/**
 *  returns a reference to the shared singleton instance of AnalyticsEngine
 *
 *  @note you must call startEngineWithContainerID: before using this singleton object, otherwise this method will return nil
 *
 *  @return existing AnalyticsEngine singleton object
 *
 *  @see    + (void)startEngineWithContainerID:(NSString *)containerID;
 */
+ (AnalyticsEngine *)singleton;

/**
 *  initialize the AnalyticsEngine with a given Google Tag Manager container id
 *
 *  @param containerID name of the Google Tag Manager binary container file in your bundle e.g. @"GTM-ABCDEF"
 */
+ (void)startEngineWithContainerID:(NSString *)containerID;


/**
 *  sends an app view (screen view) to Google Tag Manager. 
 *
 *  @param screenName       name of the current screen or view (optional)
 *  @param viewController   view controller which owns the current view
 */
+ (void)pushScreenWithName:(NSString *)screenName
        fromViewController:(UIViewController *)viewController;

/**
 *  sends a touch event (typically a button tap) to Google Tag Manager.
 *  @note uses the sender's accessibilityIdentifier (if available) when senderName is nil
 *
 *  @param sender         button triggering the event (e.g. the (id)sender object in an IBAction method)
 *  @param senderName     name of the object triggering the event (optional)
 *  @param viewController view controller which owns the current view
 */
+ (void)pushEventForButton:(UIButton *)sender
                  withName:(NSString *)senderName
        fromViewController:(UIViewController *)viewController;

/**
 *  send a new form field value to Google Tag Manager
 *
 *  @param newValue         new value entered into the field by the user (optional)
 *  @param field            textField object currently being edited by the user
 *  @param fieldName        name for the field currently being edited by the user (optional)
 *  @param viewController   view controller which owns the current view
 */
+ (void)pushNewValue:(NSString *)newValue
        forTextField:(UITextField *)field
            withName:(NSString *)fieldName
  fromViewController:(UIViewController *)viewController;

/**
 *  sends an event to Google Analytics via your Google Tag Manager container's configuration
 *
 *  @param eventName name of the event
 *  @param params    dictionary of additional parameters and/or custom dimensions
 */
+ (void)pushEventNamed:(NSString *)eventName
            withParams:(NSDictionary *)params;

/**
 *  sends an AEEvent to Google Analytics via your Google Tag Manager container's configuration
 *
 *  @param event an event being pushed to the Google Tag Manager Data Layer
 */
+ (void)pushEvent:(AEEvent *)event;

/**
 *  sends an exception to the Google Tag Manager dataLayer
 *
 *  @param message description of the exception
 *  @param isFatal TRUE if the exception is fatal, FALSE if non-fatal
 */
+ (void)pushExceptionWithMessage:(NSString *)message
                           fatal:(BOOL)isFatal;



/**
 *  send a transaction and any associated items to Google Analytics when a user completes an in-app purchase
 *
 *  @param transaction an object containing details about the transaction and an array of items purchased
 */
+ (void)pushTransaction:(AETransaction *)transaction;

/**
 *  Initializes Analytics Engine with  a given UAProperty ID.
 *
 *  @param UAProperty Univeral Analytics ID for Debug Hits (e.g. @"UA-XXXXXX-X")
 *
 *  @note Universal Analytics ID in GTM must reference the data layer variable "UAID"
 *
 *  @see startEngineWithContainerID: to use the default UA Property ID from your GTM container
 */
+ (void)enableDebugModeWithUAProperty:(NSString *)UAProperty;

/**
 *  immediately flushes the Google Tag Manager event queue sending any queued events and app views (screen views) to Google Analytics
 *
 *  @param completionHandler called after the GTM dispatch queue has been cleared. provides dispatch status in the completionHandler
 */
+ (void)dispatchEventQueueWithCompletionHandler:(void (^)(NSString *status))completionHandler;

/**
 *  <#Description#>
 *
 *  @param viewController <#viewController description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)nameForViewController:(UIViewController *)viewController;

@end