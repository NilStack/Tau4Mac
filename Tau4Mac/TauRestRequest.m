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

@property ( strong, readonly ) NSMutableDictionary <NSString*, NSInvocation*>* queryConfigInvocationsMap_;

- ( void ) insertQueryConfigInvokWithSelector_: ( SEL )_Sel arguments: ( void* _Nonnull )_FirstArg, ... NS_REQUIRES_NIL_TERMINATION;

@end // Private

// TauRestRequest class
@implementation TauRestRequest

#pragma mark - youtube.search.list

- ( instancetype ) initSearchResultsRequestWithQ: ( NSString* )_Q
    {
    if ( self = [ super init ] )
        {
        SEL sel = @selector( queryForSearchListWithPart: );
        queryFactoryInvocation_ = [ NSInvocation invocationWithMethodSignature: [ GTLQueryYouTube methodSignatureForSelector: sel ] ];
        [ queryFactoryInvocation_ setSelector: sel ];
        [ queryFactoryInvocation_ setTarget: [ GTLQueryYouTube class ] ];

        [ self setResponseVerboseLevelMask: TRSRestRequestVerboseFlagSnippet ];

        type_ = TRSRestRequestTypeSearchList;
        }

    return self;
    }

#pragma mark - External Properties

@synthesize type = type_;

@synthesize fieldFilter = fieldFilter_;
- ( void ) setFieldFilter: ( NSString* )_New
    {
    if ( fieldFilter_ != _New )
        {
        fieldFilter_ = _New;
        [ self insertQueryConfigInvokWithSelector_: @selector( setFields: ) arguments: &fieldFilter_, nil ];
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
        [ self insertQueryConfigInvokWithSelector_: @selector( setMaxResults: ) arguments: &maxResultsPerPage_, nil ];
        }
    }

- ( NSUInteger ) maxResultsPerPage
    {
    return maxResultsPerPage_;
    }

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

@synthesize prevPageToken = prevPageToken_;
@synthesize nextPageToken = nextPageToken_;

@dynamic isMine;

@dynamic YouTubeQuery;
- ( GTLQueryYouTube* ) YouTubeQuery
    {
    GTLQueryYouTube* result = nil;

    NSInvocation* queryFactoryInvok = queryFactoryInvocation_;
    if ( queryFactoryInvok )
        {
        [ queryFactoryInvok invoke ];

        [ queryFactoryInvok getReturnValue: &result ];

        if ( result )
            for ( NSString* _key in priQueryConfigInvocationsMap_ )
                [ priQueryConfigInvocationsMap_[ _key ] invokeWithTarget: result ];
        }

    return result;
    }

#pragma mark - Conforms to <NSCopying>
// TODO:

#pragma mark - Conforms to <NSSecureCoding>

+ ( BOOL ) supportsSecureCoding
    {
    return [ self conformsToProtocol: @protocol( NSSecureCoding ) ];
    }

// TODO:

#pragma mark - Private

@synthesize queryConfigInvocationsMap_ = priQueryConfigInvocationsMap_;
- ( NSMutableDictionary <NSString*, NSInvocation*>* ) queryConfigInvocationsMap_
    {
    if ( !priQueryConfigInvocationsMap_ )
        priQueryConfigInvocationsMap_ = [ NSMutableDictionary dictionary ];
    return priQueryConfigInvocationsMap_;
    }

- ( void ) insertQueryConfigInvokWithSelector_: ( SEL )_Sel arguments: ( void* _Nonnull )_FirstArg, ... NS_REQUIRES_NIL_TERMINATION
    {
    NSMethodSignature* sig = [ [ [ GTLQueryYouTube alloc ] init ] methodSignatureForSelector: _Sel ];
    NSInvocation* invok = [ NSInvocation invocationWithMethodSignature: sig ];
    [ invok setSelector: _Sel ];

//    if ( !( *_FirstArg ) )
//        {
        [ self.queryConfigInvocationsMap_ removeObjectForKey: NSStringFromSelector( _Sel ) ];
//        return;
//        }

    [ invok setArgument: _FirstArg atIndex: 2 ];

    NSUInteger argIdx = 3;
    va_list variableArguments;
    va_start( variableArguments, _FirstArg );
    while ( true )
        {
        void* arg = va_arg( variableArguments, void* );
        if ( !arg ) break;
        [ invok setArgument: arg atIndex: argIdx++ ];
        } va_end( variableArguments );

    self.queryConfigInvocationsMap_[ NSStringFromSelector( _Sel ) ] = invok;
    }

@end // TauRestRequest class



// -----------------------------------------------------//



@implementation NSString ( TauRestRequestInitializing )

#pragma mark - Creating and Initializing String

+ ( instancetype ) stringWithTauRestRequestVerboseLevelMask: ( TRSRestResponseVerboseFlag )_Mask
    {
    NSMutableArray <NSString*>* parts = [ NSMutableArray array ];

    NSMutableIndexSet* flagsRanges = [ NSMutableIndexSet indexSet ];
    [ flagsRanges addIndexesInRange: NSMakeRange( 0, 7 ) ];

    [ flagsRanges enumerateIndexesUsingBlock:
    ^( NSUInteger _Index, BOOL* _Nonnull _Stop )
        {
        TRSRestResponseVerboseFlag flag = ( 1 << _Index );
        if ( _Mask & flag )
            {
            switch ( flag )
                {
                case TRSRestRequestVerboseFlagSnippet: [ parts addObject: @"snippet" ]; break;
                case TRSRestRequestVerboseFlagIdentifier: [ parts addObject: @"id" ]; break;
                case TRSRestRequestVerboseFlagContentDetails: [ parts addObject: @"contentDetails" ]; break;
                case TRSRestRequestVerboseFlagStatus: [ parts addObject: @"status" ]; break;
                case TRSRestRequestVerboseFlagLocalizations: [ parts addObject: @"localizations" ]; break;
                case TRSRestRequestVerboseFlagSubscriberSnippet: [ parts addObject: @"subscriberSnippet" ]; break;
                case TRSRestRequestVerboseFlagReplies: [ parts addObject: @"replies" ]; break;
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