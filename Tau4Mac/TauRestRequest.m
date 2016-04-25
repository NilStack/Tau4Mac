//
//  TauRestRequest.m
//  Tau4Mac
//
//  Created by Tong G. on 4/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauRestRequest.h"

// Private
@interface TauRestRequest ()
@end // Private

// NSString + TauRestRequestInitializing
@interface NSString ( TauRestRequestInitializing )
#pragma mark - Creating and Initializing String
+ ( instancetype ) stringWithTauRestRequestVerboseLevelMask: ( TRSRestResponseVerboseFlag )_Mask;
@end

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

@end // NSString + TauRestRequestInitializing

// TauRestRequest class
@implementation TauRestRequest

#pragma mark - Commons Initializing

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        ;
//        responseVerboseLevelMask_ = TRSRestRequestVerboseFlagSnippet;

    return self;
    }

#pragma mark - youtube.search.list

- ( instancetype ) initSearchResultsRequestWithQ: ( NSString* )_Q
    {
    if ( self = [ self init ] )
        {
        SEL sel = @selector( queryForSearchListWithPart: );
        queryFactoryInvocation_ = [ NSInvocation invocationWithMethodSignature: [ GTLQueryYouTube methodSignatureForSelector: sel ] ];
        [ queryFactoryInvocation_ setSelector: sel ];
        [ queryFactoryInvocation_ setTarget: [ GTLQueryYouTube class ] ];

        [ self setResponseVerboseLevelMask: TRSRestRequestVerboseFlagSnippet ];
        }

    return self;
    }

#pragma mark - External Properties

@synthesize type = type_;
@synthesize fieldFilter = fieldFilter_;
@synthesize maxResultsPerPage = maxResultsPerPage_;

@synthesize responseVerboseLevelMask = responseVerboseLevelMask_;
- ( void ) setResponseVerboseLevelMask: ( TRSRestResponseVerboseFlag )_New
    {
    if ( responseVerboseLevelMask_ != _New )
        {
        responseVerboseLevelMask_ = _New;

        if ( queryFactoryInvocation_.methodSignature.numberOfArguments == 2 )
            return;

        NSString* stringizedSel = NSStringFromSelector( queryFactoryInvocation_.selector );
        NSArray <NSString*>* argFragments = [ stringizedSel componentsSeparatedByString: @":" ];
        for ( NSString* _Arg in argFragments )
            {
            NSRange range = [ _Arg rangeOfString: @"part" options: NSCaseInsensitiveSearch | NSBackwardsSearch | NSAnchoredSearch ];
            if ( range.location != NSNotFound )
                {
                NSString* arg2 = [ NSString stringWithTauRestRequestVerboseLevelMask: responseVerboseLevelMask_ ];
                NSUInteger argIndex = [ argFragments indexOfObject: _Arg ] + 2;
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

@dynamic isMine, YouTubeQuery;

#pragma mark - Conforms to <NSCopying>
// TODO:

#pragma mark - Conforms to <NSSecureCoding>

+ ( BOOL ) supportsSecureCoding
    {
    return [ self conformsToProtocol: @protocol( NSSecureCoding ) ];
    }

// TODO:

@end // TauRestRequest class