//
//  TauRestListingRequestsComponent.h
//  Tau4Mac
//
//  Created by Tong G. on 5/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauRestListingRequests protocol
@protocol TauRestListingRequests <NSObject>

@required

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
/// set the \c Q parameter value to boating|sailing.
/// Similarly, to search for videos matching either "boating" or "sailing" but not "fishing",
/// set the \c Q parameter value to boating|sailing -fishing.
/// \warning Note that the pipe character must be URL-escaped when it is sent in your API request.
/// The URL-escaped value for the pipe character is %7C.
- ( instancetype ) initSearchResultsRequestWithQ: ( NSString* )_Q;

#pragma mark - youtube.channel.list

/** A \c channel resource contains information about a YouTube channel.
  * For details, ref: https://developers.google.com/youtube/v3/docs/channels */

/// The \c _Identifier parameter specifies a single YouTube channel ID for the resource that are being retrieved.
- ( instancetype ) initChannelRequestWithChannelIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube channel ID(s) for the resource(s) that are being retrieved.
- ( instancetype ) initChannelsRequestWithChannelIdentifiers: ( NSArray <NSString*>* )_Identifiers;

/// The \c _Name parameter specifies a YouTube channel name,
/// thereby requesting the channel associated with that channel name.
- ( instancetype ) initChannelRequestWithChannelName: ( NSString* )_Name;

/// This request is to return only the channels owned by the current authenticated user.
- ( instancetype ) initChannelsOfMineRequest;

#pragma mark - youtube.playlists.list

/** A \c playlist resource represents a YouTube playlist. 
  * A playlist is a collection of videos that can be viewed sequentially and shared with other users. 
  * YouTube does not limit the number of playlists that each user creates. 
  * By default, playlists are publicly visible to other users, but playlists can be public or private.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/playlists */

/// The \c _Identifier parameter specifies a single YouTube playlist ID for the resource that are being retrieved.
- ( instancetype ) initPlaylistRequestWithPlaylistIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube playlist ID(s) for the resource(s) that are being retrieved.
- ( instancetype ) initPlaylistsRequestWithPlaylistIdentifiers: ( NSArray <NSString*>* )_Identifiers;

/// This request is to return only the specified channel's playlists.
- ( instancetype ) initPlaylistsRequestWithChannelIdentifier: ( NSString* )_Identifier;

/// This request is to return only the playlists owned by the current authenticated user.
- ( instancetype ) initPlaylistsOfMineRequest;

#pragma mark - youtube.playlistItems.list

/** A \c playlistItem resource identifies another resource, such as a video, that is included in a playlist.
  * In addition, the \c playlistItem resource contains details about the included resource
  * that pertain specifically to how that resource is used in that playlist.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/playlistItems */

/// The \c _Identifier parameter specifies a single YouTube playlist item ID for the resource that are being retrieved.
- ( instancetype ) initPlaylistItemRequestWithPlaylistItemIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube playlist item ID(s) for the resource(s) that are being retrieved.
- ( instancetype ) initPlaylistItemsRequestWithPlaylistItemIdentifiers: ( NSArray <NSString*>* )_Identifiers;

/// The \c _Identifiers parameter specifies the unique ID of the playlist for which you want to retrieve playlist items.
- ( instancetype ) initPlaylistItemsRequestWithPlaylistIdentifier: ( NSString* )_Identifier;

#pragma mark - youtube.videos.list

/** A \c video resource represents a YouTube video.

  * For details, ref https://developers.google.com/youtube/v3/docs/videos */

/// The \c _Identifier parameter specifies a single YouTube video ID for the resource that are being retrieved.
- ( instancetype ) initVideoRequestWithVideoIdentifier: ( NSString* )_Identifier;

/// The \c _Identifiers parameter specifies a list of the YouTube video ID(s) for the resource(s) that are being retrieved.
- ( instancetype ) initVideosRequestWithVideoIdentifiers: ( NSArray <NSString*>* )_Identifiers;

/// This request is to return only videos liked by the authenticated user.
- ( instancetype ) initLikedVideosByMeRequest;

/// This request is to return only videos disliked by the authenticated user.
- ( instancetype ) initDislikedVideosByMeRequest;

#pragma mark - youtube.subscriptions.list

/** \brief A \c subscription resource contains information about a YouTube user subscription.
  * A subscription notifies a user when new videos are added to a channel 
  * or when another user takes one of several actions on YouTube, such as uploading a video, 
  * rating a video, or commenting on a video.
  
  * For details, ref https://developers.google.com/youtube/v3/docs/subscriptions */

/// The \a _Identifier parameter specifies a YouTube channel ID.
/// This request is to retrieve that channel's subscriptions.
- ( instancetype ) initSubscriptionsRequestWithChannelIdentifier: ( NSString* )_Identifier;

/// This request can only be used in a properly authorized request.
/// This request is to retrieve a feed of the authenticated user's subscriptions.
- ( instancetype ) initSubscriptionsOfMineRequest;

/// This request is retrieve a feed of the subscribers of the authenticated user.
- ( instancetype ) initMySubscribersRequest;

@end // TauRestListingRequests protocol