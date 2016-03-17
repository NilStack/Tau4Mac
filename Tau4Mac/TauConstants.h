//
//  TauConstants.h
//  Tau4Mac
//
//  Created by Tong G. on 3/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#ifndef TauConstants_h
#define TauConstants_h

NSString extern* const TauKeychainItemName;

#pragma mark - Client Credentials

/** The OAuth 2.0 client ID for Tau4Mac. Find this value here https://console.developers.google.com/ */
NSString extern* const TauClientID;

/** The client secret associated with client ID of Tau4Mac. */
NSString extern* const TauClientSecret;

#pragma mark - Auth Scopes

/** Manage users' YouTube account. This scope requires communication with the API server to happen over an SSL connection. */
NSString extern* const TauManageAuthScope;

/** View usersa' YouTube account. */
NSString extern* const TauReadonlyAuthScope;

/** Upload YouTube videos and manage users' YouTube videos. */
NSString extern* const TauUploadAuthScope;

/** Retrieve the auditDetails part in a channel resource. */
NSString extern* const TauPartnerChannelAuditAuthScope;

typedef NS_ENUM ( NSInteger, TauSwitcherSegmentTag )
    { TauPanelsSwitcherSearchTag = 0
    , TauPanelsSwitcherExploreTag = 1
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

typedef NS_ENUM ( NSUInteger, TauYTDataServiceConsumptionType )
    { TauYTDataServiceConsumptionSearchResultsType = 1
    , TauYTDataServiceConsumptionChannelsType      = 2
    , TauYTDataServiceConsumptionPlaylistsType     = 3
    , TauYTDataServiceConsumptionPlaylistItemsType = 4
    };

#define TAU_APP_MIN_WIDTH  500.f
#define TAU_APP_MIN_HEIGHT 200.f

#define TAU_PAGEER_PREV 0
#define TAU_PAGEER_NEXT 1

// To suppress the "PerformSelector may cause a leak because its selector is unknown" warning
#define TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_BEGIN\
    _Pragma("clang diagnostic push")\
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
    
#define TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_COMMIT\
    _Pragma("clang diagnostic pop")

// Get rid of the 'undeclared selector' warning
#define TAU_SUPPRESS_UNDECLARED_SELECTOR_WARNING_BEGIN\
    _Pragma("clang diagnostic push")\
    _Pragma("clang diagnostic ignored \"-Wundeclared-selector\"")

#define TAU_SUPPRESS_UNDECLARED_SELECTOR_WARNING_COMMIT\
    _Pragma("clang diagnostic pop")

// Notification Names
NSString extern* const TauShouldSwitch2SearchSegmentNotif;
NSString extern* const TauShouldSwitch2MeTubeSegmentNotif;
NSString extern* const TauShouldSwitch2PlayerSegmentNotif;

NSString extern* const TauShouldPlayVideoNotif;

// User Info Keys
NSString extern* const kGTLObject;
NSString extern* const kRequester;

// General Error domains
NSString extern* const TauGeneralErrorDomain;

typedef NS_ENUM ( NSInteger, TauGeneralErrorCode )
    { TauGeneralUnknownError = -1
    , TauGeneralInvalidArgument = -1000
    };

// Error domains that is specific to central data service mechanism
NSString extern* const TauCentralDataServiceErrorDomain;

typedef NS_ENUM ( NSInteger, TauCentralDataServiceErrorCode )
    { TauCentralDataServiceUnknownError = -1
    , TauCentralDataServiceInvalidCredentialError   = -1000
    , TauCentralDataServiceInvalidOrConflictingOperationsCombination = -1001
    };

NSString extern* const TauUnderlyingErrorDomain;

typedef NS_ENUM ( NSInteger, TauUnderlyingErrorCode )
    { TauUnderlyingUnknownError = -1
    , TauUnderlyingGTLError = -1000
    };

#endif /* TauConstants_h */
