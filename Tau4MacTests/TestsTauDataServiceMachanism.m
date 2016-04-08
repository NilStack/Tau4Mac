//
//  TestsTauDataServiceMachanism.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAPIServiceCredential.h"

#define searchResults  searchResults
#define channels       channels
#define playlists      playlists
#define playlistItems  playlistItems

// TestsTauDataServiceMachanism class
@interface TestsTauDataServiceMachanism : TauTestCase <TauAPIServiceConsumer>

@property ( strong, readwrite ) TauYouTubeSearchResultsCollection*  searchResults;
@property ( strong, readwrite ) TauYouTubeChannelsCollection*       channels;
@property ( strong, readwrite ) TauYouTubePlaylistsCollection*      playlists;
@property ( strong, readwrite ) TauYouTubePlaylistItemsCollection*  playlistItems;

@end // TestsTauDataServiceMachanism class

// Private
@interface TestsTauDataServiceMachanism ()

- ( void ) loop_: ( NSString* )_ModelKey onBehalfOf_: ( SEL )_Sel;

- ( void ) executeTDSOperations_: ( NSDictionary* )_OperationsDict
                     credential_: ( TauAPIServiceCredential* )_Credential
                          expec_: ( XCTestExpectation* )_Expec
                     onBehalfOf_: ( SEL )_Sel;
@end // Private

