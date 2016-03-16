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

- ( void ) testWhatever
    {
    XCTestExpectation* expec = [ self expectationWithDescription: @"expec" ];

    NSDictionary* operationsDict = @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
                                    , TauYTDataServiceDataActionRequirements :
                                        @{ TauYTDataServiceDataActionRequirementQ : @"Evernote" }
                                    };

    [ sharedDataService_ executeConsumerOperations: operationsDict withCredential: credential_
                                           success:
    ^( void )
        {
        DDLogInfo( @"%@", _searchResults );
        [ expec fulfill ];
        } failure:
            ^( NSError* _Error )
                {
                XCTFail( @"%@", _Error );
                } ];

    [ self waitForExpectationsWithTimeout: 10.f handler:
    ^( NSError* _Nullable _Error )
        {
        DDLogUnexpected( @"%@", _Error );
        } ];
    }

@end // TestsCentralDataServiceMachanism class