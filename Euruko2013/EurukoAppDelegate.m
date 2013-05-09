//
//  EurukoAppDelegate.m
//  Euruko2013
//
//  Created by George Paloukis on 22/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoAppDelegate.h"
#import "EurukoSidemenuVC.h"
#import "EurukoNewsVC.h"
#import "IIViewDeckController.h"
#import "AFNetworking.h"

@implementation EurukoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Enable Net Indicator manager of AFNetworking framework
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  
  // Reference the Main App Controller
  self.mainController = (EurukoMainVC *) self.window.rootViewController;
  
  // Set properties for News VC (EurukoNewsVC)
  EurukoNewsVC *newsVC = (EurukoNewsVC *)[self.mainController.viewControllers objectAtIndex:0];
  newsVC.newsContent = self.mainController.newsContent;
  newsVC.delegate = self.mainController;
  
  // Initialize SideMenu VC
  UIStoryboard *storyboard = self.mainController.storyboard;
  EurukoSidemenuVC *sidemenuVC = (EurukoSidemenuVC *)[storyboard instantiateViewControllerWithIdentifier:@"sideMenuTableController"];
  sidemenuVC.delegate = (EurukoMainVC<EurukoSidemenuViewControllerDelegate> *)self.mainController;
  
  // Setup ViewDeck VC
  IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.mainController leftViewController:sidemenuVC rightViewController:nil];
  deckController.leftSize = 50;
  deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
  
  self.window.rootViewController = deckController;
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
