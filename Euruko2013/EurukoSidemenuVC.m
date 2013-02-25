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

- (void)closeMenuAndPerformAction:(NSInteger)menuId;

@end

@implementation EurukoSidemenuVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
      // Show Dashboard Menu item
    case 1:
      // Rooms Menu item
    case 2:
      // Maps Menu item
    case 4:
      // Logout Menu item
    case 5:
      [self closeMenuAndPerformAction:indexPath.row];
      break;
      
    default:
      break;
  }
}

- (void)closeMenuAndPerformAction:(NSInteger)menuId {
  // Hide with Bouncing the SideMenu
  [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller){
    [self.delegate performMenuActionWithId:menuId];
  }];
}

@end
