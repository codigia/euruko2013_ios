//
//  EurukoAboutVC.m
//  Euruko2013
//
//  Created by George Paloukis on 10/5/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoAboutVC.h"
#import "EurukoBrowserVC.h"
#import "IIViewDeckController.h"

@interface EurukoAboutVC ()
@property (weak, nonatomic) IBOutlet UIButton *eurukoBtn;
@property (weak, nonatomic) IBOutlet UIButton *gaiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *codigiaBtn;

- (IBAction)showSidemenu:(id)sender;
- (IBAction)logoTapped:(id)sender;

@end

@implementation EurukoAboutVC {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues
// Show URLs to app's browser screen
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"ShowBrowserViewFromAbout"]) {
    EurukoBrowserVC *browserVC = [segue destinationViewController];
		browserVC.startURL = _urlToBrowse;
	}
}

#pragma mark - Actions
- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
  if (sender == self.eurukoBtn)
    _urlToBrowse = [NSURL URLWithString:@"http://euruko2013.org/"];
  else if (sender == self.gaiaBtn)
    _urlToBrowse = [NSURL URLWithString:@"http://www.skroutz.gr/"];
  else if (sender == self.codigiaBtn)
    _urlToBrowse = [NSURL URLWithString:@"http://euruko2013.codigia.com/?utm_source=codigia&utm_medium=iphone_app&utm_campaign=euruko2013"];
  
  [self performSegueWithIdentifier:@"ShowBrowserViewFromAbout" sender:self];
}

@end
