//
//  EurukoMasterViewController.m
//  Euruko2013
//
//  Created by George Paloukis on 22/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoNewsVC.h"
#import "IIViewDeckController.h"

@interface EurukoNewsVC ()

@property (nonatomic) NSArray *newsContent;

@end

@implementation EurukoNewsVC

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  // Static creation of News Content
  self.newsContent = @[@{@"time": @"1366218000",
                         @"title": @"Persado is our first Helios sponsor!"},
                       @{@"time": @"1365872400",
                         @"title": @"Countdown for 2nd ticket batch started!",
                         @"link" : @"http://euruko2013.org/blog/2013-04-12-above-and-beyond/"},
                       @{@"time": @"1365786000",
                         @"title": @"20 supporter tickets will be available",
                         @"link" : @"http://euruko2013.org/blog/2013-04-12-more-tickets-more-timezones-more-fun/"}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = _objects[indexPath.row];
        //[[segue destinationViewController] setDetailItem:object];
    }
}

- (void)viewDidUnload {
  [self setMenuBtn:nil];
  [super viewDidUnload];
}

@end
