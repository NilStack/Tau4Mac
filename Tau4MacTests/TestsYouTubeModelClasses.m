//
//  TestsYouTubeModelClasses.m
//  TestsYouTubeModelClasses
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeSearchResultsCollection.h"
#import "TauYouTubeChannelsCollection.h"
#import "TauYouTubePlaylistsCollection.h"
#import "TauYouTubePlaylistItemsCollection.h"

#import "TauDataService.h"

// TestsYouTubeModelClasses class
@interface TestsYouTubeModelClasses : TauTestCase

@property ( strong, readwrite ) TauYouTubeSearchResultsCollection* sampleSearchResultsCollection;
@property ( strong, readwrite ) TauYouTubeChannelsCollection*      sampleChannelsCollection;
@property ( strong, readwrite ) TauYouTubePlaylistsCollection*     samplePlaylistsCollection;
@property ( strong, readwrite ) TauYouTubePlaylistItemsCollection* samplePlaylistItemsCollection;

@end // TestsYouTubeModelClasses class

// Private Interfaces
@interface TestsYouTubeModelClasses ()
@end // Private Interfaces

uint64_t static const kTestsYouTubeSearchListCollectionKVOCtx;

#define TAU_UNITTEST_SAMPLES_COUNT 15

static NSString* const kYTSearchListQs[ TAU_UNITTEST_SAMPLES_COUNT ] =
    { @"vevo",           @"GitHub",           @"一梦如是",          @"張國榮",        @"goPro"
    , @"Microsoft",      @"announamous",      @"あべしんぞう",      @"Park Geun-hye", @"박근혜"
    , @"まつもとゆきひろ", @"بو القاسم محمد ..", @"富士山下（日文版）", @"陳奕迅 H3M",     @"chrome dev"
    };

static NSString* const kYTChannelIDs[ TAU_UNITTEST_SAMPLES_COUNT ] =
    { @"UCqhnX4jA0A5paNd1v-zEysw", @"UC2pmfLm7iq6Ov1UwYrWYkZA", @"UCANLZYMidaCbLQFWXBC95Jg", @"UCFtEEv80fQVKkD4h1PF-Xqw", @"UCGS474QoP8SCnSo6hOCaayA"
    , @"UCjBp_7RuDBUYbd1LegWEJ8g", @"UCq5x2uDU3aqVYATvX3v-nVQ", @"UC0KGpDrFQ3uSqS6ZGHzvU8A", @"UCAEym5kVuaRjzFQdeE23K2w", @"UCEayK1pXZjg7_SW_bKQFIyg"
    , @"UCE_M8A5yxnLfW0KghEeajjw", @"UCiwxpRbLr1eb0kSItK0shkQ", @"UCiDdS-Ef6ZunM81xxEFVFcA", @"UCK8sQmJBp8GCxrOtXWBpyEA", @"UCbmNph6atAoGfqLoCL_duAg"
    };

static NSString* const kYTPlaylistIDs[ TAU_UNITTEST_SAMPLES_COUNT ] =
    { @"PL9Wo98vCBoO9I8T3pBoXLv_C2F7MMY_Cl", @"PL88vTTLZAs9CL-jFbCtVTqnuUTV5omGud", @"PL2F4HeNkXu6dtzpNH5jRqimgdKb3CtvOB"
    , @"PL1I0u8UePoJZcT6A-hkQttpoyc1DkLLjh", @"PL3S4xVwLOZhR83yPSaqJuTGzy1pyRRIig", @"PLC04FVGblMYq2p7z_U_ekieqfxCnTkYPA"
    , @"PLZCHH_4VqpRjjNTKMyrV-hu3iyUvDgou8", @"PLZCHH_4VqpRjpQP36-XM1jb1E_JIxJZFJ", @"PLpPBvvcQT5f2FowhdXAW7toZdq3cK6Pg0"
    , @"PLMtk_lxNm7JSmNwwp5RaUdJGejbUcapqK", @"PLhXONM9sSRGm5mdvdK5ssfhBUpvEXtMvt", @"PLucHxMewR3TUqahXY0ltJ_fNIGP4hCl-u"
    , @"PL4dMPBSJB5muLPXw_X4RMqyj-BMLShT8I", @"PLvFYFNbi-IBFeP5ALr50hoOmKiYRMvzUq", @"PLWRJVI4Oj4IaYIWIpFlnRJ_v_fIaIl6Ey"
    };

// KVO
static const NSString* kYTGenModelCollectionKVOPaths[] =
    { @"resultsPerPage", @"totalResults", @"prevPageToken", @"nextPageToken" };

// TestsYouTubeModelClasses class
@implementation TestsYouTubeModelClasses
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
    }

