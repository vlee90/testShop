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
#import "CheckoutViewController.h"

@interface ShopViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ItemCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (IBAction)checkoutButtonPressed:(id)sender {
    CheckoutViewController *checkoutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutVC"];
    [self.navigationController pushViewController:checkoutVC animated:true];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    Shop *shop = [Shop singleton];
    Item *item = [shop.shopItems objectAtIndex:indexPath.row];
    cell.imageView.image = item.image;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)item.count];
    [cell.countLabel.layer setCornerRadius:5];
    [cell.countLabel.layer setMasksToBounds: true];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Shop *shop = [Shop singleton];
    return shop.shopItems.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Shop *shop = [Shop singleton];
    Item *item = [shop.shopItems objectAtIndex:indexPath.row];
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.item = item;
    
    [self.navigationController pushViewController:detailVC animated:true];
}


@end
