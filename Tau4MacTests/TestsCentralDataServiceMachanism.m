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
@property ( strong, readwrite ) NSArray <GTLYouTubeChannel*>* channels;
@end // TestsCentralDataServiceMachanism class

// TestsCentralDataServiceMachanism class
@implementation TestsCentralDataServiceMachanism
    {
    TauYTDataService __weak* sharedDataService_;
    TauYTDataServiceCredential __strong* credential_;

    NSArray <GTLYouTubeSearchResult*>* searchResults_;
    NSArray <GTLYouTubeChannel*>* channels_;

    NSArray <NSDictionary*> __strong* posInitialOperations_;
    NSArray <NSDictionary*> __strong* negInitialOperations_;
    }

@synthesize searchResults = searchResults_;

- ( NSUInteger ) countOfSearchResults
    {
    return searchResults_.count;
    }

- ( NSArray* ) searchResultsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ searchResults_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getSearchResults: ( GTLYouTubeSearchResult * __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ searchResults_ getObjects: _Buffer range: _InRange ];
    }

@synthesize channels = channels_;

- ( NSUInteger ) countOfChannels
    {
    return channels_.count;
    }

- ( NSArray* ) channelsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ channels_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getChannels:( GTLYouTubeChannel* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ channels_ getObjects: _Buffer range: _InRange ];
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

    posInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"Evernote" }
            }

         , @{ TauYTDataServiceDataActionMaxResultsPerPage : @30
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"Vevo" }
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"GoPro" }
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"Apple" }
            , TauYTDataServiceDataActionMaxResultsPerPage : @4
            }
         ];

    negInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionRequirements : @{} }
         , @{ TauYTDataServiceDataActionMaxResultsPerPage : @20 }
         , @{ TauYTDataServiceDataActionRequirements : @[ @"Microsoft" ] }
         ];
    }

- ( void ) tearDown
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: credential_ ];
    }

#define PAGE_LOOP 8 * 2

- ( void ) executeConsumerOperations_: ( NSDictionary* )_OperationsDict expec_: ( XCTestExpectation* )_Expec onBehalfOf: ( SEL )_Sel
    {
    int static recursionCount;

    [ sharedDataService_ executeConsumerOperations: _OperationsDict
                                    withCredential: credential_
                                           success:
    ^( NSString* _PrevPageToken, NSString* _NextPageToken )
        {
        recursionCount++;

        DDLogInfo( @"{prevPageToken:%@} {nextPageToken:%@}\n%@", _PrevPageToken, _NextPageToken, searchResults_ );

        // Paging Down
        if ( _NextPageToken && recursionCount < ( PAGE_LOOP / 2 ) )
            {
            NSMutableDictionary* newOperationsDict = [ _OperationsDict mutableCopy ];
            newOperationsDict[ TauYTDataServiceDataActionPageToken ] = _NextPageToken;

            [ self executeConsumerOperations_: newOperationsDict expec_: _Expec onBehalfOf: _Sel ];
            }
        // Paging Up
        else if ( _PrevPageToken && ( recursionCount >= ( PAGE_LOOP / 2 ) ) && ( recursionCount < PAGE_LOOP ) )
            {
            NSMutableDictionary* newOperationsDict = [ _OperationsDict mutableCopy ];
            newOperationsDict[ TauYTDataServiceDataActionPageToken ] = _PrevPageToken;

            [ self executeConsumerOperations_: newOperationsDict expec_: _Expec onBehalfOf: _Sel ];
            }
        else
            {
            recursionCount = 0;
            [ _Expec fulfill ];

            // Get rid of recursion
            }
        } failure:
            ^( NSError* _Error )
                {
                // In positive test, &_Error ref should be populated
                if ( [ [ self class ] isTestMethodNegative: _Sel ] )
                    {
                    XCTAssertNotNil( _Error, @"Error parameter {%@} must not be nil in a nagative test", _Error );
                    XCTAssert( [ _Error.domain isEqualToString: TauGeneralErrorDomain ] || [ _Error.domain isEqualToString: TauCentralDataServiceErrorDomain ] );

                    DDLogInfo( @"Expected error: {%@}", _Error );
                    }
                else
                    XCTFail( @"%@ {currentOperationsDict:%@}", _Error, _OperationsDict );

                recursionCount = 0;
                [ _Expec fulfill ];
                } ];
    }

#pragma mark - Positive Test

- ( void ) testDataServiceDataAction_pos0
    {
    for ( NSDictionary* _OperationsCombination in posInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination expec_: expec onBehalfOf: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            DDLogFatal( @"%@", _Error );
            } ];
        }
    }

#pragma mark - Negative Test

- ( void ) testDataServiceDataAction_neg0
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: credential_ ];

    for ( NSDictionary* _OperationsCombination in posInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination expec_: expec onBehalfOf: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            DDLogFatal( @"%@", _Error );
            } ];
        }

    [ [ TauYTDataService sharedService ] registerConsumer: self
                                      withMethodSignature: [ self methodSignatureForSelector: _cmd ]
                                          consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
    }

- ( void ) testDataServiceDataAction_neg1
    {
    for ( NSDictionary* _OperationsCombination in negInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination expec_: expec onBehalfOf: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            DDLogFatal( @"%@", _Error );
            } ];
        }
    }

@end // TestsCentralDataServiceMachanism class