//
//  EurukoMasterViewController.m
//  Euruko2013
//
//  Created by George Paloukis on 22/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoNewsVC.h"
#import "EurukoBrowserVC.h"
#import "EurukoMainVC.h"
#import "IIViewDeckController.h"

@interface EurukoNewsVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *newsCollView;

@end

@implementation EurukoNewsVC

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  // Update News Collection when news fetched from net
	[[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onContentFetched:)
                                               name:kEurukoAppNotifContentFetchedNews
                                             object:nil];
  // Static creation of News Content
//  self.newsContent = @[@{@"time": @"1366218000",
//                         @"title": @"Persado is our first Helios sponsor!"},
//                       @{@"time": @"1365872400",
//                         @"title": @"Countdown for 2nd ticket batch started!",
//                         @"link" : @"http://euruko2013.org/blog/2013-04-12-above-and-beyond/"},
//                       @{@"time": @"1365786000",
//                         @"title": @"20 supporter tickets will be available",
//                         @"link" : @"http://euruko2013.org/blog/2013-04-12-more-tickets-more-timezones-more-fun/"}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  // Fetch News content from net
  [self.delegate fetchNewsContent];
}

- (void)onContentFetched:(NSNotification *)notif {
  [self.newsCollView reloadData];
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section;
{
  return self.newsContent.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString *CellIdentifier = @"NewsCell";
	
  NSDictionary *newsArticle = [self.newsContent objectAtIndex:indexPath.row];
	
	UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	// Configure Cell
	UILabel *newsLbl = (UILabel *)[cell viewWithTag:1];
  newsLbl.text = [newsArticle objectForKey:@"title"];
  
  // Day/Month display
  NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[[newsArticle objectForKey:@"time"] doubleValue]];
  NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.locale = usLocale;
  [dateFormatter setDateFormat:@"MMM"];
  
  newsLbl = (UILabel *)[cell viewWithTag:4];
  newsLbl.text = [dateFormatter stringFromDate:startDate];
  
  [dateFormatter setDateFormat:@"d"];
  
  newsLbl = (UILabel *)[cell viewWithTag:3];
  newsLbl.text = [dateFormatter stringFromDate:startDate];
  
  // Mark for existed link
  UIView *linkMark = [cell viewWithTag:2];
  if ([newsArticle objectForKey:@"link"])
    linkMark.alpha = 1.0;
  else
    linkMark.alpha = 0.0;
  
	return cell;
}

#pragma mark - Collection view Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *newsArticle = [self.newsContent objectAtIndex:indexPath.row];
  if ([newsArticle objectForKey:@"link"])
    return YES;
  else
    return NO;
}

#pragma mark - Actions
- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - Segues
// Perform Selection action using Selection triggered Segue on CollectionView cell
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"ShowBrowserViewFromNews"]) {
		NSIndexPath *selectedIndexPath = [[self.newsCollView indexPathsForSelectedItems] objectAtIndex:0];
		
		NSDictionary *selectedNews = [self.newsContent objectAtIndex:selectedIndexPath.row];
		
		EurukoBrowserVC *browserVC = [segue destinationViewController];
		browserVC.startURL = [NSURL URLWithString:[selectedNews objectForKey:@"link"]];
	}
}

- (void)viewDidUnload {
  [self setMenuBtn:nil];
  [self setNewsCollView:nil];
  [super viewDidUnload];
}

@end
