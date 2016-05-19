//
//  TauRestRequest.h
//  Tau4Mac
//
//  Created by Tong G. on 4/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

typedef NS_ENUM ( NSInteger, TRSRestRequestType )
    { TRSRestRequestTypeSearchResultsList = 1
    , TRSRestRequestTypeChannelsList      = 2
    , TRSRestRequestTypePlaylistsList     = 3
    , TRSRestRequestTypePlaylistItemsList = 4
    , TRSRestRequestTypeSubscriptionsList = 5
    , TRSRestRequestTypeVideosList        = 6

    , TRSRestRequestTypeUnknown = 0
    , TRSRestRequestTypeOthers  = -1
    };

typedef NS_OPTIONS ( uint64, TRSRestResponseVerboseFlag )
    { TRSRestResponseVerboseFlagSnippet           = ( 1 << 0 )
    , TRSRestResponseVerboseFlagIdentifier        = ( 1 << 1 )
    , TRSRestResponseVerboseFlagContentDetails    = ( 1 << 2 )
    , TRSRestResponseVerboseFlagStatus            = ( 1 << 3 )
    , TRSRestResponseVerboseFlagLocalizations     = ( 1 << 4 )
    , TRSRestResponseVerboseFlagSubscriberSnippet = ( 1 << 5 )
    , TRSRestResponseVerboseFlagReplies           = ( 1 << 6 )
    , TRSRestResponseVerboseFlagStatistics        = ( 1 << 7 )
    };

typedef NS_ENUM ( NSUInteger, TRSCacheStrategy )
    { TRSCacheStrategyNoCache            = 0
    , TRSCacheStrategyGUIViewPeriod      = 1
    , TRSCacheStrategyCustomTimeInterval = 2
    , TRSCacheStrategyForever            = 3
    };

#import "TauRestListingRequestsComponent.h"

// TauRestRequest class
@interface TauRestRequest : NSObject <NSCopying, NSSecureCoding, TauRestListingRequests>
    {
@protected
    GTLQueryYouTube* ytQuery_;

    NSInvocation* queryFactoryInvocation_;
    NSString* selCharacteristic_;
    }

@property ( copy, readonly ) GTLQueryYouTube* YouTubeQuery;
@property ( assign, readonly ) TRSRestRequestType type;
@property ( assign, readwrite ) TRSRestResponseVerboseFlag responseVerboseLevelMask;

@property ( copy, readwrite ) NSString* fieldFilter;
@property ( assign, readwrite ) NSNumber* maxResultsPerPage;

@property ( copy, readwrite ) NSString* pageToken;

@property ( assign, readonly ) BOOL isMine;

#pragma mark - Designed Initializer

- ( instancetype ) initWithRestRequestType: ( TRSRestRequestType )_RequestType responseVerboseLevel: ( TRSRestResponseVerboseFlag )_VerboseLevelMask;

@end // TauRestRequest class