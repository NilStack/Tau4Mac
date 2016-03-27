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
    return [ [ self userInfo ] objectForKey: kVideoIdentifier ];
    }

- ( NSString* ) videoName
    {
    return [ [ self userInfo ] objectForKey: kVideoName ];
    }

@dynamic playlistIdentifier;
@dynamic playlistName;
- ( NSString* ) playlistIdentifier
    {
    return [ [ self userInfo ] objectForKey: kPlaylistIdentifier ];
    }

- ( NSString* ) playlistName
    {
    return [ [ self userInfo ] objectForKey: kPlaylistName ];
    }

@dynamic channelIdentifier;
@dynamic channelName;
- ( NSString* ) channelIdentifier
    {
    return [ [ self userInfo ] objectForKey: kChannelIdentifier ];
    }

- ( NSString* ) channelName
    {
    return [ [ self userInfo ] objectForKey: kChannelName ];
    }

#pragma mark - Factory Methods

+ ( instancetype ) exposeVideoNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    // In this method, _YouTubeObject has three potential types:
    // - GTLYouTubeVideo
    // - GTLYouTubePlaylistItem 
    // - and another one is GTLYouTubeSearchResult

    NSString* videoIdentifier = nil;
    NSString* videoName = nil;

    // - If _YouTubeObject is kind of GTLYouTubeVideo, its identifier property is an NSString object encapsulated in the outermost layer.
    // - If _YouTubeObject is kind of GTLYouTubePlaylistItem, its identifier property is an NSString object encapsulated in a GTLYouTubePlaylistItemContentDetails object.
    // - If _YouTubeObject is kind of GTLYouTubeSearchResult, its identifier property is an NSString object encapsulated in a GTLYouTubeResourceId object, instead.

    @try {
    if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubeVideo class ] ] )
        videoIdentifier = [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ];
    else if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        videoIdentifier = [ _YouTubeObject valueForKeyPath: @"contentDetails.videoId" ];
    else if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
        videoIdentifier = [ [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ] JSON ][ @"videoId" ];

    // id parameter is required
    if ( !videoIdentifier )
        {
        DDLogUnexpected( @"Could not derive video identifier from the YouTube object {%@} passed by {%@}."
                       , _YouTubeObject
                       , _Poster
                       );
        return nil;
        }

    // The query path of "title" property in both JSON reps are identical
    videoName = [ _YouTubeObject valueForKeyPath: @"snippet.title" ];
    } @catch ( NSException* _Ex )
        {
        DDLogFatal( @"Captured an exception: {%@}.", _Ex );
        }

    NSNotification* notif =
        [ self notificationWithName: TauShouldExposeContentCollectionItemNotif
                             object: _Poster
                           userInfo: @{ kVideoIdentifier : videoIdentifier
                                      , kVideoName : videoName ?: @""
                                      } ];

    [ notif setContentType: TauYouTubeVideo ];
    return notif;
    }

+ ( instancetype ) exposePlaylistNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    // Because the _YouTubeObject has two potential types:
    // one is GTLYouTubePlaylist, and another one is GTLYouTubeSearchResult
    GTLObject* absIdentifierObject = nil;
    NSString* playlistId = nil;
    NSString* playlistName = nil;

    @try {
    absIdentifierObject = [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ];

    // If _YouTubeObject is kind of GTLYouTubePlaylist, its identifier property simply results in an NSString object.
    // On the other hand, if it's an instance of GTLYouTubeSearchResult, instance of GTLYouTubeResourceId instead.
    playlistId = [ absIdentifierObject isKindOfClass: [ NSString class ] ] ? absIdentifierObject : absIdentifierObject.JSON[ @"playlistId" ];

    // id parameter is required
    if ( !playlistId )
        {
        DDLogUnexpected( @"Could not derive playlist identifier from the YouTube object {%@} passed by {%@}."
                       , _YouTubeObject
                       , _Poster
                       );
        return nil;
        }

    // The query path of "title" property in both JSON reps are identical
    playlistName = [ _YouTubeObject valueForKeyPath: @"snippet.title" ];
    } @catch ( NSException* _Ex )
        {
        DDLogFatal( @"Captured an exception: {%@}.", _Ex );
        }

    NSNotification* notif =
        [ self notificationWithName: TauShouldExposeContentCollectionItemNotif
                             object: _Poster
                           userInfo: @{ kPlaylistIdentifier : playlistId
                                      , kPlaylistName : playlistName ?: @""
                                      } ];

    [ notif setContentType: TauYouTubePlayList ];
    return notif;
    }

+ ( instancetype ) exposeChannelNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    // Because the _YouTubeObject has two potential types:
    // one is GTLYouTubeChannel, and another one is GTLYouTubeSearchResult
    GTLObject* absIdentifierObject = nil;
    NSString* channelId = nil;
    NSString* channelName = nil;

    @try {
    absIdentifierObject = [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ];

    // If _YouTubeObject is kind of GTLYouTubeChannel, its identifier property simply results in an NSString object.
    // On the other hand, if it's an instance of GTLYouTubeSearchResult, instance of GTLYouTubeResourceId instead.
    channelId = [ absIdentifierObject isKindOfClass: [ NSString class ] ] ? absIdentifierObject : absIdentifierObject.JSON[ @"channelId" ];

    // id parameter is required
    if ( !channelId )
        {
        DDLogUnexpected( @"Could not derive channel identifier from the YouTube object {%@} passed by {%@}."
                       , _YouTubeObject
                       , _Poster
                       );
        return nil;
        }

    // The query path of "title" property in both JSON reps are identical
    channelName = [ _YouTubeObject valueForKeyPath: @"snippet.title" ];
    } @catch ( NSException* _Ex )
        {
        DDLogFatal( @"Captured an exception: {%@}.", _Ex );
        }

    NSNotification* notif =
        [ self notificationWithName: TauShouldExposeContentCollectionItemNotif
                             object: _Poster
                           userInfo: @{ kChannelIdentifier : channelId
                                      , kChannelName : channelName ?: @""
                                      } ];

    [ notif setContentType: TauYouTubeChannel ];
    return notif;

    }

@end // NSNotification + TauShouldExposeCollectionItemNotif