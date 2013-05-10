//
//  EurukoSidemenuVC.m
//  Euruko2013
//
//  Created by George Paloukis on 24/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSidemenuVC.h"
#import "IIViewDeckController.h"

@interface EurukoSidemenuVC ()

@property (weak, nonatomic) IBOutlet UIView *footerView;

- (IBAction)footerBtnTapped:(id)sender;

- (void)closeMenuAndPerformAction:(NSInteger)menuId;

@end

@implementation EurukoSidemenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  // Calculate Footer View's height
  // TableView's height is: statusbar:20, EurukoTitle:100, 6 menu items * 44
  // TODO: Currently 4 menu items
  self.footerView.bounds = CGRectMake(self.footerView.bounds.origin.x, self.footerView.bounds.origin.y, self.footerView.bounds.size.width, [UIScreen mainScreen].bounds.size.height - (20+100+4*44));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  // Perform Menu Item action
  switch (indexPath.row) {
      // News Menu item
    case 0:
      // Agenda Menu item
    case 1:
      // Speakers Menu item
    case 2:
      // Twitter Menu item
    case 3:
      // Map Menu item
    case 4:
      // About Menu item
    case 5:
      [self closeMenuAndPerformAction:indexPath.row];
      break;
      
    default:
      break;
  }
}

- (IBAction)footerBtnTapped:(id)sender {
  // About Menu item (watch out its id)
  [self closeMenuAndPerformAction:3];
}

- (void)closeMenuAndPerformAction:(NSInteger)menuId {
  // Hide with Bouncing the SideMenu
  [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller){
    [self.delegate performMenuActionWithId:menuId];
  }];
}

- (void)viewDidUnload {
  [self setFooterView:nil];
  [super viewDidUnload];
}
@end
