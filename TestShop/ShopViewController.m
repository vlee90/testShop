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

@interface ShopViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cartBarButtonItem;

@property (strong, nonatomic) NSString *screenName;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"LOADED");
    //  Setting GTM DataLayer Values for DataLayer Macros. Shop View will the the value for the "screenName" key.
    self.screenName = @"Shop View";

    //  Code that helps set up View Controller but doesn't relate to GTM.
    [self viewDidLoadHelper];
    
    NSDictionary *userID = @{@"userId" : [NSNull null]};
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //  Create dictionary for app view hit.
    NSDictionary *screenViewDictionary = @{@"event" : @"openScreen",
                                           @"screenName" : self.screenName};
    
    
    //  Code that helps set up View Controller but doesn't relate to GTM.
    [self viewDidAppearHelper];
}

- (IBAction)cartButtonPressed:(id)sender {
    //  Total Number of items in cart.
    NSNumber *numberOfItems = [[NSNumber alloc] initWithInteger:[Cart singleton].totalNumberOfItemsInCart];
    //  Build dictionary to fire Event Tag.
    NSDictionary *cartButtonDictionary = @{@"event" : @"buttonPressed",
                                           @"eventCategoryName" : @"Button",
                                           @"eventActionName" : @"Pressed",
                                           @"eventLabelName" : @"Cart",
                                           @"eventValueName" : numberOfItems};
    
    //  Push to the User's Cart.
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
    [self.navigationController pushViewController:cartVC animated:true];
}

//  Fires when a collectionView cell loads. If a cell not yet visible to the user, it will not be loaded - therefore will not fire this function (and tag) until the cell is visible.
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //  Grab values to populatae cell from the Shop. The shop contains all possible items.
    ItemCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    Shop *shop = [Shop singleton];
    Item *item = [shop.shopItems objectAtIndex:indexPath.row];
    cell.imageView.image = item.image;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)item.count];
    [cell.countLabel.layer setCornerRadius:5];
    [cell.countLabel.layer setMasksToBounds: true];
    
    //  Create dictionary for impression hit that represents the item in the cell.
    NSDictionary *impressionDictionary = @{@"event" : @"EEscreenSeen",
                                           @"ecommerce" : @{
                                                   @"impressions" : @[
                                                           @{@"name" : item.name,
                                                             @"id" : item.sku,
                                                             @"price" : [NSString stringWithFormat:@"%ld", (long)item.cost],
                                                             @"brand" : item.brand,
                                                             @"category" : item.category,
                                                             @"variant" : item.varient,
                                                             @"list" : @"Front Page Shop",
                                                             @"position" : [[NSNumber alloc] initWithInteger:indexPath.row]
                                                             }
                                                           ]
                                                   }
                                           };
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //  The number of items is equal to the total number of items in the shop.
    Shop *shop = [Shop singleton];
    return shop.shopItems.count;
}

//  Fires when a user touches an item in the collectionView.
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Shop *shop = [Shop singleton];
    Item *item = [shop.shopItems objectAtIndex:indexPath.row];
    
    //  Create dictionary that will create a product touched event when pushed to the dataLayer.
    NSDictionary *productTouchedDictionary =  @{@"event" : @"productTouched",
                                                @"eventLabelName" : item.name,
                                                @"ecommerce" : @{
                                                        @"click" : @{
                                                                @"actionField" : @{
                                                                        @"list" : @"Front Page Shop"
                                                                        },
                                                                @"products" : @[
                                                                        @{@"name" : item.name,
                                                                          @"id" : item.sku,
                                                                          @"price" : [NSString stringWithFormat:@"%ld", (long)item.cost],
                                                                          @"brand" : @"Analytics Pros",
                                                                          @"category" : item.category,
                                                                          @"variant" : item.varient}
                                                                        ]
                                                                }
                                                        }
                                                };
    
    //  Push view to the DetailViewController.
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.item = item;
    
    [self.navigationController pushViewController:detailVC animated:true];
}

//  Code that is needed for the ViewController but isn't related to GTM.
-(void)viewDidLoadHelper {
    //  Prepare collectionView
    UINib *cellNib = [UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ItemCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

//  Code that is needed for the ViewController but isn't related to GTM.
-(void)viewDidAppearHelper {
    [self.collectionView reloadData];

    NSInteger totalNumberOfItems = [[Cart singleton] totalNumberOfItemsInCart];
    self.cartBarButtonItem.title = [NSString stringWithFormat:@"Cart(%ld)", (long)totalNumberOfItems];
}


@end
