//
//  EurukoSpeakerInfoVC.h
//  Euruko2013
//
//  Created by George Paloukis on 28/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EurukoSpeakerInfoVC : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic) NSDictionary *speakerData;

@end
