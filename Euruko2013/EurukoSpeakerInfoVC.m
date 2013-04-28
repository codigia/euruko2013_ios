//
//  EurukoSpeakerInfoVC.m
//  Euruko2013
//
//  Created by George Paloukis on 28/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeakerInfoVC.h"

@interface EurukoSpeakerInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *speakerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *speakerTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *speakerAvatarImg;
@property (weak, nonatomic) IBOutlet UIView *nameBorderView;

- (IBAction)backBtnTapped:(id)sender;
@end

@implementation EurukoSpeakerInfoVC

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
  // Populate with speaker data
  self.speakerNameLbl.text = [self.speakerData objectForKey:@"name"];
  self.speakerTitleLbl.text = [self.speakerData objectForKey:@"title"];
  if ([self.speakerData objectForKey:@"avatar"])
    self.speakerAvatarImg.image = [UIImage imageNamed:[self.speakerData objectForKey:@"avatar"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setSpeakerNameLbl:nil];
  [self setSpeakerTitleLbl:nil];
  [self setSpeakerAvatarImg:nil];
  [self setNameBorderView:nil];
  [super viewDidUnload];
}

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
