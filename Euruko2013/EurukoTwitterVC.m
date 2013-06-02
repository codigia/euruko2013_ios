//
//  EurukoTwitterVC.m
//  Euruko2013
//
//  Created by George Paloukis on 2/6/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoTwitterVC.h"
#import "IIViewDeckController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface EurukoTwitterVC ()

@property (nonatomic) ACAccountStore *accountStore;

@property (weak, nonatomic) IBOutlet UICollectionView *tweetsCollView;

@end

@implementation EurukoTwitterVC

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
  self.accountStore = [[ACAccountStore alloc] init];  
}

- (void)viewDidAppear:(BOOL)animated {
  if ([self userHasAccessToTwitter])
    [self fetchTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Twitter related methods
- (BOOL)userHasAccessToTwitter
{
  return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)fetchTweets {
  ACAccountType *twitterAccountType = [self.accountStore
                                       accountTypeWithAccountTypeIdentifier:
                                       ACAccountTypeIdentifierTwitter];
  [self.accountStore
   requestAccessToAccountsWithType:twitterAccountType
   options:NULL
   completion:^(BOOL granted, NSError *error) {
     if (granted) {
       NSArray *twitterAccounts =
       [self.accountStore accountsWithAccountType:twitterAccountType];
       NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
       NSDictionary *params = @{@"q" : @"#euruko"};
       SLRequest *request =
       [SLRequest requestForServiceType:SLServiceTypeTwitter
                          requestMethod:SLRequestMethodGET
                                    URL:url
                             parameters:params];
       
       //  Attach an account to the request
       [request setAccount:[twitterAccounts lastObject]];
       
       //  Step 3:  Execute the request
       [request performRequestWithHandler:^(NSData *responseData,
                                            NSHTTPURLResponse *urlResponse,
                                            NSError *error) {
         if (responseData) {
           if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
             NSError *jsonError;
             NSDictionary *timelineData =
             [NSJSONSerialization
              JSONObjectWithData:responseData
              options:NSJSONReadingAllowFragments error:&jsonError];
             
             if (timelineData) {
               NSLog(@"Timeline Response: %@\n", timelineData);
             }
             else {
               // Our JSON deserialization went awry
               NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
             }
           }
           else {
             // The server did not respond successfully... were we rate-limited?
             NSLog(@"The response status code is %d", urlResponse.statusCode);
           }
         }
       }];
     } else {
       // Access was not granted, or an error occurred
       NSLog(@"%@", error);
     }
   }];
}

#pragma mark - Actions
- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

@end
