//
//  EurukoSidemenuVC.h
//  Euruko2013
//
//  Created by George Paloukis on 24/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EurukoSidemenuViewControllerDelegate;

@interface EurukoSidemenuVC : UITableViewController

@property (weak, nonatomic) id <EurukoSidemenuViewControllerDelegate> delegate;

@end


@protocol EurukoSidemenuViewControllerDelegate <NSObject>
- (void)performMenuActionWithId:(NSInteger)menuItemId;
@end