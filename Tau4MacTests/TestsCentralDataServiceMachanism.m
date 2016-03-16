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

    TauYTDataServiceCredential __strong* searchResultsConsCredential_;
    TauYTDataServiceCredential __strong* channelsConsCredential_;
//    TauYTDataServiceCredential __strong* searchResultsConsCredential_;
//    TauYTDataServiceCredential __strong* searchResultsConsCredential_;

    NSArray <GTLYouTubeSearchResult*>* searchResults_;
    NSArray <GTLYouTubeChannel*>* channels_;

    NSArray <NSDictionary*> __strong* posSearchResultsInitialOperations_;
    NSArray <NSDictionary*> __strong* negSearchResultsInitialOperations_;

    NSArray <NSDictionary*> __strong* posChannelsInitialOperations_;
    NSArray <NSDictionary*> __strong* negChannelsInitialOperations_;
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

    searchResultsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
    channelsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauYTDataServiceConsumptionChannelsType ];

//    XCTAssertNotNil( searchResultsConsCredential_ );
//    XCTAssertNotNil( searchResultsConsCredential_.identifier );
//    XCTAssertNotNil( searchResultsConsCredential_.applyingMethodSignature );
//    XCTAssertNotEqual( searchResultsConsCredential_.consumptionType, 0 );
//    XCTAssertNotEqual( searchResultsConsCredential_.consumerFingerprint, 0 );

    posSearchResultsInitialOperations_ =
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

    negSearchResultsInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionRequirements : @{} }
         , @{ TauYTDataServiceDataActionMaxResultsPerPage : @20 }
         , @{ TauYTDataServiceDataActionRequirements : @[ @"Microsoft" ] }
         ];

    posChannelsInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementChannelID : @"UCqhnX4jA0A5paNd1v-zEysw" }
            }
         ];
    }

- ( void ) tearDown
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: searchResultsConsCredential_ ];
    }

#define PAGE_LOOP 8 * 2

- ( void ) executeConsumerOperations_: ( NSDictionary* )_OperationsDict
                          credential_: ( TauYTDataServiceCredential* )_Credential
                               expec_: ( XCTestExpectation* )_Expec
                          onBehalfOf_: ( SEL )_Sel
    {
    int static recursionCount;

    [ sharedDataService_ executeConsumerOperations: _OperationsDict
                                    withCredential: _Credential
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

            [ self executeConsumerOperations_: newOperationsDict credential_: _Credential expec_: _Expec onBehalfOf_: _Sel ];
            }
        // Paging Up
        else if ( _PrevPageToken && ( recursionCount >= ( PAGE_LOOP / 2 ) ) && ( recursionCount < PAGE_LOOP ) )
            {
            NSMutableDictionary* newOperationsDict = [ _OperationsDict mutableCopy ];
            newOperationsDict[ TauYTDataServiceDataActionPageToken ] = _PrevPageToken;

            [ self executeConsumerOperations_: newOperationsDict credential_: _Credential expec_: _Expec onBehalfOf_: _Sel ];
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

- ( void ) testDataServiceDataSearchResultsListAction_pos0
    {
    for ( NSDictionary* _OperationsCombination in posSearchResultsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: searchResultsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            DDLogFatal( @"%@", _Error );
            } ];
        }
    }

- ( void ) testDataServiceDataChannelsListAction_pos0
    {
    for ( NSDictionary* _OperationsCombination in posChannelsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: channelsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

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
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: searchResultsConsCredential_ ];

    for ( NSDictionary* _OperationsCombination in posSearchResultsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: searchResultsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

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
    for ( NSDictionary* _OperationsCombination in negSearchResultsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: searchResultsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            DDLogFatal( @"%@", _Error );
            } ];
        }
    }

@end // TestsCentralDataServiceMachanism class