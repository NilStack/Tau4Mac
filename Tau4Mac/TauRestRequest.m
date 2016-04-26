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

#pragma mark - Creating and Initializing String

+ ( instancetype ) stringWithTauRestRequestVerboseLevelMask: ( TRSRestResponseVerboseFlag )_Mask;

#pragma mark - Identifying and Comparing Strings

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

// TauRestRequest class
@implementation TauRestRequest

#pragma mark - Designed Initializer

- ( instancetype ) initWithRestRequestType: ( TRSRestRequestType )_RequestType responseVerboseLevel: ( TRSRestResponseVerboseFlag )_VerboseLevelMask
    {
    if ( self = [ super init ] )
        {
        type_ = _RequestType;

        NSString* selCharacteristic = nil;
        SEL sel = nil;
        switch ( _RequestType )
            {
            case TRSRestRequestTypeSearchResultsList: selCharacteristic = @"Search"; break;
            case TRSRestRequestTypeChannelsList: selCharacteristic = @"Channels"; break;
            case TRSRestRequestTypePlaylistsList: selCharacteristic = @"Playlists"; break;
            case TRSRestRequestTypePlaylistItemsList: selCharacteristic = @"PlaylistItems"; break;
            case TRSRestRequestTypeSubscriptionsList: selCharacteristic = @"Subscriptions"; break;
            default:;
            }

        if ( selCharacteristic.length > 0 )
            {
            sel = NSSelectorFromString( [ NSString stringWithFormat: @"queryFor%@ListWithPart:", selCharacteristic ] );

            queryFactoryInvocation_ = [ NSInvocation invocationWithMethodSignature: [ GTLQueryYouTube methodSignatureForSelector: sel ] ];
            [ queryFactoryInvocation_ setSelector: sel ];
            [ queryFactoryInvocation_ setTarget: [ GTLQueryYouTube class ] ];

            [ self setResponseVerboseLevelMask: _VerboseLevelMask ];
            }
        }

    return self;
    }

#pragma mark - youtube.search.list

- ( instancetype ) initSearchResultsRequestWithQ: ( NSString* )_Q
    {
    TauRestRequest* new = [ [ [ self class ] alloc ] initWithRestRequestType: TRSRestRequestTypeSearchResultsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ];
    [ new insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, q ) value_: _Q ];
    return new;
    }

#pragma mark - youtube.channel.list

- ( instancetype ) initChannelRequestWithChannelIdentifier: ( NSString* )_Identifier
    {
    return [ [ [ self class ] alloc ] initChannelsRequestWithChannelIdentifiers: @[ _Identifier ] ];
    }

- ( instancetype ) initChannelsRequestWithChannelIdentifiers: ( NSArray <NSString*>* )_Identifiers
    {
    TauRestRequest* new = [ [ [ self class ] alloc ] initWithRestRequestType: TRSRestRequestTypeChannelsList responseVerboseLevel: TRSRestResponseVerboseFlagSnippet ];
    [ new insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, identifier ) value_: _Identifiers ];
    return new;
    }

#pragma mark - External Properties

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
        
         "Thread 1: EXC_BAD_ACCESS (code=1, adrress=0x20)"

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

@synthesize responseVerboseLevelMask = responseVerboseLevelMask_;
- ( void ) setResponseVerboseLevelMask: ( TRSRestResponseVerboseFlag )_New
    {
    if ( responseVerboseLevelMask_ != _New )
        {
        responseVerboseLevelMask_ = _New;

        if ( queryFactoryInvocation_.methodSignature.numberOfArguments == 2 )
            return;

        NSString* stringizedSel = NSStringFromSelector( queryFactoryInvocation_.selector );
        NSMutableArray <NSString*>* argFragments = [ [ stringizedSel componentsSeparatedByString: @":" ] mutableCopy ];

        // last string is an empty string so just drop it   
        [ argFragments removeLastObject ];

        for ( NSString* _arg in argFragments )
            {
            if ( [ _arg hasCaseInsensitiveSuffix: @"part" ] )
                {
                NSString* arg2 = [ NSString stringWithTauRestRequestVerboseLevelMask: responseVerboseLevelMask_ ];
                NSUInteger argIndex = [ argFragments indexOfObject: _arg ] + 2;
                [ queryFactoryInvocation_ setArgument: &arg2 atIndex: argIndex ];
                }
            }
        }
    }

