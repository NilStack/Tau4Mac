//
//  TauShouldExposeCollectionItemNotif.h
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// NSNotification + TauShouldExposeCollectionItemNotif
@interface NSNotification ( TauShouldExposeCollectionItemNotif )

#pragma mark - Additions to Tau Collection View Item

@property ( assign, readonly ) TauYouTubeContentType contentType;

@property ( copy, readwrite ) NSString* videoIdentifier;
@property ( copy, readwrite ) NSString* videoName;

@property ( copy, readwrite ) NSString* playlistIdentifier;
@property ( copy, readwrite ) NSString* playlistName;

@property ( copy, readwrite ) NSString* channelIdentifier;
@property ( copy, readwrite ) NSString* channelName;

#pragma mark - Factory Methods

+ ( instancetype ) exposeYouTubeContentNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster;

@end // NSNotification + TauShouldExposeCollectionItemNotif