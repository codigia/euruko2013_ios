//
//  EurukoAgendaVC.h
//  Euruko2013
//
//  Created by George Paloukis on 21/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EurukoAgendaDelegate;

@interface EurukoAgendaVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *agendaContent;
@property (nonatomic) NSMutableArray *speaksContent;
@property (weak, nonatomic) id <EurukoAgendaDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)showSidemenu:(id)sender;

@end


@protocol EurukoAgendaDelegate <NSObject>
- (void)fetchAgendaContent;
@end