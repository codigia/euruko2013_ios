//
//  EurukoMainVC.h
//  Euruko2013
//
//  Created by George Paloukis on 25/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum EurukoContentType {
  /*! News content (stored file: news.xml) */
  EurukoContentTypeNews       = 1,
  /*! Agenda content (stored file: agenda.xml) */
  EurukoContentTypeAgenda     = 2,
  /*! Speakers content (stored file: speakers.xml) */
  EurukoContentTypeSpeakers   = 3
} EurukoContentType;


@interface EurukoMainVC : UINavigationController

@property (nonatomic) NSArray *newsContent;
@property (nonatomic) NSArray *agendaContent;
@property (nonatomic) NSArray *speakersContent;

@end
