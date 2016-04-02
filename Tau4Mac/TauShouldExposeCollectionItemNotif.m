//
//  TauShouldExposeCollectionItemNotif.m
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauShouldExposeCollectionItemNotif.h"

// NSNotification + TauShouldExposeCollectionItemNotif
@implementation NSNotification ( TauShouldExposeCollectionItemNotif )

NSString static* const kYouTubeObjectIdentifier = @"kYouTubeObjectIdentifier";
NSString static* const kYouTubeObjectName = @"kYouTubeObjectName";

void static* const kContentTypeAssocKey = @"kContentTypeAssocKey";

@dynamic contentType;
- ( TauYouTubeContentType ) contentType
    {
    return ( TauYouTubeContentType )[ objc_getAssociatedObject( self, &kContentTypeAssocKey ) integerValue ];
    }

- ( void ) setContentType: ( TauYouTubeContentType )_New
    {
    objc_setAssociatedObject( self, &kContentTypeAssocKey, @( _New ), OBJC_ASSOCIATION_COPY );
    }

@dynamic videoIdentifier;
@dynamic videoName;
- ( NSString* ) videoIdentifier
    {
    return ( self.contentType == TauYouTubeVideo ) ? [ self.userInfo objectForKey: kYouTubeObjectIdentifier ] : nil;
    }

- ( NSString* ) videoName
    {
    return ( self.contentType == TauYouTubeVideo ) ? [ self.userInfo objectForKey: kYouTubeObjectName ] : nil;
    }

@dynamic playlistIdentifier;
@dynamic playlistName;
- ( NSString* ) playlistIdentifier
    {
    return ( self.contentType == TauYouTubePlayList ) ? [ self.userInfo objectForKey: kYouTubeObjectIdentifier ] : nil;
    }

- ( NSString* ) playlistName
    {
    return ( self.contentType == TauYouTubePlayList ) ? [ self.userInfo objectForKey: kYouTubeObjectName ] : nil;
    }

@dynamic channelIdentifier;
@dynamic channelName;
- ( NSString* ) channelIdentifier
    {
    return ( self.contentType == TauYouTubeChannel ) ? [ self.userInfo objectForKey: kYouTubeObjectIdentifier ] : nil;
    }

- ( NSString* ) channelName
    {
    return ( self.contentType == TauYouTubeChannel ) ? [ self.userInfo objectForKey: kYouTubeObjectName ] : nil;
    }

#pragma mark - Factory Methods

+ ( instancetype ) exposeYouTubeContentNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    NSString* identifier = nil;
    NSString* name = nil;

    @try {
    identifier = _YouTubeObject.tauEssentialIdentifier;
    name = _YouTubeObject.tauEssentialTitle;
    } @catch ( NSException* _Ex )
        {
        DDLogFatal( @"Captured an exception: {%@}.", _Ex );
        }

    // id parameter is required
    if ( !identifier )
        {
        DDLogUnexpected( @"Could not derive the identifier from the YouTube object {%@} passed by {%@}."
                       , _YouTubeObject
                       , _Poster
                       );
        return nil;
        }

    NSNotification* notif =
        [ self notificationWithName: TauShouldExposeContentCollectionItemNotif
                             object: _Poster
                           userInfo: @{ kYouTubeObjectIdentifier : identifier
                                      , kYouTubeObjectName : name ?: @""
                                      } ];

    [ notif setContentType: _YouTubeObject.tauContentType ];
    return notif;
    }

@end // NSNotification + TauShouldExposeCollectionItemNotif