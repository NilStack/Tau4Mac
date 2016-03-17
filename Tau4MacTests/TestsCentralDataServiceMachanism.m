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
@property ( strong, readwrite ) NSArray <GTLYouTubePlaylist*>* playlists;
@property ( strong, readwrite ) NSArray <GTLYouTubePlaylistItem*>* playlistItems;

@end // TestsCentralDataServiceMachanism class

// TestsCentralDataServiceMachanism class
@implementation TestsCentralDataServiceMachanism
    {
    TauYTDataService __weak* sharedDataService_;

    TauYTDataServiceCredential __strong* searchResultsConsCredential_;
    TauYTDataServiceCredential __strong* channelsConsCredential_;
    TauYTDataServiceCredential __strong* playlistsConsCredential_;
    TauYTDataServiceCredential __strong* playlistItemsConsCredential_;

    NSArray <NSDictionary*> __strong* posSearchResultsInitialOperations_;
    NSArray <NSDictionary*> __strong* posChannelsInitialOperations_;
    NSArray <NSDictionary*> __strong* posPlaylistsInitialOperations_;
    NSArray <NSDictionary*> __strong* posPlaylistItemsInitialOperations_;

    NSArray <NSDictionary*> __strong* negSearchResultsInitialOperations_;
    NSArray <NSDictionary*> __strong* negChannelsInitialOperations_;
    NSArray <NSDictionary*> __strong* negPlaylistsInitialOperations_;
    NSArray <NSDictionary*> __strong* negPlaylistItemsInitialOperations_;
    }

/// KVO Observable End ----------------------------------------------------------------------------------

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

@synthesize playlists = playlists_;

- ( NSUInteger ) countOfPlaylists
    {
    return playlists_.count;
    }

- ( NSArray* ) playlistsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ playlists_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getPlaylists:( GTLYouTubePlaylist* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ playlists_ getObjects: _Buffer range: _InRange ];
    }

@synthesize playlistItems = playlistItems_;

- ( NSUInteger ) countOfPlaylistItems
    {
    return playlistItems_.count;
    }

- ( NSArray* ) playlistItemsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ playlistItems_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getPlaylistItems:( GTLYouTubePlaylistItem* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ playlistItems_ getObjects: _Buffer range: _InRange ];
    }

/// KVO Observable End ----------------------------------------------------------------------------------

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
    playlistsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauYTDataServiceConsumptionPlaylistsType ];
    playlistItemsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauYTDataServiceConsumptionPlaylistItemsType ];

    // Search Results
    posSearchResultsInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"Evernote" }
            , TauYTDataServiceDataActionPartFilter : @"snippet"
            }

         , @{ TauYTDataServiceDataActionMaxResultsPerPage : @30
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"Vevo" }
            , TauYTDataServiceDataActionPartFilter : @"snippet"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"GoPro" }
            , TauYTDataServiceDataActionPartFilter : @"snippet"
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

         , @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementQ : @"Evernote" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            }
         ];

    // Channels
    posChannelsInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementID : @"UCqhnX4jA0A5paNd1v-zEysw" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            , TauYTDataServiceDataActionFieldsFilter : @"items( id ), items( snippet( title, description) )"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }
            , TauYTDataServiceDataActionPartFilter : @"contentDetails"
            , TauYTDataServiceDataActionFieldsFilter : @"items( id ), items( snippet( title, description) )"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementID : @"UC2rCynaFhWz7MeRoqJLvcow" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            }
         ];

    negChannelsInitialOperations_ =
        @[ @{}
         , @{ TauYTDataServiceDataActionRequirements : @[ @"Microsoft" ] }
         ];

    // Playlists
    posPlaylistsInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementChannelID : @"UCqhnX4jA0A5paNd1v-zEysw" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementChannelID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            , TauYTDataServiceDataActionFieldsFilter : @"items( id ), items( snippet( title, description) )"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementChannelID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }
            , TauYTDataServiceDataActionPartFilter : @"contentDetails"
            , TauYTDataServiceDataActionFieldsFilter : @"items( id ), items( snippet( title, description) )"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementChannelID : @"UC2rCynaFhWz7MeRoqJLvcow" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            }
         ];

    negPlaylistsInitialOperations_ =
        @[ @{}
         , @{ TauYTDataServiceDataActionRequirements : @[ @"Microsoft" ] }
         ];

    // Playlist Items
    posPlaylistItemsInitialOperations_ =
        @[ @{ TauYTDataServiceDataActionMaxResultsPerPage : @10
            , TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementPlaylistID : @"PLFCZYV79qT1G7xZCY47q2njj262r3GvR3" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementPlaylistID : @"PLSvNPF6CgrdhmLFEd9rjZeFDs9E6Htqlj" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            , TauYTDataServiceDataActionFieldsFilter : @"items( id ), items( snippet( title, description) )"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementPlaylistID : @"PLhKFRV3-UgpeA_3wzRHF8AS8T7ppKvm9O" }
            , TauYTDataServiceDataActionPartFilter : @"contentDetails"
            , TauYTDataServiceDataActionFieldsFilter : @"items( id ), items( snippet( title, description) )"
            }

         , @{ TauYTDataServiceDataActionRequirements :
                @{ TauYTDataServiceDataActionRequirementPlaylistID : @"PL2Qq6_3SVp4P4N0Wyusc_-256lXZ3DVsw" }
            , TauYTDataServiceDataActionPartFilter : @"snippet,contentDetails"
            }
         ];

    negPlaylistItemsInitialOperations_ =
        @[ @{}
         , @{ TauYTDataServiceDataActionRequirements : @[ @"Microsoft" ] }
         ];
    }

