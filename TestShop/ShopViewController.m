//
//  ShopViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/26/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "ShopViewController.h"
#import "Item.h"
#import "ItemCell.h"
#import "Cart.h"
#import "DetailViewController.h"
#import "Shop.h"
#import "CartViewController.h"

#import "TAGDataLayer.h"
#import "TAGManager.h"

#import "TAGContainerOpener.h"
#import "AppDelegate.h"

@interface ShopViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TAGContainerOpenerNotifier>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cartBarButtonItem;

@property (strong, nonatomic) NSString *screenName;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  Setting GTM DataLayer Values for DataLayer Macros. Shop View will the the value for the "screenName" key.
    self.screenName = @"Shop View";
    
    NSLog(@"viewDidLoad");
    
    UINib *cellNib = [UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ItemCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    [self.collectionView reloadData];
    NSInteger totalNumberOfItems = [[Cart singleton] totalNumberOfItemsInCart];
    self.cartBarButtonItem.title = [NSString stringWithFormat:@"Cart(%ld)", (long)totalNumberOfItems];
}

//Fires when container finishes loading
-(void)containerAvailable:(TAGContainer *)container {
    //  Because containerAvailable may run on any thread, use dispatch_async(dispatch_get_main_queue() to ensure the appDelegates container property becomes initialized.
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.container = container;
        [appDelegate.container refresh];
        NSLog(@"Container availiable");
        TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
        [dataLayer push:@{@"event" : @"openScreen",
                          @"screenName" : self.screenName}];
    });
}

- (IBAction)cartButtonPressed:(id)sender {
    NSNumber *numberOfItems = [[NSNumber alloc] initWithInteger:[Cart singleton].totalNumberOfItemsInCart];
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"buttonPressed",
                      @"eventCategoryName" : @"Button",
                      @"eventActionName" : @"Pressed",
                      @"eventLabelName" : @"Cart",
                      @"eventValueName" : numberOfItems}];
                      
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
    [self.navigationController pushViewController:cartVC animated:true];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    Shop *shop = [Shop singleton];
    Item *item = [shop.shopItems objectAtIndex:indexPath.row];
    cell.imageView.image = item.image;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)item.count];
    [cell.countLabel.layer setCornerRadius:5];
    [cell.countLabel.layer setMasksToBounds: true];
//    NSString *itemCostString = [NSString stringWithFormat:@"%ld", (long)item.cost];
//    NSNumber *position = [[NSNumber alloc] initWithDouble:indexPath.row];
//    NSDictionary *itemDictionary =  @{@"name" : item.name,
//                                      @"id" : item.sku,
//                                      @"price" : itemCostString,
//                                      @"brand" : item.brand,
//                                      @"category" : item.category,
//                                      @"varient" : item.varient,
//                                      @"list" : @"Front Page",
//                                      @"position" : position};
//    [self.frontPageItemMutableArray addObject:itemDictionary];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Shop *shop = [Shop singleton];
    return shop.shopItems.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Shop *shop = [Shop singleton];
    Item *item = [shop.shopItems objectAtIndex:indexPath.row];
    NSString *touchedItem = [NSString stringWithFormat:@"Touched %@", item.name];
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"buttonPressed",
                      @"eventCategoryName" : @"Button",
                      @"eventActionName" : @"Pressed",
                      @"eventLabelName" : touchedItem}];
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.item = item;
    
    [self.navigationController pushViewController:detailVC animated:true];
}


@end
