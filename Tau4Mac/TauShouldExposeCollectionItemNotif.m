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

#pragma mark - Initialization Syntax Sugar

+ ( instancetype ) exposeVideoNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    return nil;
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

    return [ self notificationWithName: TauShouldExposeContentCollectionItemNotif
                                object: _Poster
                              userInfo: @{ kPlaylistIdentifier : playlistId
                                         , kPlaylistName : playlistName
                                         } ];
    }

+ ( instancetype ) exposeChannelNotificationWithYouTubeObject: ( GTLObject* )_YouTubeObject poster: ( id )_Poster
    {
    return nil;
    }

@end // NSNotification + TauShouldExposeCollectionItemNotif