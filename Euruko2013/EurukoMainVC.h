//
//  EurukoMainVC.h
//  Euruko2013
//
//  Created by George Paloukis on 25/2/13.
//  Copyright (c) 2013 Codigia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EurukoNewsVC.h"
#import "EurukoAgendaVC.h"

typedef enum EurukoContentType {
  /*! News content (stored file: news.xml) */
  EurukoContentTypeNews       = 1,
  /*! Agenda content (stored file: agenda.xml) */
  EurukoContentTypeAgenda     = 2,
  /*! Speakers content (stored file: speakers.xml) */
  EurukoContentTypeSpeakers   = 3
} EurukoContentType;

typedef enum EurukoNetTask {
  /*! Fetch News content */
  EurukoNetTaskFetchNews    = 1,
  /*! Fetch Agenda (and Speakers) content */
  EurukoNetTaskFetchAgenda  = 2
} EurukoNetTask;

// Euruko app notifications
// News content fetched from net
extern NSString *const kEurukoAppNotifContentFetchedNews;
// Agenda/Speakers content fetched from net
extern NSString *const kEurukoAppNotifContentFetchedAgenda;

@interface EurukoMainVC : UINavigationController <EurukoNewsDelegate, EurukoAgendaDelegate>

@property (nonatomic) NSMutableArray *newsContent;
@property (nonatomic) NSMutableArray *agendaContent;
@property (nonatomic) NSMutableArray *speakersContent;

@end
