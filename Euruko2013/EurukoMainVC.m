//
//  EurukoMainVC.m
//  Euruko2013
//
//  Created by George Paloukis on 25/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoMainVC.h"
#import "EurukoSidemenuVC.h"

@interface EurukoMainVC () <EurukoSidemenuViewControllerDelegate>

@end

@implementation EurukoMainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 @method
 @abstract
 Performs each Action according SideMenu Item selection
 */
- (void)performMenuActionWithId:(NSInteger)menuItemId {
  // Hide Toolbar before change screen
  [self setToolbarHidden:YES animated:NO];
  
  // Perform Menu Item action
  switch (menuItemId) {
      // Show Profile Menu item
    case 1:
      //[self showDashboard];
      break;
      
      // Rooms Menu item
    case 2:
      //[self showRoomList];
      break;
      
      // Maps Menu item
    case 4:
      //[self showMap];
      break;
      
      // Logout Menu item
    case 5:
      //[self popToRootViewControllerAnimated:NO];
      //[self logOut];
      break;
      
    default:
      break;
  }
}

@end
