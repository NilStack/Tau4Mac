//
//  TauRestRequest.m
//  Tau4Mac
//
//  Created by Tong G. on 4/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauRestRequest.h"

// NSString + TauRestRequestInitializing
@interface NSString ( TauRestRequestInitializing )

#pragma mark - Creating and Initializing String -

+ ( instancetype ) stringWithTauRestRequestVerboseLevelMask: ( TRSRestResponseVerboseFlag )_Mask;

#pragma mark - Identifying and Comparing Strings -

- ( BOOL ) hasCaseInsensitivePrefix: ( NSString* )_aString;
- ( BOOL ) hasCaseInsensitiveSuffix: ( NSString* )_aString;

@end



// -----------------------------------------------------//



// Private
@interface TauRestRequest ()

@property ( strong, readonly ) NSMutableDictionary <NSString*, id>* queryConfigInvocationsMap_;
@property ( copy, readonly ) NSString* parentIdentifierName_;

- ( void ) insertQueryConfigWithKeyPath_: ( NSString* )_KeyPath value_: ( id )_Value;

@end // Private

#define TRSSynthProperty( LOWER, UPPER, YTQUERY ) \
@synthesize LOWER = LOWER##_; \
- ( void ) set##UPPER: ( id )_New { \
if ( LOWER##_ != _New ) { \
    LOWER##_ = _New; \
    [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, YTQUERY ) value_: LOWER##_ ]; \
} } \
- ( id ) LOWER { return LOWER##_; }

// TauRestRequest class
@implementation TauRestRequest

#pragma mark - Designed Initializer -

- ( instancetype ) initWithRestRequestType: ( TRSRestRequestType )_RequestType responseVerboseLevel: ( TRSRestResponseVerboseFlag )_VerboseLevelMask
    {
    if ( self = [ super init ] )
        {
        self.type = _RequestType;

        SEL sel = nil;
        if ( selCharacteristic_.length > 0 )
            {
            sel = NSSelectorFromString( [ NSString stringWithFormat: @"queryFor%@ListWithPart:", selCharacteristic_ ] );

            queryFactoryInvocation_ = [ NSInvocation invocationWithMethodSignature: [ GTLQueryYouTube methodSignatureForSelector: sel ] ];
            [ queryFactoryInvocation_ setSelector: sel ];
            [ queryFactoryInvocation_ setTarget: [ GTLQueryYouTube class ] ];

            [ self setResponseVerboseLevelMask: _VerboseLevelMask ];
            }
        }

    return self;
    }

#pragma mark - TauRestListingRequests -

#pragma mark youtube.search.list

- ( instancetype ) initSearchResultsRequestWithQ: ( NSString* )_Q
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeSearchResultsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, q ) value_: _Q ];
    return self;
    }

#pragma mark youtube.channel.list

- ( instancetype ) initChannelRequestWithChannelIdentifier: ( NSString* )_Identifier
    {
    return [ self initChannelsRequestWithChannelIdentifiers: @[ _Identifier ] ];
    }

- ( instancetype ) initChannelsRequestWithChannelIdentifiers: ( NSArray <NSString*>* )_Identifiers
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeChannelsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, identifier ) value_: [ _Identifiers componentsJoinedByString: @"," ] ];
    return self;
    }

- ( instancetype ) initChannelRequestWithChannelName: ( NSString* )_Name
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeChannelsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, forUsername ) value_: _Name ];
    return self;
    }

- ( instancetype ) initChannelsOfMineRequest
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeChannelsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, mine ) value_: @YES ];
    return self;
    }

#pragma mark youtube.playlists.list

- ( instancetype ) initPlaylistRequestWithPlaylistIdentifier: ( NSString* )_Identifier
    {
    return [ self initPlaylistsRequestWithPlaylistIdentifiers: @[ _Identifier ] ];
    }

- ( instancetype ) initPlaylistsRequestWithPlaylistIdentifiers: ( NSArray <NSString*>* )_Identifiers
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypePlaylistsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, identifier ) value_: [ _Identifiers componentsJoinedByString: @"," ] ];
    return self;
    }