- ( TRSRestResponseVerboseFlag ) responseVerboseLevelMask
    {
    return responseVerboseLevelMask_;
    }

@synthesize fieldFilter = fieldFilter_;
- ( void ) setFieldFilter: ( NSString* )_New
    {
    if ( fieldFilter_ != _New )
        {
        fieldFilter_ = _New;
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, fields ) value_: fieldFilter_ ];
        }
    }

- ( NSString* ) fieldFilter
    {
    return fieldFilter_;
    }

@synthesize maxResultsPerPage = maxResultsPerPage_;
- ( void ) setMaxResultsPerPage: ( NSUInteger )_New
    {
    if ( maxResultsPerPage_ != _New )
        {
        maxResultsPerPage_ = _New;
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, maxResults ) value_: @( maxResultsPerPage_ ) ];
        }
    }

- ( NSUInteger ) maxResultsPerPage
    {
    return maxResultsPerPage_;
    }

@synthesize pageToken = pageToken_;
- ( void ) setPageToken: ( NSString* )_New
    {
    if ( pageToken_ != _New )
        {
        pageToken_ = _New;
        [ self insertQueryConfigWithKeyPath_: TauKVOStrictClassKeyPath( GTLQueryYouTube, pageToken ) value_: pageToken_ ];
        }
    }

- ( NSString* ) pageToken
    {
    return pageToken_;
    }

@dynamic isMine;

#pragma mark - Conforms to <NSCopying>

//- ( instancetype ) copyWithZone: ( NSZone* )_Zone
//    {
//    TauRestRequest* copy = [ [ self class ] allocWithZone: _Zone ];
//
//    SEL init = nil;
//    switch ( type_ )
//        {
//        case
//        }
//    }

#pragma mark - Conforms to <NSSecureCoding>

+ ( BOOL ) supportsSecureCoding
    {
    return [ self conformsToProtocol: @protocol( NSSecureCoding ) ];
    }

// TODO:

#pragma mark - Private

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

        default:;
        }

    return name;
    }

#define TAU_ARG_FIRST_IDX 2

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

#pragma mark - Creating and Initializing String

+ ( instancetype ) stringWithTauRestRequestVerboseLevelMask: ( TRSRestResponseVerboseFlag )_Mask
    {
    NSMutableArray <NSString*>* parts = [ NSMutableArray array ];

    NSMutableIndexSet* flagsRanges = [ NSMutableIndexSet indexSet ];
    [ flagsRanges addIndexesInRange: NSMakeRange( 0, 8 ) ];

    [ flagsRanges enumerateIndexesUsingBlock:
    ^( NSUInteger _Index, BOOL* _Nonnull _Stop )
        {
        TRSRestResponseVerboseFlag flag = ( 1 << _Index );
        if ( _Mask & flag )
            {
            switch ( flag )
                {
                case TRSRestResponseVerboseFlagSnippet: [ parts addObject: @"snippet" ]; break;
                case TRSRestResponseVerboseFlagIdentifier: [ parts addObject: @"id" ]; break;
                case TRSRestResponseVerboseFlagContentDetails: [ parts addObject: @"contentDetails" ]; break;
                case TRSRestResponseVerboseFlagStatus: [ parts addObject: @"status" ]; break;
                case TRSRestResponseVerboseFlagLocalizations: [ parts addObject: @"localizations" ]; break;
                case TRSRestResponseVerboseFlagSubscriberSnippet: [ parts addObject: @"subscriberSnippet" ]; break;
                case TRSRestResponseVerboseFlagReplies: [ parts addObject: @"replies" ]; break;
                case TRSRestResponseVerboseFlagStatistics: [ parts addObject: @"statistics" ]; break;
                }
            }
        } ];

    return [ parts componentsJoinedByString: @"," ];
    }

#pragma mark - Identifying and Comparing Strings

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