// TestsTauDataServiceMachanism class
@implementation TestsTauDataServiceMachanism
    {
    TauAPIService __weak* sharedDataService_;

    TauAPIServiceCredential __strong* searchResultsConsCredential_;
    TauAPIServiceCredential __strong* channelsConsCredential_;
    TauAPIServiceCredential __strong* playlistsConsCredential_;
    TauAPIServiceCredential __strong* playlistItemsConsCredential_;

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
@synthesize channels = channels_;
@synthesize playlists = playlists_;
@synthesize playlistItems = playlistItems_;

/// KVO Observable End ----------------------------------------------------------------------------------

- ( void ) setUp
    {
    [ super setUp ];

    sharedDataService_ = [ TauAPIService sharedService ];
    NSMethodSignature* sig = [ self methodSignatureForSelector: _cmd ];

    // Because before accessing the keychain for a group of persistent OAuth credentials,
    // GTL checks preferences to verify that we've previously saved a token to the keychain
    // Make it think of we have previously saved one
    [ [ NSUserDefaults standardUserDefaults ] setBool: YES forKey: @"OAuth2: home.bedroom.TongKuo.Tau4Mac-dev" ];

    searchResultsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauAPIServiceConsumptionSearchResultsType ];
    channelsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauAPIServiceConsumptionChannelsType ];
    playlistsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauAPIServiceConsumptionPlaylistsType ];
    playlistItemsConsCredential_ = [ sharedDataService_ registerConsumer: self withMethodSignature: sig consumptionType: TauAPIServiceConsumptionPlaylistItemsType ];

    // Search Results
    posSearchResultsInitialOperations_ =
        @[ @{ TauTDSOperationMaxResultsPerPage : @10, TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : @"Evernote" }, TauTDSOperationPartFilter : @"snippet" }
         , @{ TauTDSOperationMaxResultsPerPage : @30, TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : @"Vevo" }, TauTDSOperationPartFilter : @"snippet" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : @"GoPro" }, TauTDSOperationPartFilter : @"snippet" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : @"Apple" }, TauTDSOperationMaxResultsPerPage : @4 }
         ];

    negSearchResultsInitialOperations_ =
        @[ @{ TauTDSOperationRequirements : @{} }, @{ TauTDSOperationMaxResultsPerPage : @20 }, @{ TauTDSOperationRequirements : @[ @"Microsoft" ] }
         , @{ TauTDSOperationMaxResultsPerPage : @10, TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : @"Evernote" }, TauTDSOperationPartFilter : @"snippet,contentDetails" }
         ];

    // Channels
    posChannelsInitialOperations_ =
        @[ @{ TauTDSOperationMaxResultsPerPage : @10, TauTDSOperationRequirements : @{ TauTDSOperationRequirementID : @"UCqhnX4jA0A5paNd1v-zEysw" }, TauTDSOperationPartFilter : @"snippet,contentDetails" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }, TauTDSOperationPartFilter : @"snippet,contentDetails", TauTDSOperationFieldsFilter : @"items( id ), items( snippet( title, description) )" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }, TauTDSOperationPartFilter : @"contentDetails", TauTDSOperationFieldsFilter : @"items( id ), items( snippet( title, description) )" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementID : @"UC2rCynaFhWz7MeRoqJLvcow" }, TauTDSOperationPartFilter : @"snippet,contentDetails" }
         ];

    negChannelsInitialOperations_ =
        @[ @{}, @{ TauTDSOperationRequirements : @[ @"Microsoft" ] }
         ];

    // Playlists
    posPlaylistsInitialOperations_ =
        @[ @{ TauTDSOperationMaxResultsPerPage : @10, TauTDSOperationRequirements : @{ TauTDSOperationRequirementChannelID : @"UCqhnX4jA0A5paNd1v-zEysw" }, TauTDSOperationPartFilter : @"snippet,contentDetails" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementChannelID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }, TauTDSOperationPartFilter : @"snippet,contentDetails", TauTDSOperationFieldsFilter : @"items( id ), items( snippet( title, description) )" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementChannelID : @"UC2pmfLm7iq6Ov1UwYrWYkZA" }, TauTDSOperationPartFilter : @"contentDetails", TauTDSOperationFieldsFilter : @"items( id ), items( snippet( title, description) )" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementChannelID : @"UC2rCynaFhWz7MeRoqJLvcow" }, TauTDSOperationPartFilter : @"snippet,contentDetails" }
         ];

    negPlaylistsInitialOperations_ =
        @[ @{}
         , @{ TauTDSOperationRequirements : @[ @"Microsoft" ] }
         ];

    // Playlist Items
    posPlaylistItemsInitialOperations_ =
        @[ @{ TauTDSOperationMaxResultsPerPage : @10, TauTDSOperationRequirements : @{ TauTDSOperationRequirementPlaylistID : @"PLFCZYV79qT1G7xZCY47q2njj262r3GvR3" }, TauTDSOperationPartFilter : @"snippet,contentDetails" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementPlaylistID : @"PLSvNPF6CgrdhmLFEd9rjZeFDs9E6Htqlj" }, TauTDSOperationPartFilter : @"snippet,contentDetails", TauTDSOperationFieldsFilter : @"items( id ), items( snippet( title, description) )" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementPlaylistID : @"PLhKFRV3-UgpeA_3wzRHF8AS8T7ppKvm9O" }, TauTDSOperationPartFilter : @"contentDetails", TauTDSOperationFieldsFilter : @"items( id ), items( snippet( title, description) )" }
         , @{ TauTDSOperationRequirements : @{ TauTDSOperationRequirementPlaylistID : @"PL2Qq6_3SVp4P4N0Wyusc_-256lXZ3DVsw" }, TauTDSOperationPartFilter : @"snippet,contentDetails" }
         ];

    negPlaylistItemsInitialOperations_ =
        @[ @{}
         , @{ TauTDSOperationRequirements : @[ @"Microsoft" ] }
         ];
    }

- ( void ) tearDown
    {
    [ [ TauAPIService sharedService ] unregisterConsumer: self withCredential: searchResultsConsCredential_ ];
    [ [ TauAPIService sharedService ] unregisterConsumer: self withCredential: channelsConsCredential_ ];
    [ [ TauAPIService sharedService ] unregisterConsumer: self withCredential: playlistsConsCredential_ ];
    [ [ TauAPIService sharedService ] unregisterConsumer: self withCredential: playlistItemsConsCredential_ ];
    }

#pragma mark - Positive Test

// Search Results

- ( void ) testTDS_searchResults_operationsCombination_pos0
    {
    [ self loop_: @"searchResults" onBehalfOf_: _cmd ];
    }

// Channels

- ( void ) testTDS_channels_operationsCombination_pos0
    {
    [ self loop_: @"channels" onBehalfOf_: _cmd ];
    }

// Playlists

- ( void ) testTDS_playlists_operationsCombination_pos0
    {
    [ self loop_: @"playlists" onBehalfOf_: _cmd ];
    }

// Playlist Items

