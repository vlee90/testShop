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

@import GoogleMobileAds;


@interface ShopViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TAGContainerOpenerNotifier, GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cartBarButtonItem;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (strong, nonatomic) NSMutableArray *dataLayerPreLoadedArray;

@property BOOL firstLoad;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //AdMob BannerView
    self.bannerView.adUnitID = @"ca-app-pub-9556864914299273/1742019142";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"55d62768130c65acb15406b335eef4c6"];
    request.contentURL = @"https://click.google-analytics.com/redirect?tid=UA-60094916-4&url=https%3A%2F%2Fitunes.apple.com%2Fus%2Fapp%2Fskater-brad%2Fid939780266%3Fmt%3D8&aid=com.analyticspros.TestShop&idfa={idfa}&cs=newsletter&cm=email&cn=email-campaign-march-2015&cc=text-link&hash=md5";
    [self.bannerView loadRequest:request];
    https://click.google-analytics.com/redirect?tid=UA-60094916-4&url=https%3A%2F%2Fitunes.apple.com%2Fus%2Fapp%2Fskater-brad%2Fid939780266%3Fmt%3D8&aid=com.analyticspros.TestShop&idfa=$IDA&cs=newsletter&cm=email&cn=email-campaign-march-2015&cc=text-link
    
    
    //  Code that helps set up View Controller but doesn't relate to GTM.
    [self viewDidLoadHelper];
    
    NSDictionary *userID = @{@"user-id" : [NSNull null]};
    [self containerStateForkPushDictionary:userID];
    
    NSLog(@"%@", PROJECT_DIR);
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //  Create dictionary for app view hit.
    NSDictionary *screenViewDictionary = @{@"event" : @"screen-open",
                                           @"screen-name" : @"Shop View"};

    //  Push into method to ensure hit fires when container is open.
    [self containerStateForkPushDictionary:screenViewDictionary];
    
    
    //  Code that helps set up View Controller but doesn't relate to GTM.
    [self viewDidAppearHelper];
}

//Fires when container finishes loading
-(void)containerAvailable:(TAGContainer *)container {
    //  continaerAvailable will run code on any thread. GCD will code ensures that code is dispatched to main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        //  Maintain reference to container
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.container = container;
        
#ifdef DEBUG
        //  For testing purposes only
        [appDelegate.container refresh];
#endif
        
        //  Sets the container state. Now all pushes to the dataLayer will be sent to Google Analytics.
        appDelegate.isContainerOpen = true;
        
        //  Send any hits that were supposed to fire before the container was open.
        TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
        for (NSInteger i = 0; i < self.dataLayerPreLoadedArray.count; i++) {
            [dataLayer push:[self.dataLayerPreLoadedArray objectAtIndex:i]];
        }
        
        //  Resets the ecommerce values in the dataLayer. This is needed to ensure that values from old hits do not be resent in new hits.
        [dataLayer push:@{@"event" : @"reset-ecommerce",
                          @"ecommerce" : [NSNull null]}];
    });
}


- (IBAction)cartButtonPressed:(id)sender {
    //  Total Number of items in cart.
    NSNumber *numberOfItems = [[NSNumber alloc] initWithInteger:[Cart singleton].totalNumberOfItemsInCart];
    //  Build dictionary to fire Event Tag.
    NSDictionary *cartButtonDictionary = @{@"event" : @"button-Pressed",
                                           @"event-category-name" : @"Button",
                                           @"event-action-name" : @"Pressed",
                                           @"event-label-name" : @"Cart",
                                           @"event-value-name" : numberOfItems};
     //  Pass to this custom method to ensure the container is open before pushing the dictionary to the dataLayer.
    [self containerStateForkPushDictionary:cartButtonDictionary];
    
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
    NSDictionary *impressionDictionary = @{@"event" : @"impression-seen",
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
    //  Pass to this custom method to ensure the container is open before pushing the dictionary to the dataLayer.
    [self containerStateForkPushDictionary:impressionDictionary];
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
    NSDictionary *productTouchedDictionary =  @{@"event" : @"product-touched",
                                                @"event-label-name" : item.name,
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
    
     //  Pass to this custom method to ensure the container is open before pushing the dictionary to the dataLayer.
    [self containerStateForkPushDictionary:productTouchedDictionary];
    
    //  Push view to the DetailViewController.
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.item = item;
    
    [self.navigationController pushViewController:detailVC animated:true];
}


//  This method ensures that any dictionary that should be pushed to the dataLayer will not be pushed until the container is open.
-(void)containerStateForkPushDictionary:(NSDictionary *)dictionary {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    if (appDelegate.isContainerOpen) {
        //  Container is open so dictionary will be pushed.
        [dataLayer push:dictionary];
        
        //  Resets the ecommerce values in the dataLayer. This is needed to ensure that values from old hits do not be resent in new hits.
        [dataLayer push:@{@"event" : @"reset-ecommerce",
                          @"ecommerce" : [NSNull null]}];
    }
    else {
        //  Will push dictionary when container is available.
        [self.dataLayerPreLoadedArray addObject:dictionary];
    }
}

//  Code that is needed for the ViewController but isn't related to GTM.
-(void)viewDidLoadHelper {
    //  Prepare collectionView
    UINib *cellNib = [UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ItemCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //  Initialize to be loaded
    self.dataLayerPreLoadedArray = [NSMutableArray new];
    
    //  Track state of view's loading.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.firstLoad = true;
    });
}

//  Code that is needed for the ViewController but isn't related to GTM.
-(void)viewDidAppearHelper {
    //  Loads new quanitiy values after use puts them into cart in DetailViewController.
    
    //  Dependent on BOOL. If not, UICollectionView::reloadData is causing impression hits to be created TWICE on initial app launch. A bit "hacky". Not a great solution.
    if (self.firstLoad == false) {
        [self.collectionView reloadData];
    }
    self.firstLoad = false;

    
    //
    NSInteger totalNumberOfItems = [[Cart singleton] totalNumberOfItemsInCart];
    self.cartBarButtonItem.title = [NSString stringWithFormat:@"Cart(%ld)", (long)totalNumberOfItems];
}


@end
