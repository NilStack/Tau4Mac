//
//  TauYTDataServiceConsumerDataUnit.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataServiceConsumerDataUnit.h"
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

    GTLServiceTicket __strong* ytTicket_;
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
    if ( ytTicket_ )
        [ ytTicket_ cancelTicket ];

    NSString* bindKeyPath = [ self bindKeyPathForConsumptionType_: credential_.consumptionType ];
    [ ( NSObject* )consumer_ unbind: bindKeyPath ];
    }

- ( void ) executeConsumerOperations: ( NSDictionary* )_OperationsDict
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    if ( ytTicket_ )
        [ ytTicket_ cancelTicket ];

    GTLQueryYouTube* ytQuery = [ self queryForConsumptionType_: credential_.consumptionType operationsDict_: _OperationsDict ];
    ytTicket_ = [ [ TauYTDataService sharedService ].ytService executeQuery: ytQuery
                                                          completionHandler:
    ^( GTLServiceTicket* _Ticket, GTLCollectionObject* _Resp, NSError* _Error )
        {
        if ( _Resp && !_Error )
            {
            if ( !resultCollection_ )
                {
                Class modelClass = [ self modelClassForConsumptionType_: credential_.consumptionType ];
                resultCollection_ = [ [ modelClass alloc ] initWithGTLCollectionObject: _Resp ];

                NSString* bindKeyPath = [ self bindKeyPathForConsumptionType_: credential_.consumptionType ];
                [ ( NSObject* )consumer_ bind: bindKeyPath toObject: resultCollection_ withKeyPath: bindKeyPath options: nil ];
                }
            else
                // An object observing the searchResults / channels / playlists / playlistItems properties must be notified
                // when super's ytCollectionObject properties change,
                // as it affects the value of the property
                [ resultCollection_ setYtCollectionObject: _Resp ];

            if ( _CompletionHandler )
                _CompletionHandler( [ resultCollection_ valueForKey: @"prevPageToken" ]
                                  , [ resultCollection_ valueForKey: @"nextPageToken" ]);
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

- ( NSString* ) bindKeyPathForConsumptionType_: ( TauYTDataServiceConsumptionType )_ConsumptionType
    {
    NSString* key = nil;

    switch ( _ConsumptionType )
        {
        case TauYTDataServiceConsumptionSearchResultsType: key = @"searchResults"; break;
        case TauYTDataServiceConsumptionChannelsType:      key = @"channels";      break;
        case TauYTDataServiceConsumptionPlaylistsType:     key = @"playlists";     break;
        case TauYTDataServiceConsumptionPlaylistItemsType: key = @"playlistItems"; break;
        }

    return key;
    }

- ( Class ) modelClassForConsumptionType_: ( TauYTDataServiceConsumptionType )_ConsumptionType
    {
    Class modelClass = nil;

    switch ( _ConsumptionType )
        {
        case TauYTDataServiceConsumptionSearchResultsType: modelClass = [ TauYouTubeSearchResultsCollection class ]; break;
        case TauYTDataServiceConsumptionChannelsType:      modelClass = [ TauYouTubeChannelsCollection class ];      break;
        case TauYTDataServiceConsumptionPlaylistsType:     modelClass = [ TauYouTubePlaylistsCollection class ];     break;
        case TauYTDataServiceConsumptionPlaylistItemsType: modelClass = [ TauYouTubePlaylistItemsCollection class ]; break;
        }

    return modelClass;
    }

- ( GTLQueryYouTube* ) queryForConsumptionType_: ( TauYTDataServiceConsumptionType )_ConsumptionType operationsDict_: ( NSDictionary* )_Dict
    {
    GTLQueryYouTube* ytQuery = nil;

    NSString* partFilter = _Dict[ TauTDSOperationPartFilter ];
    switch ( _ConsumptionType )
        {
        case TauYTDataServiceConsumptionSearchResultsType:
            {
            ytQuery = [ GTLQueryYouTube queryForSearchListWithPart: partFilter ?: @"snippet" ];
            ytQuery.q = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementQ ];
            } break;

        case TauYTDataServiceConsumptionChannelsType:
            {
            ytQuery = [ GTLQueryYouTube queryForChannelsListWithPart: partFilter ?:  @"snippet,contentDetails" ];
            ytQuery.identifier = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementID ];
            } break;

        case TauYTDataServiceConsumptionPlaylistsType:
            {
            ytQuery = [ GTLQueryYouTube queryForPlaylistsListWithPart: partFilter ?: @"snippet,contentDetails" ];
            ytQuery.channelId = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementChannelID ];
            } break;

        case TauYTDataServiceConsumptionPlaylistItemsType:
            {
            ytQuery = [ GTLQueryYouTube queryForPlaylistItemsListWithPart: partFilter ?: @"contentDetails,id,snippet,status" ];
            ytQuery.playlistId = _Dict[ TauTDSOperationRequirements ][ TauTDSOperationRequirementPlaylistID ];
            } break;
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

@end // TauYTDataServiceConsumerDataUnit class
