//
//  TauAPIServiceConsumerDataUnit.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@protocol TauAPIServiceConsumer;
@class TauAPIServiceCredential;

// TauAPIServiceConsumerDataUnit class
@interface TauAPIServiceConsumerDataUnit : NSObject

@property ( strong, readonly ) id <TauAPIServiceConsumer> consumer;
@property ( strong, readonly ) TauAPIServiceCredential* credential;

#pragma mark - Initializations

- ( instancetype ) initWithConsumer: ( id <TauAPIServiceConsumer> )_Consumer credential: ( TauAPIServiceCredential* )_Credential;

- ( void ) executeConsumerOperations: ( id )_OperationsDictOrGTLQuery
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler;

@end // TauAPIServiceConsumerDataUnit class