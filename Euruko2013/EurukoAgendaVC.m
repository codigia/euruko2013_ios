//
//  EurukoAgendaVC.m
//  Euruko2013
//
//  Created by George Paloukis on 21/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoAgendaVC.h"
#import "IIViewDeckController.h"

@interface EurukoAgendaVC ()

@property (nonatomic) NSArray *agendaContent;
@property (nonatomic) NSArray *speaksContent;
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
  self.agendaData = [NSMutableArray arrayWithCapacity:20];
  
//  {
//    "start" : 1349619316,
//    "end" : 1349621416,
//    "speaker_id" : "Matz",
//    "title" : "Keynote",
//    "descr" : "This will rock your world! HTML formatting",
//  },
//  {
//    "start" : 1349700616,
//    "end" : 1349704216,
//    "title" : "Lunch break",
//    "descr" : "Eat as much as you can! HTML formatting",
//  }
  // Static creation of Speakers content
  self.agendaContent = @[@{@"start": @"1372415400",
                           @"end": @"1372415400",
                           @"speaker_id": @"Matz",
                           @"title": @"Ruby dev! The \"Why\" and the \"How\"!",
                           @"descr": @"This will rock your world! HTML formatting."},
                         @{@"start": @"1372419300",
                           @"end": @"1372419300",
                           @"speaker_id": @"Koichi",
                           @"title": @"The Ruby Keynote",
                           @"descr": @"This will keynote your world! HTML formatting."},
                         @{@"start": @"1372441500",
                           @"end": @"1372441500",
                           @"speaker_id": @"Klabnik",
                           @"title": @"Time Travel with Ruby",
                           @"descr": @"This will travel your world! HTML formatting."}];
  
  // Static creation of Speakers content
  self.speaksContent = @[@{@"id": @"Matz",
                           @"name": @"Yukihiro “Matz” Matsumoto",
                           @"title": @"Ruby chief architect",
                           @"avatar": @"spk01.png",
                           @"bio": @"Yukihiro “Matz” Matsumoto is the mastermind behind the inception of Ruby. Since 1993 he has been designing our precious jewel up to its latest 2.0 version. Meanwhile he has been working on mruby, a lightweight Ruby implementation. This summer, he will be celebrating with us the 20th anniversary of Ruby."},
                         @{@"id": @"Koichi",
                           @"name": @"Koichi Sasada",
                           @"title": @"Ruby core commiter (CRuby's VM, YARV)",
                           @"avatar": @"spk02.png",
                           @"bio": @"Koichi knows the inside outs of the Ruby VM. He has developed YARV (Yet another Ruby VM) which became the official Ruby VM when Ruby 1.9 was released. We believe he will give lots of insights in the Ruby VM, the new performance improments in Ruby 2.0 and will hint at the future of the Ruby VM."},
                         @{@"id": @"Klabnik",
                           @"name": @"Steve Klabnik",
                           @"title": @"Instructor & Open Source lead",
                           @"avatar": @"spk03.png",
                           @"bio": @"Steve enjoys turning coffee into code, writing, philosophy, and physical activity. He is a contributor to many high visibility open source projects such as Sinatra, Resque, Rubinius and of course the venerable Ruby on Rails web framework. His talks are always insightful and inspiring. We shouldn't expect anything less for EuRuKo."}];
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

#pragma mark - Data processing
- (void)prepareData {
  if (self.agendaData.count > 0)
    [self.agendaData removeAllObjects];
  
  for (NSDictionary *aAgendaItem in self.agendaContent) {
    NSMutableDictionary *theAgendaObj = [NSMutableDictionary dictionaryWithCapacity:5];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"start"] forKey:@"start"];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"end"] forKey:@"end"];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"speaker_id"] forKey:@"speaker_id"];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"title"] forKey:@"title"];
    [theAgendaObj setObject:[aAgendaItem objectForKey:@"descr"] forKey:@"descr"];
    
    // References to speaker item
    for (NSDictionary *aSpkData in self.speaksContent) {
      if ([[aSpkData objectForKey:@"id"] isEqualToString:[aAgendaItem objectForKey:@"speaker_id"]]) {
        [theAgendaObj setObject:[aSpkData objectForKey:@"name"] forKey:@"spkName"];
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
    [theAgendaObj setObject:[NSString stringWithFormat:@"%d:%d", timeComponents.hour, timeComponents.minute] forKey:@"time"];
    
    // Add to array
    [self.agendaData addObject:theAgendaObj];
  }
  
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section;
{
  return self.agendaData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString *CellIdentifier = @"AgendaCell";
	
  NSDictionary *agendaItem = [self.agendaData objectAtIndex:indexPath.row];
  
	UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	// Configure Cell
	UILabel *sphLbl = (UILabel *)[cell viewWithTag:1];
  sphLbl.text = [agendaItem objectForKey:@"title"];
  
  sphLbl = (UILabel *)[cell viewWithTag:3];
  sphLbl.text = [agendaItem objectForKey:@"spkName"];
  
  UIImageView *spkAvatar = (UIImageView *)[cell viewWithTag:2];
  spkAvatar.image = [UIImage imageNamed:[agendaItem objectForKey:@"spkAvatar"]];
  
  sphLbl = (UILabel *)[cell viewWithTag:4];
  sphLbl.text = [agendaItem objectForKey:@"time"];
  
	return cell;
}

#pragma mark -
- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)viewDidUnload {
  [self setAgendaCollView:nil];
  [super viewDidUnload];
}
@end
