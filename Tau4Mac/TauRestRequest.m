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

    for ( int _Index = 0; _Index < 7; _Index++ )
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

                case TRSRestRequestVerboseFlagUnknown:;
                }
            }
        }

    return [ parts componentsJoinedByString: @"," ];
    }

@end // NSString + TauRestRequestInitializing

// TauRestRequest class
@implementation TauRestRequest

@synthesize type, fieldFilter, maxResultsPerPage, verboseLevelMask, prevPageToken, nextPageToken;
@dynamic isMine, YouTubeQuery;

#pragma mark - Commons Initializing

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        verboseLevelMask = TRSRestRequestVerboseFlagSnippet;

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

        NSString* arg2 = [ NSString stringWithTauRestRequestVerboseLevelMask: self.verboseLevelMask ];
        [ queryFactoryInvocation_ setArgument: &arg2 atIndex: 2 ];
        }

    return self;
    }

#pragma mark - Conforms to <NSCopying>
// TODO:

#pragma mark - Conforms to <NSSecureCoding>

+ ( BOOL ) supportsSecureCoding
    {
    return [ self conformsToProtocol: @protocol( NSSecureCoding ) ];
    }

// TODO:

@end // TauRestRequest class