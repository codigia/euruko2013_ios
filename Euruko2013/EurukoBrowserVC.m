//
//  EurukoBrowserVC.m
//  Euruko2013
//
//  Created by George Paloukis on 1/5/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoBrowserVC.h"

@interface EurukoBrowserVC ()

@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browserBackBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browserForthBtn;

- (IBAction)backBtnTapped:(id)sender;
- (IBAction)browserBtnTapped:(id)sender;

@end

@implementation EurukoBrowserVC {
  // Page's JS loading procedures should not interfere with User's actions
  BOOL _userInitiatedRequest;
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
  self.browserBackBtn.enabled = NO;
  self.browserForthBtn.enabled = NO;
  [self.navigationController setToolbarHidden:YES animated:NO];
  // Start loading web page
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.startURL]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setWebView:nil];
  [super viewDidUnload];
}

#pragma mark - WebView Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  // Handle browser toolbar
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    [self.navigationController setToolbarHidden:NO animated:YES];
  }
  // Detect actual user's initiated requests
  if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeBackForward)
    _userInitiatedRequest = YES;
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  if (_userInitiatedRequest)
    self.pageTitle.text = @"Loading...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // Reset user initiated request flag
  _userInitiatedRequest = NO;
  
  if (self.webView.canGoBack)
    self.browserBackBtn.enabled = YES;
  else
    self.browserBackBtn.enabled = NO;
  
  if (self.webView.canGoForward)
    self.browserForthBtn.enabled = YES;
  else
    self.browserForthBtn.enabled = NO;
  
  // Fetch Page Title
  NSString *titleTxt = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  if (titleTxt && titleTxt.length > 3)
    self.pageTitle.text = titleTxt;
  else
    self.pageTitle.text = self.webView.request.URL.absoluteString;
}

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)browserBtnTapped:(id)sender {
  if (sender == self.browserBackBtn)
    [self.webView goBack];
  else if (sender == self.browserForthBtn)
    [self.webView goForward];
}

@end
