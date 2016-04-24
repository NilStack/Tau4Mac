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

/** A \c playlistItem resource identifies another resource, such as a video, that is included in a playlist.
  * In addition, the \c playlistItem resource contains details about the included resource
  * that pertain specifically to how that resource is used in that playlist.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/playlistItems */

+ ( instancetype ) restPlaylistItemRequestWithIdentifier: ( NSString* )_Identifier;
+ ( instancetype ) restPlaylistItemsRequestWithPlaylistIdentifier: ( NSString* )_Identifier;

#pragma mark - youtube.videos.list

/** A \c video resource represents a YouTube video.

  * For details, ref https://developers.google.com/youtube/v3/docs/videos */

+ ( instancetype ) restVideoRequestWithVideoIdentifier: ( NSString* )_Identifier;
+ ( instancetype ) restLikedVideosByMeRequest;
+ ( instancetype ) restDislikedVideosByMeRequest;

#pragma mark - youtube.subscriptions.list

/** \brief A \c subscription resource contains information about a YouTube user subscription.
  * A subscription notifies a user when new videos are added to a channel 
  * or when another user takes one of several actions on YouTube, such as uploading a video, 
  * rating a video, or commenting on a video.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/subscriptions */

/// The \a _Identifier parameter specifies a YouTube channel ID.
/// This request is to retrieve that channel's subscriptions.
+ ( instancetype ) restSubscriptionsRequestWithChannelIdentifier: ( NSString* )_Identifier;

/// This request can only be used in a properly authorized request.
/// This request is to retrieve a feed of the authenticated user's subscriptions.
+ ( instancetype ) restSubscriptionsOfMineRequest;

/// This request is retrieve a feed of the subscribers of the authenticated user.
+ ( instancetype ) restMySubscriberRequest;

@end // TauRestRequest class