- ( instancetype ) initPlaylistsRequestWithChannelIdentifier: ( NSString* )_Identifier
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypePlaylistsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, channelId ) value_: _Identifier ];
    return self;
    }

- ( instancetype ) initPlaylistsOfMineRequest
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypePlaylistsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, mine ) value_: @YES ];
    return self;
    }

#pragma mark youtube.playlistItems.list

- ( instancetype ) initPlaylistItemRequestWithPlaylistItemIdentifier: ( NSString* )_Identifier
    {
    return [ self initPlaylistItemsRequestWithPlaylistItemIdentifiers: @[ _Identifier ] ];
    }

- ( instancetype ) initPlaylistItemsRequestWithPlaylistItemIdentifiers: ( NSArray <NSString*>* )_Identifiers
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypePlaylistItemsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, identifier ) value_: [ _Identifiers componentsJoinedByString: @"," ] ];
    return self;
    }

- ( instancetype ) initPlaylistItemsRequestWithPlaylistIdentifier: ( NSString* )_Identifier
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypePlaylistItemsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, playlistId ) value_: _Identifier ];
    return self;
    }

#pragma mark youtube.videos.list

- ( instancetype ) initVideoRequestWithVideoIdentifier: ( NSString* )_Identifier
    {
    return [ self initVideosRequestWithVideoIdentifiers: @[ _Identifier ] ];
    }

- ( instancetype ) initVideosRequestWithVideoIdentifiers: ( NSArray <NSString*>* )_Identifiers
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeVideosList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, identifier ) value_: _Identifiers ];
    return self;
    }

- ( instancetype ) initLikedVideosByMeRequest
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeVideosList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, myRating ) value_: @"like" ];
    return self;
    }

- ( instancetype ) initDislikedVideosByMeRequest
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeVideosList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, myRating ) value_: @"dislike" ];
    return self;
    }

#pragma mark youtube.subscriptions.list

- ( instancetype ) initSubscriptionsRequestWithChannelIdentifier: ( NSString* )_Identifier
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeSubscriptionsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, channelId ) value_: _Identifier ];
    return self;
    }

- ( instancetype ) initSubscriptionsOfMineRequest
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeSubscriptionsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, mine ) value_: @YES ];
    return self;
    }

- ( instancetype ) initMySubscribersRequest
    {
    if ( self = [ self initWithRestRequestType: TRSRestRequestTypeSubscriptionsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ] )
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, mySubscribers ) value_: @YES ];
    return self;
    }

#pragma mark - External Properties -

@dynamic YouTubeQuery;
- ( GTLQueryYouTube* ) YouTubeQuery
    {
    GTLQueryYouTube* result = nil;

    NSInvocation* queryFactoryInvok = queryFactoryInvocation_;
    if ( queryFactoryInvok )
        {
        [ queryFactoryInvok invoke ];

        // GTLQueryYouTube* res = nil;

        /* The original `GTLQueryYouTube* res = nil;` just causes a fragment error when ARC is enabled: 
        
         "Thread 1: EXC_BAD_ACCESS ( code=1, adrress=0x20 )"

         The problem is with the line `[ queryFactoryInvok getReturnValue: &res ];`.
         `getReturnValue:` just copies the bytes of the return value into the given memory buffer, regardless of type.
         It doesn't know or care about memory management if the return type is a retainable object pointer type.
         Since `res` is a __strong variable of object pointer type, ARC assumes that any value that has been put into the variable has been retained, and thus will release it when it goes out of scope.
         That is not true in this case, so it crashes. 
         
         The solution found at [here](http://stackoverflow.com/questions/22018272/nsinvocation-returns-value-but-makes-app-crash-with-exc-bad-access)
         is that we must give a pointer to a non-retained type to `getReturnValue:`: */

        GTLQueryYouTube __unsafe_unretained* res = nil;

        [ queryFactoryInvok getReturnValue: &res ];

        if ( res )
            {
            for ( NSString* _key in priQueryConfigInvocationsMap_ )
                {
                @try {
                [ res setValue: priQueryConfigInvocationsMap_[ _key ] forKeyPath: _key ];
                } @catch ( NSException* _Ex )
                    { DDLogFatal( @"captured exception raised by KVC mechanism: {\n\t%@\n}.", _Ex ); }
                }

            result = res;
            }
        }

    return result;
    }

