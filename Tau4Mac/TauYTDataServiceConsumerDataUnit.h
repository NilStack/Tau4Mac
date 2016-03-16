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

#pragma mark - Initializations

- ( instancetype ) initWithConsumer: ( id <TauYTDataServiceConsumer> )_Consumer credential: ( TauYTDataServiceCredential* )_Credential;

@end // TauYTDataServiceConsumerDataUnit class