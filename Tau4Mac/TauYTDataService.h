//
//  TauYTDataService.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauYTDataServiceCredential;

@protocol TauYTDataServiceConsumer;

// TauYTDataService class
@interface TauYTDataService : NSObject

#pragma mark - Core

@property ( strong, readonly ) NSString* signedInUsername;
@property ( assign, readonly ) BOOL isSignedIn;

#pragma mark - Consumers

- ( TauYTDataServiceCredential* ) registerConsumer: ( id <TauYTDataServiceConsumer> )_Consumer withMethodSignature: ( NSMethodSignature* )_Sig consumptionType: ( TauYTDataServiceConsumptionType )_ConsumptionType;
- ( void ) unregisterConsumer: ( id <TauYTDataServiceConsumer> )_Consumer withCredential: ( TauYTDataServiceCredential* )_Credential;

#pragma mark - Singleton Instance

+ ( instancetype ) sharedService;

@end // TauYTDataService class

@protocol TauYTDataServiceConsumer <NSObject>
@end