- ( void ) testTDS_playlistItems_operationsCombination_pos0
    {
    [ self loop_: @"playlistItems" onBehalfOf_: _cmd ];
    }

#pragma mark - Negative Test

// Search Results

- ( void ) testTDS_searchResults_operationsCombination_neg0
    {
    [ self loop_: @"playlistItems" onBehalfOf_: _cmd ];
    }

// Channels

- ( void ) testTDS_channels_operationsCombination_neg0
    {
    [ self loop_: @"channels" onBehalfOf_: _cmd ];
    }

// Playlists

- ( void ) testTDS_playlists_operationsCombination_neg0
    {
    [ self loop_: @"playlists" onBehalfOf_: _cmd ];    }

// Playlists

- ( void ) testTDS_playlistItems_operationsCombination_neg0
    {
    [ self loop_: @"playlistItems" onBehalfOf_: _cmd ];
    }

// Consumer Registration

- ( void ) testTDSConsumerRegistration_neg0
    {
    NSString* credentialKey = [ self credentialKeyWithModelKey_: TauKVOStrictKey( searchResults ) ];

    [ [ TauAPIService sharedService ] unregisterConsumer: self withCredential: [ self valueForKey: credentialKey ] ];
    [ self loop_: TauKVOStrictKey( searchResults ) onBehalfOf_: _cmd ];

    [ self setValue: [ [ TauAPIService sharedService ] registerConsumer: self withMethodSignature: [ self methodSignatureForSelector: _cmd ] consumptionType: TauAPIServiceConsumptionSearchResultsType ]
             forKey: credentialKey ];
    }

#pragma mark - Private

#define PAGE_LOOP 8 * 2

- ( void ) loop_: ( NSString* )_ModelKey onBehalfOf_: ( SEL )_Sel
    {
    BOOL isNeg = [ [ self class ] isTestMethodNegative: _Sel ];
    NSArray* initialOperationsCombinations = [ self valueForKey: [ self initialOperationsKeyWithModelKey_: _ModelKey isNeg_: isNeg ] ];

    for ( NSDictionary* _OperationsCombination in initialOperationsCombinations )
        {
        XCTestExpectation* expec = [ self expectationWithDescription: NSStringFromSelector( _cmd ) ];
        [ self executeTDSOperations_: _OperationsCombination credential_: [ self valueForKey: [ self credentialKeyWithModelKey_: _ModelKey ] ] expec_: expec onBehalfOf_: _Sel ];

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

- ( NSString* ) credentialKeyWithModelKey_: ( NSString* )_ModelKey
    {
    return [ _ModelKey stringByAppendingString: @"ConsCredential_" ];
    }

- ( NSString* ) initialOperationsKeyWithModelKey_: ( NSString* )_ModelKey isNeg_: ( BOOL )_IsNeg
    {
    NSMutableString* key = [ NSMutableString stringWithString: _ModelKey ];
    NSString* firstChar = [ key substringWithRange: NSMakeRange( 0, 1 ) ];
    [ key replaceCharactersInRange: NSMakeRange( 0, 1 ) withString: firstChar.uppercaseString ];

    [ key insertString: _IsNeg ? @"neg" : @"pos" atIndex: 0 ];
    [ key appendString: @"InitialOperations_" ];

    return [ key copy ];
    }

- ( void ) executeTDSOperations_: ( NSDictionary* )_OperationsDict
                     credential_: ( TauAPIServiceCredential* )_Credential
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
            newOperationsDict[ TauTDSOperationPageToken ] = _NextPageToken;

            [ self executeTDSOperations_: newOperationsDict credential_: _Credential expec_: _Expec onBehalfOf_: _Sel ];
            }
        // Paging Up
        else if ( _PrevPageToken && ( recursionCount >= ( PAGE_LOOP / 2 ) ) && ( recursionCount < PAGE_LOOP ) )
            {
            NSMutableDictionary* newOperationsDict = [ _OperationsDict mutableCopy ];
            newOperationsDict[ TauTDSOperationPageToken ] = _PrevPageToken;

            [ self executeTDSOperations_: newOperationsDict credential_: _Credential expec_: _Expec onBehalfOf_: _Sel ];
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

@end // TestsTauDataServiceMachanism class