@synthesize type = type_;
- ( void ) setType: ( TRSRestRequestType )_New
    {
    if ( type_ != _New )
        {
        type_ = _New;

        switch ( type_ )
            {
            case TRSRestRequestTypeSearchResultsList: selCharacteristic_ = @"Search"; break;
            case TRSRestRequestTypeChannelsList: selCharacteristic_ = @"Channels"; break;
            case TRSRestRequestTypePlaylistsList: selCharacteristic_ = @"Playlists"; break;
            case TRSRestRequestTypePlaylistItemsList: selCharacteristic_ = @"PlaylistItems"; break;
            case TRSRestRequestTypeSubscriptionsList: selCharacteristic_ = @"Subscriptions"; break;
            case TRSRestRequestTypeVideosList: selCharacteristic_ = @"Videos"; break;
            default: {;}
            }
        }
    }

@synthesize responseVerboseLevelMask = responseVerboseLevelMask_;
- ( void ) setResponseVerboseLevelMask: ( TRSRestResponseVerboseFlag )_New
    {
    if ( responseVerboseLevelMask_ != _New )
        {
        responseVerboseLevelMask_ = _New;

        // Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively,
        // therefore, it means current invocation ( queryFactoryInvocation_ ) has no any arguments
        // if numberOfArguments property of NSMethodSignature instance is equal to 2
        if ( queryFactoryInvocation_.methodSignature.numberOfArguments == 2 )
            return;

        NSString* stringizedSel = NSStringFromSelector( queryFactoryInvocation_.selector );
        NSMutableArray <NSString*>* argFragments = [ [ stringizedSel componentsSeparatedByString: @":" ] mutableCopy ];

        // drop the last element since it's just an empty string
        [ argFragments removeLastObject ];

        for ( NSString* _arg in argFragments )
            {
            /*

             For instances:

               - queryForSearchListWithPart:
               - queryForVideosListWithPart:
               - queryForChannelsListWithPart:
               - queryForSubscriptionsInsertWithObject:part:
               - queryForLiveChatMessagesListWithLiveChatId:part:
               ...

             */

            if ( [ _arg hasCaseInsensitiveSuffix: @"part" ] )
                {
                NSString* arg2 = [ NSString stringWithTauRestRequestVerboseLevelMask: responseVerboseLevelMask_ ];
                NSUInteger argIndex = [ argFragments indexOfObject: _arg ] + 2;
                [ queryFactoryInvocation_ setArgument: &arg2 atIndex: argIndex ];

                break;
                }
            }
        }
    }

- ( TRSRestResponseVerboseFlag ) responseVerboseLevelMask
    {
    return responseVerboseLevelMask_;
    }

TRSSynthProperty( fieldFilter, FieldFilter, fields );
TRSSynthProperty( maxResultsPerPage, MaxResultsPerPage, maxResults );
TRSSynthProperty( pageToken, PageToken, pageToken );

@dynamic isMine;
- ( BOOL ) isMine
    {
    return [ [ priQueryConfigInvocationsMap_ objectForKey: TauKVOStrictClassKeyPath( GTLQueryYouTube, mine ) ] boolValue ];
    }

#pragma mark - Conforms to Vary Protocols -

#pragma mark <NSCopying>

- ( instancetype ) copyWithZone: ( NSZone* )_Zone
    {
    TauRestRequest* copy = nil;

    if ( ( copy = [ [ self class ] allocWithZone: _Zone ] ) )
        {
        [ copy setType: type_ ];
        [ copy setResponseVerboseLevelMask: responseVerboseLevelMask_ ];

        [ copy setFieldFilter: fieldFilter_ ];
        [ copy setMaxResultsPerPage: maxResultsPerPage_ ];
        [ copy setPageToken: pageToken_ ];

        [ copy.queryConfigInvocationsMap_ addEntriesFromDictionary: self.queryConfigInvocationsMap_ ];
        }

    if ( !copy )
        DDLogFatal( @"[trs]failed creating the copy of {%@}.", self );

    return copy;
    }

#pragma mark <NSSecureCoding>

