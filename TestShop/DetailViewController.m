//
//  DetailViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.item.image;
    self.nameLabel.text = self.item.name;
    self.costLabel.text = [NSString stringWithFormat:@"%ld", (long)self.item.cost];
    self.descriptionLabel.text = self.item.itemDescription;
    self.numberInCartLabel.text = [NSString stringWithFormat:@"%ld in Cart", (long)self.item.count];
}

-(IBAction)buyButtonPressed:(id)sender {
    NSLog(@"BUY");
}

@end
