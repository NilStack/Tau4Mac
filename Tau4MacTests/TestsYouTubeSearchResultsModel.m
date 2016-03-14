//
//  Tau4MacTests.m
//  Tau4MacTests
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeSearchResultCollection.h"
#import "TauDataService.h"

// Tau4MacTests class
@interface TestsYouTubeSearchResultsModel : XCTestCase

@property ( strong, readwrite ) TauYouTubeSearchResultCollection* sampleSearchResultCollection;

@end // Tau4MacTests class

// Private Interfaces
@interface TestsYouTubeSearchResultsModel ()
@end // Private Interfaces

uint64_t static const kTestsYouTubeSearchListCollectionKVOCtx;

static const NSString* kYTSearchListQs[] =
    { @"vevo", @"GitHub", @"一梦如是", @"張國榮", @"goPro", @"Microsoft", @"announamous"
    , @"あべしんぞう", @"Park Geun-hye", @"박근혜", @"まつもとゆきひろ", @"بو القاسم محمد .."
    };

static const NSString* kYTSearchResultsCollectionKVOPaths[] =
    { @"searchListResults", @"resultsPerPage", @"totalResults", @"prevPageToken", @"nextPageToken" };

// Tau4MacTests class
@implementation TestsYouTubeSearchResultsModel
    {
    TauDataService __weak* sharedDataSerivce_;
    GTLServiceYouTube __strong* ytService_;
    }

- ( void ) setUp
    {
    [ super setUp ];

    ytService_ = [ [ GTLServiceYouTube alloc ] init ];
    GTMOAuth2Authentication* oauth =
        [ GTMOAuth2Authentication authenticationWithServiceProvider: kGTMOAuth2ServiceProviderGoogle
                                                           tokenURL: [ NSURL URLWithString: @"https://www.googleapis.com/oauth2/v4/token" ]
                                                        redirectURI: @"urn:ietf:wg:oauth:2.0:oob"
                                                           clientID: @"889656423754-okdcqp9ujnlpc4ob5eno7l0658seoqo4.apps.googleusercontent.com"
                                                       clientSecret: @"C8tMCJMqle9fFtuBnMwODope" ];

    [ oauth setRefreshToken: @"1/Y--Nz4_kFVlM4HVwaC_4ZOUHOdE-uEbBL9qZ8K90XPs" ];
    [ oauth setUserEmail: @"contact@tong-kuo.me" ];
    [ oauth setScope: @"https://www.googleapis.com/auth/youtube.force-ssl https://www.googleapis.com/auth/userinfo.email" ];
    [ oauth setUserEmailIsVerified: @"1" ];
    [ oauth setUserID: @"109727319630804378943" ];
    [ ytService_ setAuthorizer: oauth ];
    [ ytService_ setUserAgent: @"home.bedroom.TongKuo.Tau4Mac.UnitTests" ];

    XCTAssertNotNil( ytService_ );

    [ DDLog addLogger: [ DDTTYLogger sharedInstance ] ];
    }

- ( void ) tearDown
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [ super tearDown ];

    for ( int _Index = 0; _Index < ( sizeof( kYTSearchResultsCollectionKVOPaths ) / sizeof( *kYTSearchResultsCollectionKVOPaths ) ); _Index++ )
        [ self.sampleSearchResultCollection removeObserver: self forKeyPath: ( NSString* )kYTSearchResultsCollectionKVOPaths[ _Index ] ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath ofObject: ( id )_Object change: ( NSDictionary <NSString*, id>* )_Change context: ( void* )_Ctx
    {
    if ( _Ctx == &kTestsYouTubeSearchListCollectionKVOCtx )
        DDLogVerbose( @"{%@} of %@ new: %@ old: %@ ctx: %p", _KeyPath, _Object, _Change[ NSKeyValueChangeNewKey ], _Change[ NSKeyValueChangeOldKey ], _Ctx );
    }

#pragma mark - Tests KVO Compliance of TauYouTubeSearchResultCollection

@synthesize sampleSearchResultCollection;

#define PAGE_LOOP 8

- ( void ) testYTSearchListResultsModel
    {
    for ( int _Index = 0; _Index < ( sizeof( kYTSearchListQs ) / sizeof( *kYTSearchListQs ) ); _Index++ )
        {
        NSString* searchString = ( NSString* )( kYTSearchListQs[ _Index ] );
        DDLogInfo( @"🍉%@", searchString );

        GTLQueryYouTube* searchListQuery = [ GTLQueryYouTube queryForSearchListWithPart: @"snippet" ];
        [ searchListQuery setMaxResults: 10 ];
        [ searchListQuery setQ: searchString ];

        XCTestExpectation* expec = [ self expectationWithDescription: @"tests-youtube.search.list" ];
        [ ytService_ executeQuery: searchListQuery completionHandler:
        ^( GTLServiceTicket* _Ticket, GTLYouTubeSearchListResponse* _SearchListResp, NSError* _Error )
            {
            XCTAssertNotNil( _SearchListResp );
            XCTAssertNil( _Error );

            DDLogInfo( @"%@", _SearchListResp );

            if ( !self.sampleSearchResultCollection )
                {
                self.sampleSearchResultCollection = [ [ TauYouTubeSearchResultCollection alloc ] initWithGTLCollectionObject: _SearchListResp ];
                XCTAssertNotNil( self.sampleSearchResultCollection );

                for ( int _Index = 0; _Index < ( sizeof( kYTSearchResultsCollectionKVOPaths ) / sizeof( *kYTSearchResultsCollectionKVOPaths ) ); _Index++ )
                    {
                    [ self.sampleSearchResultCollection addObserver: self
                                                         forKeyPath: ( NSString* )kYTSearchResultsCollectionKVOPaths[ _Index ]
                                                            options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                                                            context: ( void* )&kTestsYouTubeSearchListCollectionKVOCtx ];
                    }
                }
            else
                self.sampleSearchResultCollection.ytCollectionObject = _SearchListResp;

            XCTAssertNotNil( self.sampleSearchResultCollection.nextPageToken );
            for ( int _Index = 0; _Index < PAGE_LOOP; _Index++ )
                {
                NSError* err = nil;

                GTLQueryYouTube* nextPageQuery = searchListQuery;
                nextPageQuery.pageToken = self.sampleSearchResultCollection.nextPageToken;
                nextPageQuery.maxResults += ( _Index < PAGE_LOOP / 2 ) ? 10 : -10;

                GTLServiceTicket* ticket = [ ytService_ executeQuery: nextPageQuery completionHandler: nil ];
                XCTAssert( ( ticket ) );

                GTLCollectionObject* resp = nil;

                // Wait synchronously for fetch to complete (strongly discouraged)
                [ ytService_ waitForTicket: ticket timeout: TAU_TEST_ASYNC_TIMEOUT fetchedObject: &resp error: &err ];

                XCTAssertNotNil( resp, @"%@ may time out", ticket );
                XCTAssertNil( err, @"%@", err );
                self.sampleSearchResultCollection.ytCollectionObject = resp;
                }

            [ expec fulfill ];
            } ];

        [ self waitForExpectationsWithTimeout: ( PAGE_LOOP + 1 ) * TAU_TEST_ASYNC_TIMEOUT
                                     handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            } ];
        }
    }

@end // Tau4MacTests class