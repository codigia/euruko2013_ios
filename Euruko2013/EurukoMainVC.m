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
#import "EurukoAgendaVC.h"
#import "EurukoSpeakersVC.h"

@interface EurukoMainVC () <EurukoSidemenuViewControllerDelegate>

- (void)loadDataFromFileSystem;
- (void)saveDataToFileSystemForContentType:(EurukoContentType)type;

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
  // Load data from filesystem
  [self loadDataFromFileSystem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Menu related methods
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

// Menu Item: Agenda
- (void)showAgenda {
  if ([self.topViewController isKindOfClass:[EurukoAgendaVC class]])
    return;
  
  for (UIViewController *theVC in self.viewControllers) {
    if ([theVC isKindOfClass:[EurukoAgendaVC class]]) {
      [self popToViewController:theVC animated:NO];
      return;
    }
  }
  
  UIStoryboard *storyboard = self.storyboard;
  EurukoAgendaVC *spkVC = (EurukoAgendaVC *)[storyboard instantiateViewControllerWithIdentifier:@"agendaViewController"];
  [self pushViewController:spkVC animated:NO];
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
      
      // Show News Menu item
    case 1:
      [self showAgenda];
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

#pragma mark - Load/Store content to Filesystem
- (void)loadDataFromFileSystem {
  // Locate files in Application Support standard directory
  NSFileManager* sharedFM = [NSFileManager defaultManager];
  NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
                                           inDomains:NSUserDomainMask];
  NSURL* appSupportDir = nil;
  NSURL* appDirectory = nil;
  
  if ([possibleURLs count] >= 1) {
    // Use the first directory (if multiple are returned)
    appSupportDir = [possibleURLs objectAtIndex:0];
    // If a valid app support directory exists, add the
    // app's bundle ID to it to specify the final directory.
    NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
    appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
  }
  if (appDirectory == nil) {
    NSLog(@"Load Data From Filesystem: ERROR! NOT Valid Application Support directory!");
    return;
  }
  // Read Data from stored files
  // News content
  NSURL *dataFileURL = [appDirectory URLByAppendingPathComponent:@"news.xml"];
  NSError *error = nil;
  NSData *contentData = [[NSData alloc] initWithContentsOfURL:dataFileURL options:NSDataReadingUncached error:&error];
  if (error) {
    NSLog(@"Load Data From Filesystem: ERROR on Reading news.xml file, error: %@", error);
  } else {
    // De-serialize data from file to NSDictionary/NSArray
    self.newsContent = [NSPropertyListSerialization propertyListWithData:contentData options:NSPropertyListImmutable format:NULL error:&error];
    if (error) {
      NSLog(@"Load Data From Filesystem: ERROR on De-Serializing News data, error: %@", error);
    }
  }
  
  // Agenda content
  dataFileURL = [appDirectory URLByAppendingPathComponent:@"agenda.xml"];
  error = nil;
  contentData = [[NSData alloc] initWithContentsOfURL:dataFileURL options:NSDataReadingUncached error:&error];
  if (error) {
    NSLog(@"Load Data From Filesystem: ERROR on Reading agenda.xml file, error: %@", error);
  } else {
    // De-serialize data from file to NSDictionary/NSArray
    self.agendaContent = [NSPropertyListSerialization propertyListWithData:contentData options:NSPropertyListImmutable format:NULL error:&error];
    if (error) {
      NSLog(@"Load Data From Filesystem: ERROR on De-Serializing Agenda data, error: %@", error);
    }
  }
  
  // Speakers content
  dataFileURL = [appDirectory URLByAppendingPathComponent:@"speakers.xml"];
  error = nil;
  contentData = [[NSData alloc] initWithContentsOfURL:dataFileURL options:NSDataReadingUncached error:&error];
  if (error) {
    NSLog(@"Load Data From Filesystem: ERROR on Reading speakers.xml file, error: %@", error);
  } else {
    // De-serialize data from file to NSDictionary/NSArray
    self.speakersContent = [NSPropertyListSerialization propertyListWithData:contentData options:NSPropertyListImmutable format:NULL error:&error];
    if (error) {
      NSLog(@"Load Data From Filesystem: ERROR on De-Serializing Speakers data, error: %@", error);
    }
  }
}

- (void)saveDataToFileSystemForContentType:(EurukoContentType)type {
  // Locate Application Support standard directory
  NSError *error = nil;
  NSFileManager *sharedFM = [NSFileManager defaultManager];
  NSURL *appSupportDir = [sharedFM URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
  if (appSupportDir == nil) {
    NSLog(@"Save Data to Filesystem: ERROR on Locating App Support directory, error: %@", error);
    // Abort saving, based on net data only, might try again later
    return;
  }
  
  // If a valid app support directory exists, add the
  // app's bundle ID to it to specify the final directory.
  NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
  NSURL *appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
  
  // Save the according content type
  NSURL *dataFileURL;
  error = nil;
  NSData *contentData;
  switch (type) {
    // News content
    case EurukoContentTypeNews:
      dataFileURL = [appDirectory URLByAppendingPathComponent:@"news.xml"];
      contentData = [NSPropertyListSerialization dataWithPropertyList:self.newsContent format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
      break;
      
    // Agenda content
    case EurukoContentTypeAgenda:
      dataFileURL = [appDirectory URLByAppendingPathComponent:@"agenda.xml"];
      contentData = [NSPropertyListSerialization dataWithPropertyList:self.agendaContent format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
      break;
      
    // Speakers content
    case EurukoContentTypeSpeakers:
      dataFileURL = [appDirectory URLByAppendingPathComponent:@"speakers.xml"];
      contentData = [NSPropertyListSerialization dataWithPropertyList:self.speakersContent format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
      break;
      
    default:
      break;
  }
  // Handle Error on Serializing
  if (error) {
    NSLog(@"Save Data to Filesystem: ERROR on Serializing content type: %d, error: %@", type, error);
    // Abort saving, based on net data only, might try again later
    return;
  }
  // Save Data to File in Filesystem
  if (![contentData writeToURL:dataFileURL options:NSDataWritingAtomic error:&error]) {
    NSLog(@"Save Data to Filesystem: ERROR on Writing to filesystem content type: %d, error: %@", type, error);
    // TODO: Optional alternative strategy: Try to delete old file with deprecated content on Errors (No content if it's not the latest or always content even old one until net refresh)
  }
}

@end
