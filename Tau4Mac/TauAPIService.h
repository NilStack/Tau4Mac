//
//  TauAPIService.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauAPIServiceCredential;

@protocol TauAPIServiceConsumer;

NSString extern* const TauTDSOperationPartFilter;
NSString extern* const TauTDSOperationFieldsFilter;
NSString extern* const TauTDSOperationMaxResultsPerPage;
NSString extern* const TauTDSOperationPageToken;

NSString extern* const TauTDSOperationRequirements;
    NSString extern* const TauTDSOperationRequirementQ;
    NSString extern* const TauTDSOperationRequirementID;
    NSString extern* const TauTDSOperationRequirementChannelID;
    NSString extern* const TauTDSOperationRequirementPlaylistID;
    NSString extern* const TauTDSOperationRequirementMine;
    NSString extern* const TauTDSOperationRequirementType;

// TauAPIService class
@interface TauAPIService : NSObject

#pragma mark - Core

@property ( strong, readonly ) GTLServiceYouTube* ytService;

@property ( strong, readonly ) NSString* signedInUsername;
@property ( assign, readonly ) BOOL isSignedIn;

+ ( void ) signOut;

#pragma mark - Consumers

- ( TauAPIServiceCredential* ) registerConsumer: ( id <TauAPIServiceConsumer> )_Consumer withMethodSignature: ( NSMethodSignature* )_Sig consumptionType: ( TauAPIServiceConsumptionType )_ConsumptionType;
- ( void ) unregisterConsumer: ( id <TauAPIServiceConsumer> )_Consumer withCredential: ( TauAPIServiceCredential* )_Credential;

- ( void ) executeConsumerOperations: ( id )_OperationsDictOrGTLQuery
                      withCredential: ( TauAPIServiceCredential* )_Credential
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler;

#pragma mark - Singleton Instance

+ ( instancetype ) sharedService;

@end // TauAPIService class

// TauAPIServiceConsumer protocol
@protocol TauAPIServiceConsumer <NSObject>
@required
@optional
@end // TauAPIServiceConsumer protocol

#import "TauYouTubeSearchResultsCollection.h"
#import "TauYouTubeChannelsCollection.h"
#import "TauYouTubePlaylistsCollection.h"
#import "TauYouTubePlaylistItemsCollection.h"
#import "TauYouTubeSubscriptionsCollection.h"