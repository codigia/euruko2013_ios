//
//  EurukoSpeechVC.m
//  Euruko2013
//
//  Created by George Paloukis on 28/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeechVC.h"

@interface EurukoSpeechVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *speakerAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *speechTitleLbl;

- (IBAction)backBtnTapped:(id)sender;
@end

@implementation EurukoSpeechVC

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
  // Populate with speech data
  self.timeLbl.text = [self.speechData objectForKey:@"time"];
  self.speechTitleLbl.text = [self.speechData objectForKey:@"title"];
  if ([self.speakerData objectForKey:@"avatar"])
    self.speakerAvatarImg.image = [UIImage imageNamed:[self.speakerData objectForKey:@"avatar"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setTimeLbl:nil];
  [self setSpeakerAvatarImg:nil];
  [self setSpeechTitleLbl:nil];
  [super viewDidUnload];
}

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
