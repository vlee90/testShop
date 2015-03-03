//
//  CartViewController.h
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "CartViewController.h"
#import "Cart.h"
#import "CartCell.h"
#import "Item.h"
#import "CheckoutViewController.h"
#import "TAGDataLayer.h"
#import "TAGManager.h"

@interface CartViewController ()<UITableViewDataSource>

@property (strong, nonatomic) NSString *screenName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Cart View";
    UINib *checkoutNib = [UINib nibWithNibName:@"CartCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:checkoutNib forCellReuseIdentifier:@"CartCell"];
    self.tableView.dataSource = self;
    
    UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkout"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self action:@selector(checkoutButtonPressed:)];
    self.navigationItem.rightBarButtonItem = checkoutButton;
    
    [[Cart singleton] calculateTotal];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: $%ld.00", (long)[Cart singleton].total];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"openScreen",
                      @"screenName" : self.screenName}];
}

-(void)checkoutButtonPressed:(id)sender {
      CheckoutViewController *checkoutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutVC"];
      [self.navigationController pushViewController:checkoutVC animated:true];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
    Cart *cart = [Cart singleton];
    Item *item = [cart.cartArray objectAtIndex:indexPath.row];
    cell.checkoutImageView.image = item.image;
    cell.nameLabel.text = item.name;
    cell.costLabel.text = [NSString stringWithFormat:@"$%ld.00", (long)item.cost];
    cell.amountLabel.text = [NSString stringWithFormat:@"Amount: %ld", (long)item.count];
    NSInteger subtotal = item.cost * item.count;
    cell.subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: $%ld.00", (long)subtotal];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Cart *cart = [Cart singleton];
    return cart.cartArray.count;
}

@end
