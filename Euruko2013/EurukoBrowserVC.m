//
//  EurukoBrowserVC.m
//  Euruko2013
//
//  Created by George Paloukis on 1/5/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoBrowserVC.h"

@interface EurukoBrowserVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backBtnTapped:(id)sender;

@end

@implementation EurukoBrowserVC

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
  // Start loading web page
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.startURL]];
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

#pragma mark - Actions
- (IBAction)backBtnTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
