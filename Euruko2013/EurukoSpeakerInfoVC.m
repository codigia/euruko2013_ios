//
//  EurukoSpeakerInfoVC.m
//  Euruko2013
//
//  Created by George Paloukis on 28/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoSpeakerInfoVC.h"
#import "EurukoBrowserVC.h"
#import "AFNetworking.h"

@interface EurukoSpeakerInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *speakerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *speakerTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *speakerAvatarImg;
@property (weak, nonatomic) IBOutlet UIWebView *spkBioWebView;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

- (IBAction)backBtnTapped:(id)sender;
- (IBAction)actionBtnTapped:(id)sender;

@end

@implementation EurukoSpeakerInfoVC {
  NSURL *_urlToBrowse;
  NSMutableDictionary *_sheetIndexes;
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
  // Check if Speaker has Twitter/Github page and display/hide Action button
  if (![self.speakerData objectForKey:@"twitter"] && ![self.speakerData objectForKey:@"github"])
    self.actionBtn.alpha = 0.0;
  
  // ActionSheet indexes
  _sheetIndexes = [NSMutableDictionary dictionaryWithCapacity:2];
  
  // Populate with speaker data
  self.speakerNameLbl.text = [self.speakerData objectForKey:@"name"];
  self.speakerTitleLbl.text = [self.speakerData objectForKey:@"title"];
  if ([self.speakerData objectForKey:@"avatar_ring"])
    [self.speakerAvatarImg setImageWithURL:[NSURL URLWithString:[self.speakerData objectForKey:@"avatar_ring"]] placeholderImage:[UIImage imageNamed:@"no_speaker.png"]];
  
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
    browserVC.mainScreenMode = NO;
	}
}

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionBtnTapped:(id)sender {
  UIActionSheet *sheet =
  [[UIActionSheet alloc] initWithTitle:@"Speaker's personal page(s)"
                              delegate:self
                     cancelButtonTitle:nil
                destructiveButtonTitle:nil
                     otherButtonTitles:nil];
    
  if ([self.speakerData objectForKey:@"twitter"]) {
    NSInteger idx = [sheet addButtonWithTitle:@"Twitter page"];
    [_sheetIndexes setObject:@"twitter" forKey:[NSNumber numberWithInteger:idx]];
  }
  if ([self.speakerData objectForKey:@"github"]) {
    NSInteger idx = [sheet addButtonWithTitle:@"Github page"];
    [_sheetIndexes setObject:@"github" forKey:[NSNumber numberWithInteger:idx]];
  }
  // Cancel button
  sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
  [_sheetIndexes setObject:@"cancel" forKey:[NSNumber numberWithInteger:sheet.cancelButtonIndex]];
  [sheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark ActionSheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  // Perform related task according ActionSheet button
  NSString *pageCode = [_sheetIndexes objectForKey:[NSNumber numberWithInteger:buttonIndex]];
  NSString *urlStr;
  if ([pageCode isEqualToString:@"cancel"])
    return;
  
  if ([pageCode isEqualToString:@"twitter"]) {
    urlStr = [NSString stringWithFormat:@"https://twitter.com/%@", [self.speakerData objectForKey:pageCode]];
  } else if ([pageCode isEqualToString:@"github"]) {
    urlStr = [NSString stringWithFormat:@"https://github.com/%@", [self.speakerData objectForKey:pageCode]];
  }
  _urlToBrowse = [NSURL URLWithString:urlStr];
  [self performSegueWithIdentifier:@"ShowBrowserViewFromSpeaker" sender:self];
}

@end
