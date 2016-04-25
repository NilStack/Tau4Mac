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
    {
@protected
    GTLQueryYouTube* ytQuery_;
    }

@property ( assign, readonly ) TRSRestRequestType type;
@property ( copy, readonly ) GTLQueryYouTube* ytQuery;

@property ( copy, readwrite ) NSString* fieldFilter;
@property ( assign, readwrite ) NSUInteger maxResultsPerPage;
@property ( assign, readwrite ) TRSRestResponseVerboseFlag verboseLevelMask;

@property ( copy, readwrite ) NSString* prevPageToken;
@property ( copy, readwrite ) NSString* nextPageToken;

@property ( assign, readonly ) BOOL isMine;

#pragma mark - youtube.search.list

/** A search result contains information about a YouTube video, channel, or playlist 
  * that matches the search parameters specified in an API request. 
  * While a search result points to a uniquely identifiable resource, like a video, 
  * it does not have its own persistent data.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/search */

/// The \c Q parameter specifies the query term to search for.
/// Your \c Q expression can also use the Boolean NOT (-) and OR (|) operators
/// to exclude videos or to find videos that are associated with one of several search terms.
/// For example, to search for videos matching either "boating" or "sailing",
/// set the q parameter value to boating|sailing.
/// Similarly, to search for videos matching either "boating" or "sailing" but not "fishing",
/// set the q parameter value to boating|sailing -fishing.
/// \warning Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
+ ( instancetype ) restSearchResultsRequestWithQ: ( NSString* )_Q;

#pragma mark - youtube.channel.list

/** A \c channel resource contains information about a YouTube channel.
  * For details, ref: https://developers.google.com/youtube/v3/docs/channels */

/// The \c _Identifier parameter specifies a single YouTube channel ID for the resource that are being retrieved.
+ ( instancetype ) restChannelRequestWithChannelIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube channel ID(s) for the resource(s) that are being retrieved.
+ ( instancetype ) restChannelsRequestWithChannelIdentifiers: ( NSArray <NSString*>* )_Identifiers;

/// The \c _Name parameter specifies a YouTube channel name,
/// thereby requesting the channel associated with that channel name.
+ ( instancetype ) restChannelRequestWithChannelName: ( NSString* )_Name;

/// This request is to return only the channels owned by the current authenticated user.
+ ( instancetype ) restChannelsOfMineRequest;

#pragma mark - youtube.playlists.list

/** A \c playlist resource represents a YouTube playlist. 
  * A playlist is a collection of videos that can be viewed sequentially and shared with other users. 
  * YouTube does not limit the number of playlists that each user creates. 
  * By default, playlists are publicly visible to other users, but playlists can be public or private.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/playlists */

/// The \c _Identifier parameter specifies a single YouTube playlist ID for the resource that are being retrieved.
+ ( instancetype ) restPlaylistRequestWithPlaylistIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube playlist ID(s) for the resource(s) that are being retrieved.
+ ( instancetype ) restPlaylistsRequestWithPlaylistIdentifiers: ( NSArray <NSString*>* )_Identifiers;

/// This request is to return only the specified channel's playlists.
+ ( instancetype ) restPlaylistsRequestWithChannelIdentifier: ( NSString* )_Identifier;

/// This request is to return only the playlists owned by the current authenticated user.
+ ( instancetype ) restPlaylistsOfMineRequest;

#pragma mark - youtube.playlistItems.list

/** A \c playlistItem resource identifies another resource, such as a video, that is included in a playlist.
  * In addition, the \c playlistItem resource contains details about the included resource
  * that pertain specifically to how that resource is used in that playlist.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/playlistItems */

/// The \c _Identifier parameter specifies a single YouTube playlist item ID for the resource that are being retrieved.
+ ( instancetype ) restPlaylistItemRequestWithPlaylistItemIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube playlist item ID(s) for the resource(s) that are being retrieved.
+ ( instancetype ) restPlaylistItemsRequestWithPlaylistItemIdentifiers: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies the unique ID of the playlist for which you want to retrieve playlist items.
+ ( instancetype ) restPlaylistItemsRequestWithPlaylistIdentifiers: ( NSString* )_Identifier;

#pragma mark - youtube.videos.list

/** A \c video resource represents a YouTube video.

  * For details, ref https://developers.google.com/youtube/v3/docs/videos */

/// The \c _Identifier parameter specifies a single YouTube video ID for the resource that are being retrieved.
+ ( instancetype ) restVideoRequestWithVideoIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube video ID(s) for the resource(s) that are being retrieved.
+ ( instancetype ) restVideosRequestWithVideoIdentifiers: ( NSArray <NSString*>* )_Identifiers;

/// This request is to return only videos liked by the authenticated user.
+ ( instancetype ) restLikedVideosByMeRequest;

/// This request is to return only videos disliked by the authenticated user.
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