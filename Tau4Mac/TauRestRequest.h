//
//  TauRestRequest.h
//  Tau4Mac
//
//  Created by Tong G. on 4/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

typedef NS_OPTIONS ( uint64, TRSRestResponseVerboseFlag )
    { TRSRestRequestVerboseFlagSnippet           = ( 1 << 0 )
    , TRSRestRequestVerboseFlagIdentifier        = ( 1 << 1 )
    , TRSRestRequestVerboseFlagContentDetails    = ( 1 << 2 )
    , TRSRestRequestVerboseFlagStatus            = ( 1 << 3 )
    , TRSRestRequestVerboseFlagLocalizations     = ( 1 << 4 )
    , TRSRestRequestVerboseFlagSubscriberSnippet = ( 1 << 5 )
    , TRSRestRequestVerboseFlagReplies           = ( 1 << 6 )

    , TRSRestRequestVerboseFlagUnknown = ( 0 )
    };

typedef NS_ENUM ( NSInteger, TRSRestRequestType )
    { TRSRestRequestTypeSearchList        = 1
    , TRSRestRequestTypeChannelList       = 2
    , TRSRestRequestTypePlaylistList      = 3
    , TRSRestRequestTypePlaylistItemsList = 4
    , TRSRestRequestTypeSubscriptionsList = 5

    , TRSRestRequestTypeUnknown = 0
    , TRSRestRequestTypeOthers  = -1
    };

typedef NS_ENUM ( NSUInteger, TRSCacheStrategy )
    { TRSCacheStrategyNoCache            = 0
    , TRSCacheStrategyGUIViewPeriod      = 1
    , TRSCacheStrategyCustomTimeInterval = 2
    , TRSCacheStrategyForever            = 3
    };

// TauRestRequest class
@interface TauRestRequest : NSObject <NSCopying, NSSecureCoding>

@property ( assign, readonly ) TRSRestRequestType type;
@property ( copy, readonly ) GTLQueryYouTube* ytQuery;

@property ( copy, readwrite ) NSString* fieldFilter;
@property ( assign, readwrite ) NSUInteger maxResultsPerPage;
@property ( assign, readwrite ) TRSRestResponseVerboseFlag verboseLevelMask;

@property ( copy, readwrite ) NSString* prevPageToken;
@property ( copy, readwrite ) NSString* nextPageToken;

@property ( assign, readwrite, setter = setMine: ) BOOL isMine;

#pragma mark - youtube.search.list

+ ( instancetype ) restSearchResultsRequestWithQ: ( NSString* )_Q;

#pragma mark - youtube.channel.list

+ ( instancetype ) restChannelRequestWithChannelIdentifier: ( NSString* )_Identifier;
+ ( instancetype ) restChannelRequestWithChannelName: ( NSString* )_Name;
+ ( instancetype ) restChannelsOfMineRequest;

#pragma mark - youtube.playlists.list

+ ( instancetype ) restPlaylistRequestWithPlaylistIdentifier: ( NSString* )_Identifier;
+ ( instancetype ) restPlaylistsRequestWithChannelIdentifier: ( NSString* )_Identifier;
+ ( instancetype ) restPlaylistsOfMineRequest;

#pragma mark - youtube.playlistItems.list

+ ( instancetype ) restPlaylistItemRequestWithIdentifier: ( NSString* )_Identifier;
+ ( instancetype ) restPlaylistItemsRequestWithPlaylistIdentifier: ( NSString* )_Identifier;

#pragma mark - youtube.video.list

+ ( instancetype ) restVideoRequestWithVideoIdentifier: ( NSString* )_Identifier;

#pragma mark - youtube.subscriptions.list

+ ( instancetype ) restSubscriptionsRequestWithChannelIdentifier: ( NSString* )_Identifier;
+ ( instancetype ) restSubscriptionsOfMineRequest;

@end // TauRestRequest class