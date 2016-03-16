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
@interface TestsCentralDataServiceMachanism : TauTestCase <TauYTDataServiceConsumer>
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
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: credential_ ];
    }

#define PAGE_LOOP 8 * 2

- ( void ) executeConsumerOperations_: ( NSDictionary* )_OperationsDict expec_: ( XCTestExpectation* )_Expec neg: ( BOOL )_IsNeg
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

            [ self executeConsumerOperations_: newOperationsDict expec_: _Expec neg: _IsNeg ];
            }
        // Paging Up
        else if ( _PrevPageToken && ( recursionCount >= ( PAGE_LOOP / 2 ) ) && ( recursionCount < PAGE_LOOP ) )
            {
            NSMutableDictionary* newOperationsDict = [ _OperationsDict mutableCopy ];
            newOperationsDict[ TauYTDataServiceDataActionPageToken ] = _PrevPageToken;

            [ self executeConsumerOperations_: newOperationsDict expec_: _Expec neg: _IsNeg ];
            }
        else
            [ _Expec fulfill ];
        } failure:
            ^( NSError* _Error )
                {
                if ( _IsNeg )
                    {
                    XCTAssertNotNil( _Error );
                    XCTAssert( [ _Error.domain isEqualToString: TauGeneralErrorDomain ] || [ _Error.domain isEqualToString: TauCentralDataServiceErrorDomain ] );

                    DDLogInfo( @"Expected error: {%@}", _Error );
                    }
                else
                    XCTFail( @"%@ {currentOperationsDict:%@}", _Error, _OperationsDict );

                [ _Expec fulfill ];
                } ];
    }

- ( void ) testDataServiceDataAction_pos0
    {
    XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];

    NSDictionary* operationsDict = @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
                                    , TauYTDataServiceDataActionRequirements :
                                        @{ TauYTDataServiceDataActionRequirementQ : @"Evernote" }
                                    };

    [ self executeConsumerOperations_: operationsDict expec_: expec neg: NO ];

    [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
    ^( NSError* _Nullable _Error )
        {
        DDLogUnexpected( @"%@", _Error );
        } ];
    }

- ( void ) testDataServiceDataAction_neg0
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: credential_ ];

    XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];

    NSDictionary* operationsDict = @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
                                    , TauYTDataServiceDataActionRequirements :
                                        @{ TauYTDataServiceDataActionRequirementQ : @"Evernote" }
                                    };

    [ self executeConsumerOperations_: operationsDict expec_: expec neg: YES ];

    [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
    ^( NSError* _Nullable _Error )
        {
        DDLogUnexpected( @"%@", _Error );
        } ];
    }

@end // TestsCentralDataServiceMachanism class