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
    identifier = [ self identifierOfYouTubeObject_: _YouTubeObject ];
    name = [ self nameOfYouTubeObject_: _YouTubeObject ];
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
                                      , kYouTubeObjectName : identifier ?: @""
                                      } ];

    [ notif setContentType: _YouTubeObject.tauContentType ];
    return notif;
    }

#pragma mark - Private

+ ( NSString* ) identifierOfYouTubeObject_: ( GTLObject* )_YouTubeObject
    {
    NSString* identifier = nil;

    // If _YouTubeObject is instance of ...

    /* one of three classes below:

     * GTLYouTubeVideo
     * GTLYouTubeChannel
     * GTLYouTubePlaylist

     * its identifier property is simply an NSString object encapsulated in the outermost layer.
     */
    if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubeVideo class ] ]
            || [ _YouTubeObject isKindOfClass: [ GTLYouTubeChannel class ] ]
            || [ _YouTubeObject isKindOfClass: [ GTLYouTubePlaylist class ] ] )
        identifier = [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ];

    /* GTLYouTubePlaylistItem, its identifier property is an NSString object encapsulated in a GTLYouTubePlaylistItemContentDetails object.
     */
    else if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        identifier = [ _YouTubeObject valueForKeyPath: @"contentDetails.videoId" ];

    /* GTLYouTubeSearchResult, its identifier property is an NSString object encapsulated in a GTLYouTubeResourceId object, instead.
     */
    else if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
        {
        GTLYouTubeResourceId* resourceIdentifier = [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ];
        NSDictionary* jsonDict = [ resourceIdentifier JSON ];
        identifier = [ jsonDict objectForKey: [ [ resourceIdentifier.kind componentsSeparatedByString: @"#" ].lastObject stringByAppendingString: @"Id" ] ];
        }

    return identifier;
    }

+ ( NSString* ) nameOfYouTubeObject_: ( GTLObject* )_YouTubeObject
    {
    return [ _YouTubeObject valueForKeyPath: @"snippet.title" ];
    }

@end // NSNotification + TauShouldExposeCollectionItemNotif