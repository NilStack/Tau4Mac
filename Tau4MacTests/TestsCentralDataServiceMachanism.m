//
//  TestsCentralDataServiceMachanism.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataService.h"
#import "TauYTDataServiceCredential.h"

// TestsCentralDataServiceMachanism class
@interface TestsCentralDataServiceMachanism : XCTestCase <TauYTDataServiceConsumer>
@property ( strong, readwrite ) NSArray <GTLYouTubeSearchResult*>* searchResults;
@end // TestsCentralDataServiceMachanism class

// TestsCentralDataServiceMachanism class
@implementation TestsCentralDataServiceMachanism
    {
    TauYTDataService __weak* sharedDataService_;

    TauYTDataServiceCredential __strong* credential_;

    NSArray <GTLYouTubeSearchResult*>* _searchResults;
    }

@synthesize searchResults = _searchResults;

- ( NSUInteger ) countOfSearchResults
    {
    return _searchResults.count;
    }

- ( NSArray* ) searchResultsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ _searchResults objectsAtIndexes: _Indexes ];
    }

- ( void ) getSearchResults: ( GTLYouTubeSearchResult * __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ _searchResults getObjects: _Buffer range: _InRange ];
    }

- ( void ) setUp
    {
    [ super setUp ];

    [ DDLog addLogger: [ DDTTYLogger sharedInstance ] ];

    sharedDataService_ = [ TauYTDataService sharedService ];
    NSMethodSignature* sig = [ self methodSignatureForSelector: _cmd ];

    // Because before accessing the keychain for a group of persistent OAuth credentials,
    // GTL checks preferences to verify that we've previously saved a token to the keychain
    // Make it think of we have previously saved one
    [ [ NSUserDefaults standardUserDefaults ] setBool: YES forKey: @"OAuth2: home.bedroom.TongKuo.Tau4Mac-dev" ];

    credential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
    XCTAssertNotNil( credential_ );
    XCTAssertNotNil( credential_.identifier );
    XCTAssertNotNil( credential_.applyingMethodSignature );
    XCTAssertNotEqual( credential_.consumptionType, 0 );
    XCTAssertNotEqual( credential_.consumerFingerprint, 0 );
    }

- ( void ) tearDown
    {
    // TODO:
    }

#define PAGE_LOOP 8 * 2

- ( void ) loop: ( NSDictionary* )_OperationsDict expec: ( XCTestExpectation* )_Expec
    {
    int static recursionCount;

    [ sharedDataService_ executeConsumerOperations: _OperationsDict
                                    withCredential: credential_
                                           success:
    ^( NSString* _PrevPageToken, NSString* _NextPageToken )
        {
        recursionCount++;

        DDLogInfo( @"{prevPageToken:%@} {nextPageToken:%@}\n%@", _PrevPageToken, _NextPageToken, _searchResults );

        // Paging Down
        if ( _NextPageToken && recursionCount < ( PAGE_LOOP / 2 ) )
            {
            NSMutableDictionary* newOperationsDict = [ _OperationsDict mutableCopy ];
            newOperationsDict[ TauYTDataServiceDataActionPageToken ] = _NextPageToken;

            [ self loop: newOperationsDict expec: _Expec ];
            }
        // Paging Up
        else if ( _PrevPageToken && ( recursionCount >= ( PAGE_LOOP / 2 ) ) && ( recursionCount < PAGE_LOOP ) )
            {
            NSMutableDictionary* newOperationsDict = [ _OperationsDict mutableCopy ];
            newOperationsDict[ TauYTDataServiceDataActionPageToken ] = _PrevPageToken;

            [ self loop: newOperationsDict expec: _Expec ];
            }
        else
            [ _Expec fulfill ];
        } failure:
            ^( NSError* _Error )
                {
                XCTFail( @"%@ {currentOperationsDict:%@}", _Error, _OperationsDict );
                [ _Expec fulfill ];
                } ];
    }

- ( void ) testDataServiceDataAction
    {
    XCTestExpectation* expec = [ self expectationWithDescription: @"expec" ];

    NSDictionary* operationsDict = @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
                                    , TauYTDataServiceDataActionRequirements :
                                        @{ TauYTDataServiceDataActionRequirementQ : @"Evernote" }
                                    };

    [ self loop: operationsDict expec: expec ];

    [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
    ^( NSError* _Nullable _Error )
        {
        DDLogUnexpected( @"%@", _Error );
        } ];
    }

@end // TestsCentralDataServiceMachanism class