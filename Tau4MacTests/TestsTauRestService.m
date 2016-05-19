//
//  TestsTauRestService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TestsTauRestService.h"

enum { kTypeSearchResults = TRSRestRequestTypeSearchResultsList
     , kTypeChannelsList = TRSRestRequestTypeChannelsList
     , kTypePlaylistsList = TRSRestRequestTypePlaylistsList
     , kTypePlaylistItemsList = TRSRestRequestTypePlaylistItemsList
     , kTypeSubscriptionsList = TRSRestRequestTypeSubscriptionsList
     , kTypeVideosList = TRSRestRequestTypeVideosList
     , kTypeUnknown = TRSRestRequestTypeUnknown
     , kTypeOthers = TRSRestRequestTypeOthers
     };

// TestsTauRestService test case
@implementation TestsTauRestService

- ( void ) setUp
    {
    [ super setUp ];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [ super tearDown ];
    }

- ( int ) type_: ( NSString* )_String
    {
    TRSRestRequestType resultsType = kTypeUnknown;

    if ( [ _String isEqualToString: @"SearchResults" ] )
        resultsType = kTypeSearchResults;
    else if ( [ _String isEqualToString: @"Channel" ] || [ _String isEqualToString: @"Channels" ] )
        resultsType = kTypeChannelsList;
    else if ( [ _String isEqualToString: @"Playlist" ] || [ _String isEqualToString: @"Playlists" ] )
        resultsType = kTypePlaylistsList;
    else if ( [ _String isEqualToString: @"PlaylistItem" ] || [ _String isEqualToString: @"PlaylistItems" ] )
        resultsType = kTypePlaylistItemsList;
    else if ( [ _String isEqualToString: @"Subscriptions" ] )
        resultsType = kTypeSubscriptionsList;
    else if ( [ _String isEqualToString: @"Video" ] || [ _String isEqualToString: @"Videos" ] )
        resultsType = kTypeVideosList;

    return resultsType;
    }

- ( void ) testCreatingReadOnlyRestRequest
    {
    unsigned int count = 0;
    struct objc_method_description* descrps = protocol_copyMethodDescriptionList( @protocol( TauRestListingRequests ), YES, YES, &count );

    for ( int _index = 0; _index < count; _index++ )
        {
        struct objc_method_description desc = *( descrps + _index );
        SEL sel = desc.name;
        NSString* selName = NSStringFromSelector( sel );
        NSMethodSignature* sig = [ NSMethodSignature signatureWithObjCTypes: desc.types ];

        NSInvocation* invok = [ NSInvocation invocationWithMethodSignature: sig ];
        [ invok setSelector: sel ];

        NSArray* components = [ [ selName stringByReplacingCharactersInRange: NSMakeRange( 0, @"init".length ) withString: @"" ] componentsSeparatedByString: @"RequestWith" ];

        TRSRestRequestType resultsType = [ self type_: components.firstObject ];

        NSUInteger length = [ components.lastObject rangeOfString: @"Identifier" options: NSBackwardsSearch ].location - 1;
        NSRange range = NSMakeRange( 0, length );
        TRSRestRequestType paramsType = [ self type_: [ components.lastObject substringWithRange: range ] ];
        NSString* keyPathTemplate = nil;
        switch ( paramsType )
            {
            case kTypeSearchResults: keyPathTemplate = @"channelIdentifiersSample"; break;
            case kTypeSearchResults: keyPathTemplate = @"channelIdentifiersSample"; break;
            case kTypeSearchResults: keyPathTemplate = @"channelIdentifiersSample"; break;
            case kTypeSearchResults: keyPathTemplate = @"channelIdentifiersSample"; break;
            case kTypeSearchResults: keyPathTemplate = @"channelIdentifiersSample"; break;
            }
        }

    free( descrps );

    TauRestRequest* searchRequest = [ [ TauRestRequest alloc ] initSearchResultsRequestWithQ: @"gopro" ];
    XCTAssertNotNil( searchRequest );

    GTLQueryYouTube* YouTubeQuery = nil;

    searchRequest.maxResultsPerPage = @50;
    searchRequest.fieldFilter = @"items(id,snippet,statistics)";
    YouTubeQuery = [ searchRequest YouTubeQuery ];

    searchRequest.fieldFilter = nil;
    searchRequest.maxResultsPerPage = @9;
    searchRequest.maxResultsPerPage = @0;
    YouTubeQuery = [ searchRequest YouTubeQuery ];

    searchRequest = [ [ TauRestRequest alloc ] initChannelsRequestWithChannelIdentifiers: @[ @"UCqhnX4jA0A5paNd1v-zEysw", @"UClwg08ECyHnm_RzY1wnZC1A", @"UCqhnX4jA0A5paNd1v-zEysw" ] ];
    searchRequest.fieldFilter = @"items(snippet)";
    searchRequest.maxResultsPerPage = @30;
    searchRequest.responseVerboseLevelMask |=
        TRSRestResponseVerboseFlagContentDetails | TRSRestResponseVerboseFlagStatistics;
        
    YouTubeQuery = [ searchRequest YouTubeQuery ];
    }

@end // TestsTauRestService test ca