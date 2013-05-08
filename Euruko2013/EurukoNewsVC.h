//
//  EurukoMasterViewController.h
//  Euruko2013
//
//  Created by George Paloukis on 22/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EurukoNewsVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *newsContent;

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)showSidemenu:(id)sender;

@end
