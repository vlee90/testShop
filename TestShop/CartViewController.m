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
    
    //  Set screen name for GTM App View.
    self.screenName = @"Cart View";
    
    //  Additional non-GTM loading code.
    [self viewDidLoadHelper];
    }

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  Push dictionary to dataLayer that will create App View hit.
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"openScreen",
                      @"screenName" : self.screenName}];
    
    //  Get all products in cart. They are formatted in a way that Enhanced Ecommerce will understand.
    NSArray *productArray = [[NSArray alloc] initWithArray:[[Cart singleton] ecommerceCartArray]];
    
    //  Reset ecommerce values.
    [dataLayer push:@{@"event" : @"EEscreenSeen",
                      @"ecommerce" : [NSNull null]}];
    
     //  Push a dictionary to that will create a checkout step.
    [dataLayer push:@{@"event" : @"cartSeen",
                      @"ecommerce" : @{
                              @"checkout" : @{
                                      @"actionField" : @{
                                              @"step" : @1
                                              },
                                      @"products" : productArray
                                      }
                              }
                      }
     ];
    
    //  Reset ecommerce values.
    [dataLayer push:@{@"event" : @"EEscreenSeen",
                      @"ecommerce" : [NSNull null]}];
}

-(void)checkoutButtonPressed:(id)sender {
    
    //  Get total cost of transaction.
    NSNumber *total = [[NSNumber alloc] initWithDouble:[Cart singleton].total];
    
    //  Push dictionary to dataLayer that will create an Event Hit.
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event" : @"buttonPressed",
                      @"eventCategoryName" : @"Button",
                      @"eventActionName" : @"Pressed",
                      @"eventLabelName" : @"Checkout",
                      @"eventValueName" : total}];
    
    //  Push view to CheckoutViewController.
    CheckoutViewController *checkoutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutVC"];
    [self.navigationController pushViewController:checkoutVC animated:true];
}

//  Load cells based on what is in the cart.
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

//  Total number of cells equal the amount of different type of items in cart.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Cart *cart = [Cart singleton];
    return cart.cartArray.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

//  Helper function that runs non GTM related code in viewDidLoad.
-(void)viewDidLoadHelper {
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

//  Helper function that runs non GTM related code in viewDidAppear.
-(void)viewDidAppearHelper {
    
}

@end
