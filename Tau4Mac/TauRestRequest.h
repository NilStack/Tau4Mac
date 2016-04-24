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
@interface TauRestRequest : NSObject

@property ( assign, readonly ) TRSRestRequestType type;

@property ( copy, readwrite ) NSString* fieldFilter;
@property ( assign, readwrite ) NSUInteger maxResultsPerPage;
@property ( assign, readwrite ) TRSRestResponseVerboseFlag verboseLevelMask;

#pragma mark - youtube.search.list

+ ( instancetype ) restRequestWithQ: ( NSString* )_Q;

@end // TauRestRequest class