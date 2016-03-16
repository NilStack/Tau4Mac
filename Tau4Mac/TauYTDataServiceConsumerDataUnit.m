//
//  TauYTDataServiceConsumerDataUnit.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataServiceConsumerDataUnit.h"
#import "TauDataService.h"
#import "TauYTDataServiceCredential.h"

#import "TauYouTubeSearchResultsCollection.h"
#import "TauYouTubeChannelsCollection.h"
#import "TauYouTubePlaylistsCollection.h"
#import "TauYouTubePlaylistItemsCollection.h"

// TauYTDataServiceConsumerDataUnit class
@implementation TauYTDataServiceConsumerDataUnit
    {
    id <TauYTDataServiceConsumer> __strong consumer_;
    TauYTDataServiceCredential __strong* credential_;

    GTLServiceTicket __strong* ytTicket;
    TauAbstractResultCollection __strong* resultCollection_;
    }

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

@dynamic consumer;
@dynamic credential;

- ( id <TauYTDataServiceConsumer> ) consumer
    {
    return consumer_;
    }

- ( TauYTDataServiceCredential* ) credential
    {
    return credential_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithConsumer: ( id <TauYTDataServiceConsumer> )_Consumer credential: ( TauYTDataServiceCredential* )_Credential
    {
    if ( !_Consumer || !_Credential )
        {
        DDLogUnexpected( @"Failed to initialize: both consumer and credential parameters must not be nil" );
        return nil;
        }

    if ( self = [ super init ] )
        {
        consumer_ = _Consumer;
        credential_ = [ _Credential copy ];
        }

    return self;
    }

- ( void ) dealloc
    {
    
    }

@end // TauYTDataServiceConsumerDataUnit class