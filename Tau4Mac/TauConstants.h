//
//  TauConstants.h
//  Tau4Mac
//
//  Created by Tong G. on 3/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#ifndef TauConstants_h
#define TauConstants_h



// ------------------------------------------------------------------------------------------------------------ //



#define TAU_KEY_OF_SEL( _Sel ) ( NSStringFromSelector( _Sel ) )

#define TAU_CHANGE_VALUE_BEGIN( _Key )  ( [ self willChangeValueForKey: _Key ] )
#define TAU_CHANGE_VALUE_COMMIT( _Key ) ( [ self didChangeValueForKey: _Key ] )

#define TAU_CHANGE_VALUE_BEGIN_of( _Sel )  TAU_CHANGE_VALUE_BEGIN( TAU_KEY_OF_SEL( _Sel ) )
#define TAU_CHANGE_VALUE_COMMIT_of( _Sel ) TAU_CHANGE_VALUE_COMMIT( TAU_KEY_OF_SEL( _Sel ) )

#define TAU_CHANGE_VALUE_FOR_KEY( _Key, _ExpressionBlk )\
do {\
NSParameterAssert( ( _Key ) && ( [ _Key length ] > 0 ) );\
TAU_CHANGE_VALUE_BEGIN( _Key );\
    _ExpressionBlk();\
TAU_CHANGE_VALUE_COMMIT( _Key );\
} while ( 0 )

#define TAU_CHANGE_VALUE_FOR_KEY_of_SEL( _Sel, _ExpressionBlk )\
    TAU_CHANGE_VALUE_FOR_KEY( TAU_KEY_OF_SEL( _Sel ), _ExpressionBlk )



// ------------------------------------------------------------------------------------------------------------ //



#define TauDeallocBegin - ( void ) dealloc { DDLogExpecting( @"%@ got deallocated", self );
#define TauDeallocEnd }



// ------------------------------------------------------------------------------------------------------------ //



NSString extern* const TauKeychainItemName;

#pragma mark - Client Credentials

/** The OAuth 2.0 client ID for Tau4Mac. Examine this value here https://console.developers.google.com/ */
NSString extern* const TauClientID;

/** The client secret associated with client ID of Tau4Mac. */
NSString extern* const TauClientSecret;

#pragma mark - Auth Scopes

/** Manage users' YouTube account. This scope requires communication with the API server to happen over an SSL connection. */
NSString extern* const TauManageAuthScope;

/** View users' YouTube account. */
NSString extern* const TauReadonlyAuthScope;

/** Upload YouTube videos and manage users' YouTube videos. */
NSString extern* const TauUploadAuthScope;

/** Retrieve the auditDetails part in a channel resource. */
NSString extern* const TauPartnerChannelAuditAuthScope;



// ------------------------------------------------------------------------------------------------------------ //



typedef NS_ENUM ( NSInteger, TauContentViewTag )
    { TauSearchContentViewTag  = 0
    , TauExploreContentViewTag = 1
    , TauPlayerContentViewTag  = 2

    , TauUnknownContentViewTag = -1
    };

typedef NS_ENUM ( NSInteger, TauExploreSubContentViewTag )
    { TauExploreLikesSubContentViewTag      = 0
    , TauExploreUploadsSubContentViewTag    = 1
    , TauExploreHistorySubContentViewTag    = 2
    , TauExploreWatchLaterSubContentViewTag = 3
    };

typedef NS_ENUM ( NSUInteger, TauYouTubeContentType )
    { TauYouTubeVideo           = 1
    , TauYouTubeChannel         = 2
    , TauYouTubePlayList        = 3

    , TauYouTubeUnknownContent  = 0
    };

typedef NS_ENUM ( NSUInteger, TauYTDataServiceConsumptionType )
    { TauYTDataServiceConsumptionSearchResultsType = 1
    , TauYTDataServiceConsumptionChannelsType      = 2
    , TauYTDataServiceConsumptionPlaylistsType     = 3
    , TauYTDataServiceConsumptionPlaylistItemsType = 4

    , TauYTDataServiceConsumptionUnknownType       = 0
    };

#define TAU_APP_MIN_WIDTH  500.f
#define TAU_APP_MIN_HEIGHT ( TAU_APP_MIN_WIDTH * ( 9.f / 16.f ) )

#define TAU_PAGEER_PREV 0
#define TAU_PAGEER_NEXT 1



// ------------------------------------------------------------------------------------------------------------ //



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



// ------------------------------------------------------------------------------------------------------------ //



// Notification Names
NSString extern* const TauShouldSwitch2SearchSegmentNotif;
NSString extern* const TauShouldSwitch2MeTubeSegmentNotif;
NSString extern* const TauShouldSwitch2PlayerSegmentNotif;

NSString extern* const TauShouldPlayVideoNotif;

NSString extern* const TauShouldExposeContentCollectionItemNotif;

// User Info Keys
NSString extern* const kGTLObject;
NSString extern* const kRequester;



// ------------------------------------------------------------------------------------------------------------ //



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



// ------------------------------------------------------------------------------------------------------------ //



typedef NS_ENUM ( NSInteger, TauAppMenuItemTag )
    { TauAppMenuItem       = 0
    , TauAppFileMenuItem   = 1
    , TauAppEditMenuItem   = 2
    , TauAppEditFormatItem = 3
    , TauAppViewMenuItem   = 4
    , TauAppWindowMenuItem = 5
    , TauAppHelpMenuItem   = 6
    };

#define TauAppViewSubMenuItemTag2TauContentViewTag( _Tag ) \
( _Tag - 1000 )

#define TauAppViewSubMenuItemTagFromTauContentViewTag( _Tag ) \
( ( _Tag != TauUnknownContentViewTag ) ? ( _Tag + 1000 ) : TauAppViewSubMenuUnknownItemTag )

typedef NS_ENUM ( NSInteger, TauAppViewSubMenuItemTag )
    { TauAppViewSubMenuSearchItemTag  = TauSearchContentViewTag + 1000
    , TauAppViewSubMenuExploreItemTag = TauExploreContentViewTag + 1000
    , TauAppViewSubMenuPlayerItemTag  = TauPlayerContentViewTag + 1000

    , TauAppViewSubMenuUnknownItemTag = -1
    };

#endif /* TauConstants_h */