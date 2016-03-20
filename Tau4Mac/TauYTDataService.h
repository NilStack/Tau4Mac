//
//  TauYTDataService.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauYTDataServiceCredential;

@protocol TauYTDataServiceConsumer;

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

// TauYTDataService class
@interface TauYTDataService : NSObject

#pragma mark - Core

@property ( strong, readonly ) GTLServiceYouTube* ytService;

@property ( strong, readonly ) NSString* signedInUsername;
@property ( assign, readonly ) BOOL isSignedIn;

#pragma mark - Consumers

- ( TauYTDataServiceCredential* ) registerConsumer: ( id <TauYTDataServiceConsumer> )_Consumer withMethodSignature: ( NSMethodSignature* )_Sig consumptionType: ( TauYTDataServiceConsumptionType )_ConsumptionType;
- ( void ) unregisterConsumer: ( id <TauYTDataServiceConsumer> )_Consumer withCredential: ( TauYTDataServiceCredential* )_Credential;

- ( void ) executeConsumerOperations: ( NSDictionary* )_OperationsDict
                      withCredential: ( TauYTDataServiceCredential* )_Credential
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler;

#pragma mark - Remote Image & Video Fetching

- ( void ) fetchPreferredThumbnailFrom: ( GTLYouTubeThumbnailDetails* )_Thumbnails success: ( void (^)( NSImage* _Image ) )_CompletionHandler failure: ( void (^)( NSError* _Error ) )_FailureHandler;

#pragma mark - Singleton Instance

+ ( instancetype ) sharedService;

@end // TauYTDataService class

// TauYTDataServiceConsumer protocol
@protocol TauYTDataServiceConsumer <NSObject>
@required
@optional
@end // TauYTDataServiceConsumer protocol