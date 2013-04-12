//
//  EurukoSpeakersVC.h
//  Euruko2013
//
//  Created by George Paloukis on 12/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EurukoSpeakersVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)showSidemenu:(id)sender;

@end
