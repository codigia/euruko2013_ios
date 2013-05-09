//
//  EurukoMasterViewController.h
//  Euruko2013
//
//  Created by George Paloukis on 22/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EurukoNewsDelegate;


@interface EurukoNewsVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *newsContent;
@property (weak, nonatomic) id <EurukoNewsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)showSidemenu:(id)sender;

@end


@protocol EurukoNewsDelegate <NSObject>
- (void)fetchNewsContent;
@end