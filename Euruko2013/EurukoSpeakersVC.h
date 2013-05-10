//
//  EurukoSpeakersVC.h
//  Euruko2013
//
//  Created by George Paloukis on 12/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EurukoAgendaVC.h"

@interface EurukoSpeakersVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *speaksContent;
@property (weak, nonatomic) id <EurukoAgendaDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)showSidemenu:(id)sender;

@end
