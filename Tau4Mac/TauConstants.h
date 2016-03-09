//
//  TauConstants.h
//  Tau4Mac
//
//  Created by Tong G. on 3/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#ifndef TauConstants_h
#define TauConstants_h

typedef NS_ENUM ( NSInteger, TauPanelsSwitcherSegmentTag )
    { TauPanelsSwitcherSearchTag = 0
    , TauPanelsSwitcherMeTubeTag = 1
    , TauPanelsSwitcherPlayerTag = 2
    };

typedef NS_ENUM ( NSInteger, TauMeTubeSubPanelSwitcherSegmentTag )
    { TauMeTubeSubPanelSwitcherLikesTag      = 0
    , TauMeTubeSubPanelSwitcherUploadsTag    = 1
    , TauMeTubeSubPanelSwitcherHistoryTag    = 2
    , TauMeTubeSubPanelSwitcherWatchLaterTag = 3
    };

typedef NS_ENUM ( NSUInteger, TauYouTubeContentViewType )
    { TauYouTubeVideoView           = 1
    , TauYouTubeChannelView         = 2
    , TauYouTubePlayListView        = 3
    , TauYouTubePlayListItemView    = 4

    , TauYouTubeUnknownView         = 0
    };

#define TAU_PAGEER_PREV 0
#define TAU_PAGEER_NEXT 1

// To suppress the "PerformSelector may cause a leak because its selector is unknown" warning
#define TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( _CodeFragment )\
    _Pragma("clang diagnostic push")\
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
    _CodeFragment\
    _Pragma("clang diagnostic pop")

// Notification Names
NSString extern* const TauShouldSwitch2SearchSegmentNotif;
NSString extern* const TauShouldSwitch2MeTubeSegmentNotif;
NSString extern* const TauShouldSwitch2PlayerSegmentNotif;

NSString extern* const TauShouldPlayVideoNotif;

// User Info Keys
NSString extern* const kGTLObject;
NSString extern* const kRequester;

#endif /* TauConstants_h */
