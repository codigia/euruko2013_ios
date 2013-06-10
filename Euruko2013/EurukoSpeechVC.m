//
//  EurukoSpeechVC.m
//  Euruko2013
//
//  Created by George Paloukis on 28/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeechVC.h"
#import "EurukoSpeakerInfoVC.h"
#import "EurukoBrowserVC.h"
#import "AFNetworking.h"

@interface EurukoSpeechVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *speakerAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *speechTitleLbl;
@property (weak, nonatomic) IBOutlet UIWebView *speechDescrWebv;

- (IBAction)backBtnTapped:(id)sender;
@end

@implementation EurukoSpeechVC {
  NSURL *_urlToBrowse;
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
	// Do any additional setup after loading the view.
  // Populate with speech data
  self.timeLbl.text = [self.speechData objectForKey:@"time"];
  self.speechTitleLbl.text = [self.speechData objectForKey:@"title"];
  if ([self.speakerData objectForKey:@"avatar_ring"])
    [self.speakerAvatarImg setImageWithURL:[NSURL URLWithString:[self.speakerData objectForKey:@"avatar_ring"]] placeholderImage:[UIImage imageNamed:@"no_speaker.png"]];
  
  // Speech description in WebView
  NSString* descrString = [NSString stringWithFormat:
                           @"<html><head><style>body {background-color:#D3D3D3;font-family:\"Verdana\", sans-serif;font-style:normal;font-size:13px;font-weight:500;color:#090909;text-align:justify;}</style></head><body><div>%@</div></body></html>", [self.speechData objectForKey:@"descr"]];
  [self.speechDescrWebv loadHTMLString:descrString baseURL:nil];
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
  [self setSpeechDescrWebv:nil];
  [super viewDidUnload];
}

#pragma mark - WebView Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  // Open URL to Browser view and not inside this webview
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    _urlToBrowse = request.URL;
    [self performSegueWithIdentifier:@"ShowBrowserViewFromSpeech" sender:self];
    return NO;
  }
  return YES;
}

#pragma mark - Segues
// Show Speaker Info screen
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"ShowSpeakerInfoViewFromSpeech"]) {
    EurukoSpeakerInfoVC *spkInfoVC = [segue destinationViewController];
		spkInfoVC.speakerData = self.speakerData;
	} else if ([[segue identifier] isEqualToString:@"ShowBrowserViewFromSpeech"]) {
    EurukoBrowserVC *browserVC = [segue destinationViewController];
		browserVC.startURL = _urlToBrowse;
    browserVC.mainScreenMode = NO;
	}
}

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
