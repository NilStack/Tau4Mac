//
//  TestsTauRestService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TestsTauRestService.h"

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

- ( void ) testCreatingReadOnlyRestRequest
    {
    unsigned int count = 0;

    struct objc_method_description* descrps = protocol_copyMethodDescriptionList( @protocol( TauRestListingRequests ), YES, YES, &count );
    NSLog( @"count=%u", count );
    for ( int _index = 0; _index < count; _index++ )
        {
        struct objc_method_description desc = *( descrps + _index );
        SEL name = desc.name;
        Method method = class_getInstanceMethod( NSClassFromString( @"TauRestRequest" ), name );
        NSLog( @"%@ paraCnt=%u", NSStringFromSelector( name ), method_getNumberOfArguments( method ) );
        }

    free( descrps );

//    Method* methodsList = class_copyMethodList( NSClassFromString( @"TauRestRequest" ), &count );
//    for ( int _Index = 0; _Index < count; _Index++ )
//        {
//        SEL name = method_getName( *( methodsList + _Index ) );
//        NSLog( @"%@ paraCnt=%u", NSStringFromSelector( name ), method_getNumberOfArguments( *( methodsList + _Index ) ) );
//        }
//
//    free( methodsList );

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

@end // TestsTauRestService test case