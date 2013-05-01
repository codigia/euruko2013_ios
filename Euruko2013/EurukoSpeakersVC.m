//
//  EurukoSpeakersVC.m
//  Euruko2013
//
//  Created by George Paloukis on 12/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeakersVC.h"
#import "EurukoSpeakerInfoVC.h"
#import "IIViewDeckController.h"

@interface EurukoSpeakersVC ()

@property (nonatomic) NSArray *speaksContent;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
//  {
//    "id" : "Matz",
//    "name" : "Yukihiro 'Matz' Matsumoto",
//    "title" : "Ruby Chief Architect",
//    "bio" : "... bio string, HTML formatting ...",
//    "avatar" : "...URL of the image ..."
//  }
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
                           @"bio": @"Steve enjoys turning coffee into code, writing, philosophy, and physical activity. He is a contributor to many high visibility open source projects such as Sinatra, Resque, Rubinius and of course the venerable Ruby on Rails web framework. His talks are always insightful and inspiring. We shouldn't expect anything less for EuRuKo."},
                         @{@"id": @"noknown",
                           @"name": @"The Unknown",
                           @"title": @"Virtual Speaker & Blogger",
                           @"bio": @"Steve enjoys turning coffee into code, writing, philosophy, and physical activity. He is a contributor to many high visibility open source projects such as Sinatra, Resque, Rubinius and of course the venerable Ruby on Rails web framework. His talks are always insightful and inspiring. We shouldn't expect anything less for EuRuKo."}];
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
	
  NSDictionary *speakerData = [self.speaksContent objectAtIndex:indexPath.row];
	
	UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	// Configure Cell
	UILabel *spkLbl = (UILabel *)[cell viewWithTag:1];
  spkLbl.text = [speakerData objectForKey:@"name"];
  
  spkLbl = (UILabel *)[cell viewWithTag:2];
  spkLbl.text = [speakerData objectForKey:@"title"];
  
  UIImageView *spkAvatar = (UIImageView *)[cell viewWithTag:3];
  if ([speakerData objectForKey:@"avatar"]) {
    spkAvatar.image = [UIImage imageNamed:[speakerData objectForKey:@"avatar"]];
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

- (void)viewDidUnload {
  [self setCollectionView:nil];
  [super viewDidUnload];
}
@end
