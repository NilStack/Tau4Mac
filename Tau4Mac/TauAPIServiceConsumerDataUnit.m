//
//  TauAPIServiceConsumerDataUnit.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAPIServiceConsumerDataUnit.h"
#import "TauAPIServiceCredential.h"

// Private
@interface TauAPIServiceConsumerDataUnit ()

@property ( strong, readwrite ) TauAbstractResultCollection* resultCollection_;

@end // Private

// TauAPIServiceConsumerDataUnit class
@implementation TauAPIServiceConsumerDataUnit
    {
    // We'll establish the binding between consumer_ and self,
    // therefore there is no need to strong referense consumer_
    id <TauAPIServiceConsumer> __weak consumer_;

    TauAPIServiceCredential __strong* credential_;

    GTLServiceTicket __strong* ytTicket_;
    }

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

@synthesize resultCollection_ = resultCollection_;

@dynamic consumer;
@dynamic credential;

- ( id <TauAPIServiceConsumer> ) consumer
    {
    return consumer_;
    }

- ( TauAPIServiceCredential* ) credential
    {
    return credential_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithConsumer: ( id <TauAPIServiceConsumer> )_Consumer credential: ( TauAPIServiceCredential* )_Credential
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

        NSString* bindKeyPath = [ self bindKeyPathForConsumptionType_: credential_.consumptionType ];
        [ ( NSObject* )consumer_ bind: bindKeyPath toObject: self withKeyPath: TauKVOStrictClassKeyPath( TauAPIServiceConsumerDataUnit, resultCollection_ ) options: nil ];
        }

    return self;
    }

TauDeallocBegin
if ( ytTicket_ )
    [ ytTicket_ cancelTicket ];

NSString* bindKeyPath = [ self bindKeyPathForConsumptionType_: credential_.consumptionType ];
[ ( NSObject* )consumer_ unbind: bindKeyPath ];
TauDeallocEnd

- ( void ) executeConsumerOperations: ( id )_OperationsDictOrGTLQuery
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    if ( ytTicket_ )
        [ ytTicket_ cancelTicket ];

    GTLQueryYouTube* ytQuery = nil;

    if ( [ _OperationsDictOrGTLQuery isKindOfClass: [ NSDictionary class ] ] )
        ytQuery = [ self queryForConsumptionType_: credential_.consumptionType operationsDict_: _OperationsDictOrGTLQuery ];
    else if ( [ _OperationsDictOrGTLQuery isKindOfClass: [ GTLQueryYouTube class ] ] )
        ytQuery = _OperationsDictOrGTLQuery;

    ytTicket_ = [ [ TauAPIService sharedService ].ytService executeQuery: ytQuery
                                                          completionHandler:
    ^( GTLServiceTicket* _Ticket, GTLCollectionObject* _Resp, NSError* _Error )
        {
        if ( _Resp && !_Error )
            {
            Class modelClass = [ self modelClassForConsumptionType_: credential_.consumptionType ];

            // An object observing the searchResults / channels / playlists / playlistItems properties must be notified
            // when resultCollection_ property of data unit class changes,
            // as it affects the value of the property
            self.resultCollection_ = [ [ modelClass alloc ] initWithGTLCollectionObject: _Resp ];

            if ( _CompletionHandler )
                _CompletionHandler( [ resultCollection_ valueForKey: TauKVOStrictKey( prevPageToken ) ]
                                  , [ resultCollection_ valueForKey: TauKVOStrictKey( nextPageToken ) ]);
            }
        else
            {
            NSError* error = _Error;

            if ( [ _Error.domain isEqualToString: kGTLServiceErrorDomain ]
                    || [ _Error.domain isEqualToString: kGTLJSONRPCErrorDomain ] )
                error = [ NSError
                    errorWithDomain: TauUnderlyingErrorDomain code: TauUnderlyingGTLError userInfo:
                        @{ NSUnderlyingErrorKey : _Error
                         , NSLocalizedDescriptionKey
                            : [ NSString stringWithFormat: @"Error thrown by underlying frameworks or librarys, for details, check the {%@} field within UserDict out."
                                                         , NSUnderlyingErrorKey ]
                         } ];

            if ( _FailureHandler )
                _FailureHandler( error );
            }
        } ];
    }