- ( void ) tearDown
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [ super tearDown ];

    for ( int _Index = 0; _Index < ( sizeof( kYTGenModelCollectionKVOPaths ) / sizeof( *kYTGenModelCollectionKVOPaths ) ); _Index++ )
        [ self.sampleSearchResultsCollection removeObserver: self forKeyPath: ( NSString* )kYTGenModelCollectionKVOPaths[ _Index ] ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath ofObject: ( id )_Object change: ( NSDictionary <NSString*, id>* )_Change context: ( void* )_Ctx
    {
    if ( _Ctx == &kTestsYouTubeSearchListCollectionKVOCtx )
        DDLogVerbose( @"{%@} of %@ new: %@ old: %@ ctx: %p", _KeyPath, _Object, _Change[ NSKeyValueChangeNewKey ], _Change[ NSKeyValueChangeOldKey ], _Ctx );
    }

#pragma mark - Tests KVO Compliance of TauYouTubeSearchResultsCollection

@synthesize sampleSearchResultsCollection;

#define PAGE_LOOP 8

- ( GTLQueryYouTube* ) queryForTestingModelClass_: ( Class )_ModelClass rollingCount: ( NSUInteger )_RollingCount
    {
    NSParameterAssert( ( _ModelClass != nil ) );
    NSParameterAssert( ( _RollingCount <= TAU_UNITTEST_SAMPLES_COUNT ) );

    GTLQueryYouTube* ytQuery = nil;

    if ( _ModelClass == [ TauYouTubeSearchResultsCollection class ] )
        {
        ytQuery = [ GTLQueryYouTube queryForSearchListWithPart: @"snippet" ];
        ytQuery.q = kYTSearchListQs[ _RollingCount ];
        }

    else if ( _ModelClass == [ TauYouTubeChannelsCollection class ] )
        {
        ytQuery = [ GTLQueryYouTube queryForChannelsListWithPart: @"snippet,contentDetails" ];
        ytQuery.identifier = kYTChannelIDs[ _RollingCount ];
        }

    else if ( _ModelClass == [ TauYouTubePlaylistsCollection class ] )
        {
        ytQuery = [ GTLQueryYouTube queryForPlaylistsListWithPart: @"snippet,contentDetails" ];
        ytQuery.channelId = kYTChannelIDs[ _RollingCount ];
        }

    else if ( _ModelClass == [ TauYouTubePlaylistItemsCollection class ] )
        {
        ytQuery = [ GTLQueryYouTube queryForPlaylistItemsListWithPart: @"contentDetails,id,snippet,status" ];
        ytQuery.playlistId = kYTPlaylistIDs[ _RollingCount ];
        }

    ytQuery.maxResults = 10;

    return ytQuery;
    }

- ( XCTestExpectation* ) asyncExpecForModelClass_: ( Class )_ModelClass
    {
    NSParameterAssert( ( _ModelClass != nil ) );

    XCTestExpectation* expec = nil;
    NSString* descTemplate = @"tests-youtube.%@.%@";
    NSString* desc = nil;

    if ( _ModelClass == [ TauYouTubeSearchResultsCollection class ] )
        desc = [ NSString stringWithFormat: descTemplate, @"search", @"list" ];

    else if ( _ModelClass == [ TauYouTubeChannelsCollection class ] )
        desc = [ NSString stringWithFormat: descTemplate, @"channels", @"list" ];

    else if ( _ModelClass == [ TauYouTubePlaylistsCollection class ] )
        desc = [ NSString stringWithFormat: descTemplate, @"playlists", @"list" ];

    else if ( _ModelClass == [ TauYouTubePlaylistItemsCollection class ] )
        desc = [ NSString stringWithFormat: descTemplate, @"playlistItems", @"list" ];

    if ( desc )
        expec = [ self expectationWithDescription: desc ];

    return expec;
    }

- ( NSString* ) kvcKeyForSampleCollectionOfModelClass_: ( Class )_ModelClass
    {
    NSParameterAssert( ( _ModelClass != nil ) );

    NSString* kvcKey = nil;

    if ( _ModelClass == [ TauYouTubeSearchResultsCollection class ] )
        kvcKey = @"sampleSearchResultsCollection";

    else if ( _ModelClass == [ TauYouTubeChannelsCollection class ] )
        kvcKey = @"sampleChannelsCollection";

    else if ( _ModelClass == [ TauYouTubePlaylistsCollection class ] )
        kvcKey = @"samplePlaylistsCollection";

    else if ( _ModelClass == [ TauYouTubePlaylistItemsCollection class ] )
        kvcKey = @"samplePlaylistItemsCollection";

    return kvcKey;
    }

- ( NSSet <NSString*>* ) kvoPathsForCollectionOfModelClass_: ( Class )_ModelClass
    {
    NSParameterAssert( ( _ModelClass != nil ) );

    NSMutableSet* kvoPaths = [ NSMutableSet setWithObjects: kYTGenModelCollectionKVOPaths count: ( sizeof( kYTGenModelCollectionKVOPaths ) / sizeof( *kYTGenModelCollectionKVOPaths ) ) ];

    if ( _ModelClass == [ TauYouTubeSearchResultsCollection class ] )
        [ kvoPaths addObject: @"searchResults" ];

    else if ( _ModelClass == [ TauYouTubeChannelsCollection class ] )
        [ kvoPaths addObject: @"channels" ];

    else if ( _ModelClass == [ TauYouTubePlaylistsCollection class ] )
        [ kvoPaths addObject: @"playlists" ];

    else if ( _ModelClass == [ TauYouTubePlaylistItemsCollection class ] )
        [ kvoPaths addObject: @"playlistItems" ];

    return [ kvoPaths copy ];
    }

- ( void ) testYTSearchListResultsModel
    {
    [ self testModelClass_: [ TauYouTubeSearchResultsCollection class ] ];
    }

- ( void ) testYTChannelResultsModel
    {
    [ self testModelClass_: [ TauYouTubeChannelsCollection class ] ];
    }

- ( void ) testYTPlaylistResultsModel
    {
    [ self testModelClass_: [ TauYouTubePlaylistsCollection class ] ];
    }

- ( void ) testYTPlaylistItemResultsModel
    {
    [ self testModelClass_: [ TauYouTubePlaylistItemsCollection class ] ];
    }

- ( void ) testModelClass_: ( Class )_ModelClass
    {
    NSParameterAssert( ( _ModelClass != nil ) );

    for ( int _Index = 0; _Index < TAU_UNITTEST_SAMPLES_COUNT; _Index++ )
        {
        GTLQueryYouTube* ytQuery = [ self queryForTestingModelClass_: _ModelClass rollingCount: _Index ];

        XCTestExpectation* expec = [ self asyncExpecForModelClass_: _ModelClass ];

        [ ytService_ executeQuery: ytQuery completionHandler:
        ^( GTLServiceTicket* _Ticket, GTLCollectionObject* _Resp, NSError* _Error )
            {
            XCTAssertNotNil( _Resp );
            XCTAssertNil( _Error, @"%@", _Error );

            DDLogInfo( @"%@", _Resp );

            NSString* modelKVCKey = [ self kvcKeyForSampleCollectionOfModelClass_: _ModelClass ];
            if ( ![ self valueForKey: modelKVCKey ] )
                {
                TauAbstractResultCollection* resultCollection = [ [ _ModelClass alloc ] initWithGTLCollectionObject: _Resp ];
                [ self setValue: resultCollection forKey: modelKVCKey ];

                XCTAssertNotNil( [ self valueForKey: modelKVCKey ] );

                NSSet* kvoPaths = [ self kvoPathsForCollectionOfModelClass_: _ModelClass ];
                for ( NSString* _KVOPath in kvoPaths )
                    {
                    [ [ self valueForKey: modelKVCKey ]
                        addObserver: self forKeyPath: _KVOPath options: NSKeyValueObservingOptionNew
                                                                            | NSKeyValueObservingOptionOld
                                                                            | NSKeyValueObservingOptionInitial
                            context: ( void* )&kTestsYouTubeSearchListCollectionKVOCtx ];
                    }
                }
            else
                [ [ self valueForKey: modelKVCKey ] setYtCollectionObject: _Resp ];


            for ( int _Index = 0; _Index < PAGE_LOOP; _Index++ )
                {
                if ( [ [ self valueForKey: modelKVCKey ] nextPageToken ] )
                    {
                    NSError* err = nil;

                    GTLQueryYouTube* nextPageQuery = ytQuery;
                    nextPageQuery.pageToken = [ [ self valueForKey: modelKVCKey ] nextPageToken ];
                    nextPageQuery.maxResults += ( _Index < PAGE_LOOP / 2 ) ? 10 : -10;

                    GTLServiceTicket* ticket = [ ytService_ executeQuery: nextPageQuery completionHandler: nil ];
                    XCTAssert( ( ticket ) );

                    GTLCollectionObject* resp = nil;

                    // Wait synchronously for fetch to complete (strongly discouraged)
                    [ ytService_ waitForTicket: ticket timeout: TAU_TEST_ASYNC_TIMEOUT fetchedObject: &resp error: &err ];

                    XCTAssertNotNil( resp, @"%@ may time out", ticket );
                    XCTAssertNil( err, @"%@", err );
                    [ [ self valueForKey: modelKVCKey ] setYtCollectionObject: resp ];
                    }
                else
                    break;
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

@end // TestsYouTubeModelClasses class