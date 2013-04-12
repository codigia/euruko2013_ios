//
//  EurukoSpeakersVC.m
//  Euruko2013
//
//  Created by George Paloukis on 12/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeakersVC.h"

@interface EurukoSpeakersVC ()

@property (nonatomic) NSArray *speaksContent;

@end

@implementation EurukoSpeakersVC

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

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section;
{
  return self.speaksContent.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString *CellIdentifier = @"SpeakerCell";
	
	// Fetch RoomMsg according indexPath
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

@end