- ( NSString* ) bindKeyPathForConsumptionType_: ( TauAPIServiceConsumptionType )_ConsumptionType
    {
    NSString* key = nil;

    switch ( _ConsumptionType )
        {
        case TauAPIServiceConsumptionSearchResultsType: key = @"searchResults"; break;
        case TauAPIServiceConsumptionChannelsType:      key = @"channels";      break;
        case TauAPIServiceConsumptionPlaylistsType:     key = @"playlists";     break;
        case TauAPIServiceConsumptionPlaylistItemsType: key = @"playlistItems"; break;
        case TauAPIServiceConsumptionSubscriptionsType: key = @"subscriptions"; break;
        case TauAPIServiceConsumptionUnknownType:;break;
        }

    return key;
    }

- ( Class ) modelClassForConsumptionType_: ( TauAPIServiceConsumptionType )_ConsumptionType
    {
    Class modelClass = nil;

    switch ( _ConsumptionType )
        {
        case TauAPIServiceConsumptionSearchResultsType: modelClass = [ TauYouTubeSearchResultsCollection class ]; break;
        case TauAPIServiceConsumptionChannelsType:      modelClass = [ TauYouTubeChannelsCollection class ];      break;
        case TauAPIServiceConsumptionPlaylistsType:     modelClass = [ TauYouTubePlaylistsCollection class ];     break;
        case TauAPIServiceConsumptionPlaylistItemsType: modelClass = [ TauYouTubePlaylistItemsCollection class ]; break;
        case TauAPIServiceConsumptionSubscriptionsType: modelClass = [ TauYouTubeSubscriptionsCollection class ]; break;
        case TauAPIServiceConsumptionUnknownType:;break;
        }

    return modelClass;
    }

- ( GTLQueryYouTube* ) queryForConsumptionType_: ( TauAPIServiceConsumptionType )_ConsumptionType operationsDict_: ( NSDictionary* )_Dict
    {
    GTLQueryYouTube* ytQuery = nil;

    NSString* partFilter = _Dict[ TauTDSOperationPartFilter ];
    switch ( _ConsumptionType )
        {
        case TauAPIServiceConsumptionSearchResultsType:
            {
            ytQuery = [ GTLQueryYouTube queryForSearchListWithPart: partFilter ?: @"snippet" ];
            ytQuery.q = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementQ ];
            } break;

        case TauAPIServiceConsumptionChannelsType:
            {
            ytQuery = [ GTLQueryYouTube queryForChannelsListWithPart: partFilter ?:  @"snippet,contentDetails" ];
            ytQuery.identifier = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementChannelID ];
            } break;

        case TauAPIServiceConsumptionPlaylistsType:
            {
            ytQuery = [ GTLQueryYouTube queryForPlaylistsListWithPart: partFilter ?: @"snippet,contentDetails" ];
            ytQuery.channelId = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementChannelID ];
            } break;

        case TauAPIServiceConsumptionPlaylistItemsType:
            {
            ytQuery = [ GTLQueryYouTube queryForPlaylistItemsListWithPart: partFilter ?: @"contentDetails,id,snippet,status" ];
            ytQuery.playlistId = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementPlaylistID ];
            } break;

        case TauAPIServiceConsumptionSubscriptionsType:
            {
            ytQuery = [ GTLQueryYouTube queryForSubscriptionsListWithPart: partFilter ?: @"snippet,contentDetails" ];
            ytQuery.channelId = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementChannelID ];
            } break;

        case TauAPIServiceConsumptionUnknownType:;break;
        }

    NSNumber* maxResults = _Dict[ TauTDSOperationMaxResultsPerPage ];
    if ( maxResults )
        ytQuery.maxResults = [ maxResults unsignedIntegerValue ];

    NSString* pageToken = _Dict[ TauTDSOperationPageToken ];
    if ( pageToken )
        ytQuery.pageToken = pageToken;

    NSNumber* mine = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementMine ];
    if ( mine )
        ytQuery.mine = [ mine boolValue ];

    NSString* type = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementType ];
    if ( type )
        ytQuery.type = type;

    NSString* fieldsFilter = _Dict[ TauTDSOperationFieldsFilter ];
    if ( fieldsFilter )
        ytQuery.fields = fieldsFilter;

    return ytQuery;
    }

@end // TauAPIServiceConsumerDataUnit class
