//
//  EurukoSpeechVC.h
//  Euruko2013
//
//  Created by George Paloukis on 28/4/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EurukoSpeechVC : UIViewController <UIWebViewDelegate>

@property (nonatomic) NSDictionary *speechData;
@property (nonatomic) NSDictionary *speakerData;

@end
