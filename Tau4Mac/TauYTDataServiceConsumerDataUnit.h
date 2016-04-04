//
//  TauYTDataServiceConsumerDataUnit.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@protocol TauYTDataServiceConsumer;
@class TauYTDataServiceCredential;

// TauYTDataServiceConsumerDataUnit class
@interface TauYTDataServiceConsumerDataUnit : NSObject

@property ( strong, readonly ) id <TauYTDataServiceConsumer> consumer;
@property ( strong, readonly ) TauYTDataServiceCredential* credential;

#pragma mark - Initializations

- ( instancetype ) initWithConsumer: ( id <TauYTDataServiceConsumer> )_Consumer credential: ( TauYTDataServiceCredential* )_Credential;

- ( void ) executeConsumerOperations: ( id )_OperationsDictOrGTLQuery
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler;

@end // TauYTDataServiceConsumerDataUnit class