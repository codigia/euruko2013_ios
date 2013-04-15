//
//  EurukoMainVC.m
//  Euruko2013
//
//  Created by George Paloukis on 25/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoMainVC.h"
#import "EurukoSidemenuVC.h"
#import "EurukoNewsVC.h"
#import "EurukoSpeakersVC.h"

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

// Menu Item: News
- (void)showNews {
  if ([self.topViewController isKindOfClass:[EurukoNewsVC class]])
    return;
  
  for (UIViewController *theVC in self.viewControllers) {
    if ([theVC isKindOfClass:[EurukoNewsVC class]]) {
      [self popToViewController:theVC animated:NO];
      return;
    }
  }
}

// Menu Item: Speakers
- (void)showSpeakers {
  if ([self.topViewController isKindOfClass:[EurukoSpeakersVC class]])
    return;
  
  for (UIViewController *theVC in self.viewControllers) {
    if ([theVC isKindOfClass:[EurukoSpeakersVC class]]) {
      [self popToViewController:theVC animated:NO];
      return;
    }
  }

  UIStoryboard *storyboard = self.storyboard;
  EurukoSpeakersVC *spkVC = (EurukoSpeakersVC *)[storyboard instantiateViewControllerWithIdentifier:@"speakersViewController"];
  [self pushViewController:spkVC animated:NO];
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
      // Show News Menu item
    case 0:
      [self showNews];
      break;
      
      // Speakers Menu item
    case 2:
      [self showSpeakers];
      break;
      
      
    case 4:
      
      break;
      
    case 5:
      
      break;
      
    default:
      break;
  }
}

@end
