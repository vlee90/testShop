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

@interface ShopViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) Cart *cart;


@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ItemCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.cart = [[Cart alloc] init];
    [self fillCart:self.cart];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    Item *item = [self.cart.cartArray objectAtIndex:indexPath.row];
    cell.imageView.image = item.image;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)item.count];
    [cell.countLabel.layer setCornerRadius:5];
    [cell.countLabel.layer setMasksToBounds: true];
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cart.cartArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = [self.cart.cartArray objectAtIndex:indexPath.row];
    NSLog(@"%@", item.name);
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.cart = self.cart;
    detailVC.item = item;
    
    [self.navigationController pushViewController:detailVC animated:true];
}

-(void)fillCart:(Cart *)cart {
    cart.cartArray = [NSMutableArray new];
    Item *item0 = [[Item alloc] initWithName:@"Apple"
                                        cost:3
                                       image:[UIImage imageNamed:@"Apple"]
                                 description:@"Nice shiney red apple!"];
    Item *item1 = [[Item alloc] initWithName:@"Avacado"
                                        cost:5
                                       image:[UIImage imageNamed:@"Avacado"]
                                 description:@"Filling food!"];
    Item *item2 = [[Item alloc] initWithName:@"Egg"
                                        cost:2
                                       image:[UIImage imageNamed:@"Egg"]
                               description:@"Great way to start the morning!"];
    Item *item3 = [[Item alloc] initWithName:@"Orange"
                                        cost:3
                                       image:[UIImage imageNamed:@"Orange"]
                                 description:@"Great source of vitamins!"];
    [cart.cartArray addObject:item0];
    [cart.cartArray addObject:item1];
    [cart.cartArray addObject:item2];
    [cart.cartArray addObject:item3];
}


@end
