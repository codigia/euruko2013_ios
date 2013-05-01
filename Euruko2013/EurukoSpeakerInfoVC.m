//
//  EurukoSpeakerInfoVC.m
//  Euruko2013
//
//  Created by George Paloukis on 28/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeakerInfoVC.h"
#import "EurukoBrowserVC.h"

@interface EurukoSpeakerInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *speakerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *speakerTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *speakerAvatarImg;
@property (weak, nonatomic) IBOutlet UIWebView *spkBioWebView;

- (IBAction)backBtnTapped:(id)sender;
@end

@implementation EurukoSpeakerInfoVC {
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
  // Populate with speaker data
  self.speakerNameLbl.text = [self.speakerData objectForKey:@"name"];
  self.speakerTitleLbl.text = [self.speakerData objectForKey:@"title"];
  if ([self.speakerData objectForKey:@"avatar"])
    self.speakerAvatarImg.image = [UIImage imageNamed:[self.speakerData objectForKey:@"avatar"]];
  
  // Speaker bio in WebView
  NSString* bioString = [NSString stringWithFormat:
                           @"<html><head><style>body {background-color:#D3D3D3;font-family:\"Verdana\", sans-serif;font-style:normal;font-size:13px;font-weight:500;color:#090909;text-align:justify;}</style></head><body><div>%@</div></body></html>", [self.speakerData objectForKey:@"bio"]];
  [self.spkBioWebView loadHTMLString:bioString baseURL:nil];
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
  [self setSpkBioWebView:nil];
  [super viewDidUnload];
}

#pragma mark - WebView Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  // Open URL to Browser view and not inside this webview
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    _urlToBrowse = request.URL;
    [self performSegueWithIdentifier:@"ShowBrowserViewFromSpeaker" sender:self];
    return NO;
  }
  return YES;
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"ShowBrowserViewFromSpeaker"]) {
    EurukoBrowserVC *browserVC = [segue destinationViewController];
		browserVC.startURL = _urlToBrowse;
	}
}

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
