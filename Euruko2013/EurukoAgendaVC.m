//
//  EurukoAgendaVC.m
//  Euruko2013
//
//  Created by George Paloukis on 21/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoAgendaVC.h"
#import "EurukoSpeechVC.h"
#import "EurukoMainVC.h"
#import "IIViewDeckController.h"
#import "AFNetworking.h"

@interface EurukoAgendaVC ()

@property (nonatomic) NSMutableArray *agendaData;

@property (weak, nonatomic) IBOutlet UICollectionView *agendaCollView;

@end

@implementation EurukoAgendaVC

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
  self.agendaData = [NSMutableArray arrayWithCapacity:2];
  
  // Update News Collection when news fetched from net
	[[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onContentFetched:)
                                               name:kEurukoAppNotifContentFetchedAgenda
                                             object:nil];
  // Fetch content from net
  [self.delegate fetchAgendaContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [self prepareData];
  [self.agendaCollView reloadData];
}

- (void)onContentFetched:(NSNotification *)notif {
  [self prepareData];
  [self.agendaCollView reloadData];
}

#pragma mark - Data processing
- (void)prepareData {
  if (self.agendaData.count > 0)
    [self.agendaData removeAllObjects];
  
  for (NSDictionary *aAgendaItem in self.agendaContent) {
    NSMutableDictionary *theAgendaObj = [NSMutableDictionary dictionaryWithCapacity:5];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"start"] forKey:@"start"];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"end"] forKey:@"end"];
    if ([aAgendaItem objectForKey:@"speaker_id"])
      [theAgendaObj setObject:[aAgendaItem objectForKey:@"speaker_id"] forKey:@"speaker_id"];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"title"] forKey:@"title"];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"descr"] forKey:@"descr"];
    
    // References to speaker item
    for (NSDictionary *aSpkData in self.speaksContent) {
      if ([[aSpkData objectForKey:@"id"] isEqualToString:[aAgendaItem objectForKey:@"speaker_id"]]) {
        [theAgendaObj setObject:[aSpkData objectForKey:@"name"] forKey:@"spkName"];
        if ([aSpkData objectForKey:@"avatar"])
          [theAgendaObj setObject:[aSpkData objectForKey:@"avatar"] forKey:@"spkAvatar"];
        break;
      }
    }
    
    // Time display
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[[aAgendaItem objectForKey:@"start"] doubleValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *timeComponents =
    [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:startDate];
    [theAgendaObj setObject:[NSString stringWithFormat:@"%d:%.2d", timeComponents.hour, timeComponents.minute] forKey:@"time"];
    
    // Add to array
    [self.agendaData addObject:theAgendaObj];
  }
  
}

#pragma mark - Collection view Data source / Delegate
- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section;
{
  return self.agendaData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{	
  NSDictionary *agendaItem = [self.agendaData objectAtIndex:indexPath.row];
  UICollectionViewCell *cell;
  
  if ([agendaItem objectForKey:@"speaker_id"]) {
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"AgendaCell" forIndexPath:indexPath];
    // Configure Cell
    UILabel *sphLbl = (UILabel *)[cell viewWithTag:1];
    sphLbl.text = [agendaItem objectForKey:@"title"];
    
    sphLbl = (UILabel *)[cell viewWithTag:3];
    sphLbl.text = [agendaItem objectForKey:@"spkName"];
    
    UIImageView *spkAvatar = (UIImageView *)[cell viewWithTag:2];
    if ([agendaItem objectForKey:@"spkAvatar"])
      [spkAvatar setImageWithURL:[NSURL URLWithString:[agendaItem objectForKey:@"spkAvatar"]] placeholderImage:[UIImage imageNamed:@"no_speaker.png"]];
    else
      spkAvatar.image = [UIImage imageNamed:@"no_speaker.png"];
    
    sphLbl = (UILabel *)[cell viewWithTag:4];
    sphLbl.text = [agendaItem objectForKey:@"time"];
  } else {
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"AgendaCellSimple" forIndexPath:indexPath];
    // Configure Cell
    UILabel *sphLbl = (UILabel *)[cell viewWithTag:1];
    sphLbl.text = [agendaItem objectForKey:@"title"];
    
    sphLbl = (UILabel *)[cell viewWithTag:4];
    sphLbl.text = [agendaItem objectForKey:@"time"];
  }
  
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *agendaItem = [self.agendaData objectAtIndex:indexPath.row];
  
  if ([agendaItem objectForKey:@"speaker_id"])
    return CGSizeMake(320, 125);
  else
    return CGSizeMake(320, 84);
}

#pragma mark - Segues
// Perform Selection action using Selection triggered Segue on CollectionView cell
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"ShowSpeechView"]) {
		NSIndexPath *selectedIndexPath = [[self.agendaCollView indexPathsForSelectedItems] objectAtIndex:0];
		
		NSDictionary *selectedSpeech = [self.agendaData objectAtIndex:selectedIndexPath.row];
		NSDictionary *selectedSpeaker;
    
    // References to speaker item
    for (NSDictionary *aSpkData in self.speaksContent) {
      if ([[aSpkData objectForKey:@"id"] isEqualToString:[selectedSpeech objectForKey:@"speaker_id"]]) {
        selectedSpeaker = aSpkData;
        break;
      }
    }
    
		EurukoSpeechVC *speechVC = [segue destinationViewController];
		speechVC.speechData = selectedSpeech;
    speechVC.speakerData = selectedSpeaker;
	}
}

#pragma mark - Actions
- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)viewDidUnload {
  [self setAgendaCollView:nil];
  [super viewDidUnload];
}
@end
