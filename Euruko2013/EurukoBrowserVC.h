//
//  EurukoBrowserVC.h
//  Euruko2013
//
//  Created by George Paloukis on 1/5/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EurukoBrowserVC : UIViewController <UIWebViewDelegate>

@property (nonatomic) NSURL *startURL;

@end
