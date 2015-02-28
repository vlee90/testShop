//
//  CheckoutViewController.m
//  TestShop
//
//  Created by Vincent Lee on 2/27/15.
//  Copyright (c) 2015 Analytics Pros. All rights reserved.
//

#import "CheckoutViewController.h"
#import "Cart.h"
#import "CheckoutCell.h"
#import "Item.h"

@interface CheckoutViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *checkoutNib = [UINib nibWithNibName:@"CheckoutCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:checkoutNib forCellReuseIdentifier:@"CheckoutCell"];
    self.tableView.dataSource = self;
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self action:@selector(confirmButtonPressed:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
    [[Cart singleton] calculateTotal];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: $%ld.00", (long)[Cart singleton].total];
}

-(void)confirmButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm"
                                                                            message:@"Are you sure?"
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          NSLog(@"YES");
                                                      }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       NSLog(@"Cancel");
                                                   }];
    [alertController addAction:yesAction];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:true completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckoutCell" forIndexPath:indexPath];
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
