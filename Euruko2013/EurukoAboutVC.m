//
//  EurukoAboutVC.m
//  Euruko2013
//
//  Created by George Paloukis on 10/5/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import "EurukoAboutVC.h"
#import "IIViewDeckController.h"

@interface EurukoAboutVC ()

- (IBAction)showSidemenu:(id)sender;

@end

@implementation EurukoAboutVC

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

#pragma mark - Actions
- (IBAction)showSidemenu:(id)sender {
  // Show SideMenu
  [self.navigationController.viewDeckController toggleLeftViewAnimated:YES];
}

@end
