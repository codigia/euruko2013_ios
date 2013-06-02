//
//  EurukoTwitterVC.h
//  Euruko2013
//
//  Created by George Paloukis on 2/6/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EurukoTwitterVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *tweetsContent;

- (IBAction)showSidemenu:(id)sender;

@end
