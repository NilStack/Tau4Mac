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

    // - If _YouTubeObject is kind of GTLYouTubeVideo, its identifier property is an NSString object encapsulated in the outermost layer.
    // - If _YouTubeObject is kind of GTLYouTubePlaylistItem, its identifier property is an NSString object encapsulated in a GTLYouTubePlaylistItemContentDetails object.
    // - If _YouTubeObject is kind of GTLYouTubeSearchResult, its identifier property is an NSString object encapsulated in a GTLYouTubeResourceId object, instead.

    if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubeVideo class ] ] )
        videoIdentifier = [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ];
    else if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        videoIdentifier = [ _YouTubeObject valueForKeyPath: @"contentDetails.videoId" ];
    else if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
        videoIdentifier = [ [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ] JSON ][ @"videoId" ];

    // The query path of "title" property in both JSON reps are identical
    NSString* videoName = [ _YouTubeObject valueForKeyPath: @"snippet.title" ];

    NSNotification* notif =
        [ self notificationWithName: TauShouldExposeContentCollectionItemNotif
                             object: _Poster
                           userInfo: @{ kVideoIdentifier : videoIdentifier
                                      , kVideoName : videoName
                                      } ];
    objc_setAssociatedObject( notif
                            , &kContentTypeAssocKey
                            , @( TauYouTubeVideo )
                            , OBJC_ASSOCIATION_RETAIN
                            );
    return notif;
    }

+ ( instancetype ) exposePlaylistNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    // Because the _YouTubeObject has two potential types:
    // one is GTLYouTubePlaylist, and another one is GTLYouTubeSearchResult
    GTLObject* identifierObject = [ _YouTubeObject valueForKey: TAU_KEY_OF_SEL( @selector( identifier ) ) ];

    // If _YouTubeObject is kind of GTLYouTubePlaylist, its identifier property simply results in an NSString object.
    // On the other hand, if it's an instance of GTLYouTubeSearchResult, instance of GTLYouTubeResourceId instead.
    NSString* playlistId = [ identifierObject isKindOfClass: [ NSString class ] ] ? identifierObject : identifierObject.JSON[ @"playlistId" ];

    // The query path of "title" property in both JSON reps are identical
    NSString* playlistName = [ _YouTubeObject valueForKeyPath: @"snippet.title" ];

    NSNotification* notif =
        [ self notificationWithName: TauShouldExposeContentCollectionItemNotif
                             object: _Poster
                           userInfo: @{ kPlaylistIdentifier : playlistId
                                      , kPlaylistName : playlistName
                                      } ];
    objc_setAssociatedObject( notif
                            , &kContentTypeAssocKey
                            , @( TauYouTubePlayList )
                            , OBJC_ASSOCIATION_RETAIN
                            );
    return notif;
    }

+ ( instancetype ) exposeChannelNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    return nil;
    }

@end // NSNotification + TauShouldExposeCollectionItemNotif