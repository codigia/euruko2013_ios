//
//  EurukoBrowserVC.m
//  Euruko2013
//
//  Created by George Paloukis on 1/5/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoBrowserVC.h"
#import "IIViewDeckController.h"

@interface EurukoBrowserVC ()

@property (weak, nonatomic) IBOutlet UIButton *menuBackBtn;
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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.browserBackBtn.enabled = NO;
  self.browserForthBtn.enabled = NO;
  [self.navigationController setToolbarHidden:YES animated:NO];
  self.pageTitle.text = @"Loading...";
  
  // Setup UI according screen mode
  UIImage *btnImg;
  if (self.mainScreenMode) {
    btnImg = [UIImage imageNamed:@"menubutton"];
  } else {
    btnImg = [UIImage imageNamed:@"menuback"];
  }
  [self.menuBackBtn setImage:btnImg forState:UIControlStateNormal];
  [self.menuBackBtn setImage:btnImg forState:UIControlStateHighlighted];
  [self.menuBackBtn setImage:btnImg forState:UIControlStateSelected];
  [self.menuBackBtn setImage:btnImg forState:UIControlStateDisabled];
  
  // Start loading web page
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.startURL]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.navigationController setToolbarHidden:YES animated:NO];
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

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  // Reset user initiated request flag
  _userInitiatedRequest = NO;
  
  self.pageTitle.text = @"Network Error!";
  
  NSLog(@"In-app Browser Fail Load Error: %@", error);
  
  NSString* errorString = [NSString stringWithFormat:
                           @"<html><head><title>Network Error!</title><style>body {background-color:#D3D3D3;font-family:\"Verdana\", sans-serif;font-style:normal;font-size:50px;font-weight:500;color:#090909;text-align:justify;} center {margin:30%% auto 30%%;height:40%%;width:70%%;}</style></head><body><center>Network Error! Please check your network connection or try again later.</center></body></html>"];
  [self.webView loadHTMLString:errorString baseURL:nil];
}

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  if (self.mainScreenMode)
    // Show SideMenu
    [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
  else
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)browserBtnTapped:(id)sender {
  if (sender == self.browserBackBtn)
    [self.webView goBack];
  else if (sender == self.browserForthBtn)
    [self.webView goForward];
}

@end