+ ( BOOL ) supportsSecureCoding
    {
    return [ self conformsToProtocol: @protocol( NSSecureCoding ) ];
    }

// TODO:

#pragma mark - Private -

@synthesize queryConfigInvocationsMap_ = priQueryConfigInvocationsMap_;
- ( NSMutableDictionary <NSString*, id>* ) queryConfigInvocationsMap_
    {
    if ( !priQueryConfigInvocationsMap_ )
        priQueryConfigInvocationsMap_ = [ NSMutableDictionary dictionary ];
    return priQueryConfigInvocationsMap_;
    }

@dynamic parentIdentifierName_;
- ( NSString* ) parentIdentifierName_
    {
    NSString* name = nil;

    switch ( type_ )
        {
        case TRSRestRequestTypeChannelsList:
            name = @"categoryId"; break;

        case TRSRestRequestTypeSubscriptionsList:
        case TRSRestRequestTypePlaylistsList:
            name = @"channelId"; break;

        case TRSRestRequestTypePlaylistItemsList:
            name = @"playlistId"; break;

        default: {;}
        }

    return name;
    }

- ( void ) insertQueryConfigWithKeyPath_: ( NSString* )_KeyPath value_: ( id )_Value
    {
    id finalValue = _Value;

    if ( !_Value
            || ( [ _Value isKindOfClass: [ NSNumber class ] ] && [ _Value isEqualToNumber: @( 0 ) ] )
            || ( [ _Value isKindOfClass: [ NSString class ] ] && ( [ _Value length ] == 0 ) ) )
        finalValue = nil;

    self.queryConfigInvocationsMap_[ _KeyPath ] = finalValue;
    }

@end // TauRestRequest class



// -----------------------------------------------------//



@implementation NSString ( TauRestRequestInitializing )

#pragma mark - Creating and Initializing String -

+ ( instancetype ) stringWithTauRestRequestVerboseLevelMask: ( TRSRestResponseVerboseFlag )_Mask
    {
    if ( !_Mask ) return nil;

    NSMutableArray <NSString*>* parts = [ NSMutableArray array ];

    NSMutableIndexSet* flagsRanges = [ NSMutableIndexSet indexSet ];
    [ flagsRanges addIndexesInRange: NSMakeRange( 0, 8 ) ];

    [ flagsRanges enumerateIndexesUsingBlock:
    ^( NSUInteger _Index, BOOL* _Nonnull _Stop )
        {
        TRSRestResponseVerboseFlag flag = ( 1 << _Index );
        if ( _Mask & flag )
            {
            NSString* partString = nil;
            switch ( flag )
                {
                case TRSRestResponseVerboseFlagSnippet: partString = @"snippet"; break;
                case TRSRestResponseVerboseFlagIdentifier: partString = @"id"; break;
                case TRSRestResponseVerboseFlagContentDetails: partString = @"contentDetails"; break;
                case TRSRestResponseVerboseFlagStatus: partString = @"status"; break;
                case TRSRestResponseVerboseFlagLocalizations: partString = @"localizations"; break;
                case TRSRestResponseVerboseFlagSubscriberSnippet: partString = @"subscriberSnippet"; break;
                case TRSRestResponseVerboseFlagReplies: partString = @"replies"; break;
                case TRSRestResponseVerboseFlagStatistics: partString = @"statistics"; break;
                }

            if ( partString )
                [ parts addObject: partString ];
            }
        } ];

    return [ parts componentsJoinedByString: @"," ];
    }

#pragma mark - Identifying and Comparing Strings -

- ( BOOL ) hasCaseInsensitivePrefix: ( NSString* )_aString
    {
    NSRange range = [ self rangeOfString: _aString options: NSCaseInsensitiveSearch | NSAnchoredSearch ];
    return ( range.location != NSNotFound );
    }

- ( BOOL ) hasCaseInsensitiveSuffix: ( NSString* )_aString
    {
    NSRange range = [ self rangeOfString: _aString options: NSCaseInsensitiveSearch | NSBackwardsSearch | NSAnchoredSearch ];
    return ( range.location != NSNotFound );
    }

@end // NSString + TauRestRequestInitializing