- ( void ) tearDown
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: searchResultsConsCredential_ ];
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: channelsConsCredential_ ];
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: playlistsConsCredential_ ];
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: playlistItemsConsCredential_ ];
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

        DDLogVerbose( @"{prevPageToken:%@} {nextPageToken:%@}\n%@", _PrevPageToken, _NextPageToken, searchResults_ );

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
                    XCTAssert( [ _Error.domain isEqualToString: TauGeneralErrorDomain ]
                                    || [ _Error.domain isEqualToString: TauCentralDataServiceErrorDomain ]
                                    || [ _Error.domain isEqualToString: TauUnderlyingErrorDomain ]
                             , "Unexpected error domain {%@}", _Error.domain );

                    DDLogInfo( @"Expected error: {%@}", _Error );
                    }
                else
                    XCTFail( @"%@ {currentOperationsDict:%@}", _Error, _OperationsDict );

                recursionCount = 0;
                [ _Expec fulfill ];
                } ];
    }

#pragma mark - Positive Test

// Search Results

- ( void ) testDataServiceDataSearchResultsListAction_pos0
    {
    for ( NSDictionary* _OperationsCombination in posSearchResultsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: searchResultsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

// Channels

- ( void ) testDataServiceDataChannelsListAction_pos0
    {
    for ( NSDictionary* _OperationsCombination in posChannelsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: channelsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

// Playlists

- ( void ) testDataServiceDataPlaylistsListAction_pos0
    {
    for ( NSDictionary* _OperationsCombination in posPlaylistsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: playlistsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

// Playlist Items

- ( void ) testDataServiceDataPlaylistItemsListAction_pos0
    {
    for ( NSDictionary* _OperationsCombination in posPlaylistItemsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: playlistItemsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

#pragma mark - Negative Test

// Search Results

- ( void ) testDataServiceDataResultsListAction_neg0
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: searchResultsConsCredential_ ];

    for ( NSDictionary* _OperationsCombination in posSearchResultsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: searchResultsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }

    searchResultsConsCredential_ =
        [ [ TauYTDataService sharedService ] registerConsumer: self
                                          withMethodSignature: [ self methodSignatureForSelector: _cmd ]
                                              consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
    }

- ( void ) testDataServiceDataResultsListAction_neg1
    {
    for ( NSDictionary* _OperationsCombination in negSearchResultsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: searchResultsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

// Channels

- ( void ) testDataServiceDataChannelsListAction_neg0
    {
    for ( NSDictionary* _OperationsCombination in negChannelsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: channelsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

// Playlists

- ( void ) testDataServiceDataPlaylistsListAction_neg0
    {
    for ( NSDictionary* _OperationsCombination in negPlaylistsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: playlistsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

// Playlists

- ( void ) testDataServiceDataPlaylistItemsListAction_neg0
    {
    for ( NSDictionary* _OperationsCombination in negPlaylistItemsInitialOperations_ )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeConsumerOperations_: _OperationsCombination credential_: playlistItemsConsCredential_ expec_: expec onBehalfOf_: _cmd ];

        [ self waitForExpectationsWithTimeout: PAGE_LOOP * 20.f handler:
        ^( NSError* _Nullable _Error )
            {
            if ( _Error )
                DDLogFatal( @"%@", _Error );
            else
                DDLogInfo( @"Finished expectation {expec}" );
            } ];
        }
    }

@end // TestsCentralDataServiceMachanism class