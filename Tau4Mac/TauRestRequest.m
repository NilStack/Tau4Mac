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

- ( void ) insertQueryConfigInvokWithSelector_: ( SEL )_Sel arguments_: ( void* _Nonnull )_FirstArg, ... NS_REQUIRES_NIL_TERMINATION;

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
        [ self insertQueryConfigInvokWithSelector_: @selector( setFields: ) arguments_: &fieldFilter_, nil ];
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
        [ self insertQueryConfigInvokWithSelector_: @selector( setMaxResults: ) arguments_: &maxResultsPerPage_, nil ];
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

@synthesize pageToken = pageToken_;
- ( void ) setPageToken: ( NSString* )_New
    {
    if ( pageToken_ != _New )
        {
        pageToken_ = _New;
        [ self insertQueryConfigInvokWithSelector_: @selector( setPageToken: ) arguments_: &pageToken_, nil ];
        }
    }

- ( NSString* ) pageToken
    {
    return pageToken_;
    }

@dynamic isMine;

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
        result = res;

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

#define TAU_ARG_FIRST_IDX 2

- ( void ) insertQueryConfigInvokWithSelector_: ( SEL )_Sel arguments_: ( void* _Nonnull )_FirstArg, ... NS_REQUIRES_NIL_TERMINATION
    {
    BOOL isDiscardable = YES;
    NSInvocation* invok = nil;
    NSMethodSignature* sig = nil;

    isDiscardable = !( *( ( char* )_FirstArg ) );

    sig = [ [ [ GTLQueryYouTube alloc ] init ] methodSignatureForSelector: _Sel ];
    invok = [ NSInvocation invocationWithMethodSignature: sig ];
    [ invok setSelector: _Sel ];
    [ invok setArgument: _FirstArg atIndex: TAU_ARG_FIRST_IDX ];

    NSUInteger argIdx = TAU_ARG_FIRST_IDX + 1;
    va_list argv;
    va_start( argv, _FirstArg );
    while ( true )
        {
        void* arg = va_arg( argv, void* );
        if ( !arg ) break;
        [ invok setArgument: arg atIndex: argIdx++ ];

        if ( isDiscardable )
            isDiscardable = !( *( ( char* )arg ) );
        } va_end( argv );

    self.queryConfigInvocationsMap_[ NSStringFromSelector( _Sel ) ]
        = isDiscardable ? nil : invok;
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