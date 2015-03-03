//
//  ThankYouViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "ThankYouViewController.h"
#import "Cart.h"
#import "TAGDataLayer.h"
#import "TAGManager.h"

@interface ThankYouViewController ()

@property (strong, nonatomic) NSString *screenName;
@property (weak, nonatomic) IBOutlet UILabel *thankyouLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Thank You View";
    self.thankyouLabel.adjustsFontSizeToFitWidth = true;
    self.returnButton.titleLabel.adjustsFontSizeToFitWidth = true;
    [[Cart singleton].cartArray removeAllObjects];
    [Cart singleton].total = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"openScreen",
                      @"screenName" : self.screenName}];
}

- (IBAction)returnButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}

@end
