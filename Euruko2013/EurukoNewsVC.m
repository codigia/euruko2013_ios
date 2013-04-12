//
//  EurukoMasterViewController.m
//  Euruko2013
//
//  Created by George Paloukis on 22/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoNewsVC.h"
#import "IIViewDeckController.h"
#import "EurukoDetailViewController.h"

@interface EurukoNewsVC ()

@property (nonatomic) NSArray *newsContent;

@end

@implementation EurukoNewsVC

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  // Static creation of News Content
  self.newsContent = @[@{@"newsTitle": @"Call for Presentations is now open!",
                         @"newsBody": @"We are very excited to announce that Call for Presentations for EuRuKo 2013 is now open"},
                       @{@"newsTitle": @"Sponsorship packages online!",
                         @"newsBody": @"Boldly show your Ruby love - be a sponsor"},
                       @{@"newsTitle": @"Tickets will be available soon",
                         @"newsBody": @"Tickets will be available soon, be prepared!"},
                       @{@"newsTitle": @"Website launch on 28/01",
                         @"newsBody": @"EuRuKo (the European Ruby Conference) is an annual conference which focuses on the Ruby programming language"}];
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
  newsLbl.text = [newsArticle objectForKey:@"newsTitle"];
  
  newsLbl = (UILabel *)[cell viewWithTag:2];
  newsLbl.text = [newsArticle objectForKey:@"newsBody"];
  
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
