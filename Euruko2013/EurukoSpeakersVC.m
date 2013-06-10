//
//  EurukoSpeakersVC.m
//  Euruko2013
//
//  Created by George Paloukis on 12/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeakersVC.h"
#import "EurukoSpeakerInfoVC.h"
#import "EurukoMainVC.h"
#import "IIViewDeckController.h"
#import "AFNetworking.h"

@interface EurukoSpeakersVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *noNetBannerView;

- (IBAction)tapToRetry:(id)sender;
@end

@implementation EurukoSpeakersVC {
  // Is Network Error banner presented?
  BOOL _isNetworkBannerPresented;
}

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
  _isNetworkBannerPresented = NO;
  
	// Do any additional setup after loading the view.
  // Update Speakers Collection when content fetched from net
	[[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onContentFetched:)
                                               name:kEurukoAppNotifContentFetchedAgenda
                                             object:nil];
  // Network error, show related banner
	[[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onNetworkError:)
                                               name:kEurukoAppNotifContentNetworkError
                                             object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  _isNetworkBannerPresented = NO;
  // Fetch content from net
  [self.delegate fetchAgendaContent];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self showNetErrorBanner:NO];
}

- (void)onContentFetched:(NSNotification *)notif {
  [self.collectionView reloadData];
  [self showNetErrorBanner:NO];
}

- (void)onNetworkError:(NSNotification *)notif {
  [self showNetErrorBanner:YES];
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section;
{
  return self.speaksContent.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString *CellIdentifier = @"SpeakerCell";
	
  NSDictionary *speakerData = [self.speaksContent objectAtIndex:indexPath.row];
	
	UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	// Configure Cell
	UILabel *spkLbl = (UILabel *)[cell viewWithTag:1];
  spkLbl.text = [speakerData objectForKey:@"name"];
  
  spkLbl = (UILabel *)[cell viewWithTag:2];
  spkLbl.text = [speakerData objectForKey:@"title"];
  
  UIImageView *spkAvatar = (UIImageView *)[cell viewWithTag:3];
  if ([speakerData objectForKey:@"avatar_ring"]) {
    [spkAvatar setImageWithURL:[NSURL URLWithString:[speakerData objectForKey:@"avatar_ring"]] placeholderImage:[UIImage imageNamed:@"no_speaker.png"]];
  } else {
    spkAvatar.image = [UIImage imageNamed:@"no_speaker.png"];
  }
  
	return cell;
}

#pragma mark - Segues
// Perform Selection action using Selection triggered Segue on CollectionView cell
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"ShowSpeakerInfoView"]) {
		NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
		
		NSDictionary *selectedSpeaker = [self.speaksContent objectAtIndex:selectedIndexPath.row];
		
		EurukoSpeakerInfoVC *spkInfoVC = [segue destinationViewController];
		spkInfoVC.speakerData = selectedSpeaker;
	}
}

#pragma mark - Actions
- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)tapToRetry:(id)sender {
  [self showNetErrorBanner:NO];
  // Fetch News content from net
  [self.delegate fetchAgendaContent];
}

#pragma mark - UI related methods
- (void)showNetErrorBanner:(BOOL)show {
  if (show && !_isNetworkBannerPresented) {
    [UIView animateWithDuration:1.0 animations:^{
      self.noNetBannerView.center = CGPointMake(self.noNetBannerView.center.x, self.noNetBannerView.center.y+34);
    }];
    UIButton *retryBtn = (UIButton *)[self.noNetBannerView viewWithTag:1];
    retryBtn.enabled = YES;
    _isNetworkBannerPresented = YES;
  } else if (!show && _isNetworkBannerPresented) {
    [UIView animateWithDuration:1.0 animations:^{
      self.noNetBannerView.center = CGPointMake(self.noNetBannerView.center.x, self.noNetBannerView.center.y-34);
    }];
    UIButton *retryBtn = (UIButton *)[self.noNetBannerView viewWithTag:1];
    retryBtn.enabled = NO;
    _isNetworkBannerPresented = NO;
  }
}


- (void)viewDidUnload {
  [self setCollectionView:nil];
  [super viewDidUnload];
}

@end
