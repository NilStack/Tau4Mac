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

- ( void ) testInitializingTauRestRequest_pos0
    {
    TauRestRequest* searchRequest = [ [ TauRestRequest alloc ] initSearchResultsRequestWithQ: @"gopro" ];
    XCTAssertNotNil( searchRequest );

    GTLQueryYouTube* YouTubeQuery = nil;

    searchRequest.maxResultsPerPage = 50;
    searchRequest.fieldFilter = @"items(id,snippet,statistics)";
    YouTubeQuery = [ searchRequest YouTubeQuery ];

    searchRequest.fieldFilter = nil;
    searchRequest.maxResultsPerPage = 9;
    searchRequest.maxResultsPerPage = 0;
    YouTubeQuery = [ searchRequest YouTubeQuery ];
    }

@end // TestsTauRestService test case