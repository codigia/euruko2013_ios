//
//  EurukoMainVC.m
//  Euruko2013
//
//  Created by George Paloukis on 25/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoMainVC.h"
#import "EurukoSidemenuVC.h"
#import "EurukoSpeakersVC.h"
#import "EurukoBrowserVC.h"
#import "EurukoAboutVC.h"
#import "AFNetworking.h"

NSString *const kEurukoAppNotifContentFetchedNews = @"com.codigia.ios.Euruko2013.kEurukoAppNotifContentFetchedNews";
NSString *const kEurukoAppNotifContentFetchedAgenda = @"com.codigia.ios.Euruko2013.kEurukoAppNotifContentFetchedAgenda";
NSString *const kEurukoAppNotifContentNetworkError = @"com.codigia.ios.Euruko2013.kEurukoAppNotifContentNetworkError";

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

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		// Initialize Data arrays
    self.newsContent = [NSMutableArray arrayWithCapacity:5];
    self.agendaContent = [NSMutableArray arrayWithCapacity:5];
    self.speakersContent = [NSMutableArray arrayWithCapacity:5];
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

#pragma mark - Net Tasks related methods
- (void)doEurukoNetTask:(EurukoNetTask)task {
  NSMutableString *urlPath = [NSMutableString stringWithString:serverURL];
  AFJSONRequestOperation *operation;
  if (task == EurukoNetTaskFetchNews) {
    [urlPath appendString:@"/news.json.php"];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      NSLog(@"Net Task: News content success!");
      [self newsContFetched:[JSON valueForKeyPath:@"news"]];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
      NSLog(@"Fetching News content ERROR: %@", error);
      // Alert Error message only if news content is empty (first run)
      // TODO: Display No Network connection banner
      //if (self.newsContent.count == 0) {
        //[self alertMsg:@"Network Error: Server is not reachable! Check your network connection or try again later."];
      // Post related Notification
      [[NSNotificationCenter defaultCenter] postNotificationName:kEurukoAppNotifContentNetworkError object:self];
      //}
    }];
  } else if (task == EurukoNetTaskFetchAgenda) {
    [urlPath appendString:@"/agenda.json.php"];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      NSLog(@"Net Task: Agenda content success!");
      [self agendaContFetched:[JSON valueForKeyPath:@"agenda"] withSpeakers:[JSON valueForKeyPath:@"speakers"]];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
      NSLog(@"Fetching Agenda/Speakers content ERROR: %@", error);
      // Alert Error message only if agenda/speakers content is empty (first run)
      if (self.agendaContent.count == 0) {
        [self alertMsg:@"Network Error: Server is not reachable! Check your network connection or try again later."];
      }
    }];
  }

  [operation start];
}

- (void)newsContFetched:(NSArray *)newsData {
  [self.newsContent removeAllObjects];
  [self.newsContent addObjectsFromArray:newsData];
  
  // TODO: Sort News items based on date
  
  // Post related Notification
  [[NSNotificationCenter defaultCenter] postNotificationName:kEurukoAppNotifContentFetchedNews object:self];
  
  // Save News content to Filesystem
  [self saveDataToFileSystemForContentType:EurukoContentTypeNews];
}

- (void)agendaContFetched:(NSArray *)agendaData withSpeakers:(NSArray *)speakersData {
  [self.agendaContent removeAllObjects];
  [self.agendaContent addObjectsFromArray:agendaData];
  [self.speakersContent removeAllObjects];
  [self.speakersContent addObjectsFromArray:speakersData];
  
  // Post related Notification
  [[NSNotificationCenter defaultCenter] postNotificationName:kEurukoAppNotifContentFetchedAgenda object:self];
  
  // Save Agenda/Speakers content to Filesystem
  [self saveDataToFileSystemForContentType:EurukoContentTypeAgenda];
  [self saveDataToFileSystemForContentType:EurukoContentTypeSpeakers];
}

#pragma mark - Net Tasks Delegate methods
- (void)fetchNewsContent {
  [self doEurukoNetTask:EurukoNetTaskFetchNews];
}

- (void)fetchAgendaContent {
  [self doEurukoNetTask:EurukoNetTaskFetchAgenda];
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
  EurukoAgendaVC *agendaVC = (EurukoAgendaVC *)[storyboard instantiateViewControllerWithIdentifier:@"agendaViewController"];
  agendaVC.agendaContent = self.agendaContent;
  agendaVC.speaksContent = self.speakersContent;
  agendaVC.delegate = self;
  [self pushViewController:agendaVC animated:NO];
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
  spkVC.speaksContent = self.speakersContent;
  spkVC.delegate = self;
  [self pushViewController:spkVC animated:NO];
}

// Menu Item: Twitter
- (void)showTwitter {
  //if ([self.topViewController isKindOfClass:[EurukoBrowserVC class]])
  //  return;
  
//  for (UIViewController *theVC in self.viewControllers) {
//    if ([theVC isKindOfClass:[EurukoBrowserVC class]]) {
//      [self popToViewController:theVC animated:NO];
//      return;
//    }
//  }
  
  UIStoryboard *storyboard = self.storyboard;
  EurukoBrowserVC *browserVC = (EurukoBrowserVC *)[storyboard instantiateViewControllerWithIdentifier:@"browserViewController"];
  browserVC.startURL = [NSURL URLWithString:@"https://twitter.com/search?q=%23euruko"];
  browserVC.mainScreenMode = YES;
  [self pushViewController:browserVC animated:NO];
}

// Menu Item: About
- (void)showAbout {
  if ([self.topViewController isKindOfClass:[EurukoAboutVC class]])
    return;
  
  for (UIViewController *theVC in self.viewControllers) {
    if ([theVC isKindOfClass:[EurukoAboutVC class]]) {
      [self popToViewController:theVC animated:NO];
      return;
    }
  }
  
  UIStoryboard *storyboard = self.storyboard;
  EurukoAboutVC *aboutVC = (EurukoAboutVC *)[storyboard instantiateViewControllerWithIdentifier:@"aboutViewController"];
  [self pushViewController:aboutVC animated:NO];
}

/*!
 @method
 @abstract
 Performs each Action according SideMenu Item selection
 */
- (void)performMenuActionWithId:(NSInteger)menuItemId {
  // Perform Menu Item action
  switch (menuItemId) {
      // News Menu item
    case 0:
      [self showNews];
      break;
      
      // Agenda Menu item
    case 1:
      [self showAgenda];
      break;
      
      // Speakers Menu item
    case 2:
      [self showSpeakers];
      break;
      
      // Twitter Menu item
    case 3:
      [self showTwitter];
      break;
      
      // About Menu item
    case 4:
      [self showAbout];
      break;
      
    case 5:
      
      break;
      
    default:
      break;
  }
}

#pragma mark - Error Handling methods
// Alert String messages
- (void)alertMsg:(NSString *)msg
{
  UIAlertView *alertView = [[UIAlertView alloc]
                            initWithTitle:@"Error"
                            message:msg
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
  [alertView show];
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
    [self.newsContent removeAllObjects];
    [self.newsContent addObjectsFromArray:[NSPropertyListSerialization propertyListWithData:contentData options:NSPropertyListImmutable format:NULL error:&error]];
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
  // Create that app directory
  if (![sharedFM createDirectoryAtURL:appDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
    NSLog(@"Save Data to Filesystem: ERROR on Creating App Directory, error: %@", error);
  }
  
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
