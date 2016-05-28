//
//  TauAPIService.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAPIServiceConsumerDataUnit.h"

#import "GTL/GTLUtilities.h"
#import "GTL/GTMSessionFetcher.h"
#import "GTL/GTMOAuth2Authentication.h"
#import "GTL/GTMOAuth2WindowController.h"
#import "GTL/GTMSessionFetcher.h"

#import "PriTauAPIServiceCredential_.h"

// Private
@interface TauAPIService ()

// Operations Combination

- ( BOOL ) validateOperationsCombination_: ( id )_OperationsDictOrGTLQuery hostSel_: ( SEL )_HostSEL error_: ( NSError** )_Error;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



#pragma mark - Keychain Item Name

NSString* const TauKeychainItemName =
#if RELEASE // Production keychain item name
@"home.bedroom.TongKuo.Tau4Mac"
#else
@"home.bedroom.TongKuo.Tau4Mac-dev"
#endif
;

#pragma mark - Client Credentials

NSString* const TauClientID =
#if RELEASE // Production client ID
@"889656423754-okdcqp9ujnlpc4ob5eno7l0658seoqo4.apps.googleusercontent.com"
#else
@"889656423754-5pv89v7i9jqf1is237n36apq2tue8m0k.apps.googleusercontent.com"
#endif
;

NSString* const TauClientSecret =
#if RELEASE // Production client secret
@"C8tMCJMqle9fFtuBnMwODope"
#else
@"jo-g8Pry9aR4jDy-osXLQeqK"
#endif
;

#pragma mark - Auth Scopes

// Auth Scopes
NSString* const TauManageAuthScope =                @"https://www.googleapis.com/auth/youtube.force-ssl";
NSString* const TauReadonlyAuthScope =              @"https://www.googleapis.com/auth/youtube.readonly";
NSString* const TauUploadAuthScope =                @"https://www.googleapis.com/auth/youtube.upload";
NSString* const TauPartnerChannelAuditAuthScope =   @"https://www.googleapis.com/auth/youtubepartner-channel-audit";

NSString* const TauTDSOperationPartFilter = @"part";
NSString* const TauTDSOperationFieldsFilter = @"fields";
NSString* const TauTDSOperationMaxResultsPerPage = @"maxResults";
NSString* const TauTDSOperationPageToken = @"pageToken";

NSString* const TauTDSOperationRequirements = @"TauTDSOperationRequirements";
    NSString* const TauTDSOperationRequirementQ          = @"q";
    NSString* const TauTDSOperationRequirementID         = @"id";
    NSString* const TauTDSOperationRequirementChannelID  = @"channelId";
    NSString* const TauTDSOperationRequirementPlaylistID = @"playlistId";
    NSString* const TauTDSOperationRequirementMine       = @"mine";
    NSString* const TauTDSOperationRequirementType       = @"type";

NSString* const TauGeneralErrorDomain = @"home.bedroom.TongKuo.Tau4Mac.GeneralErrorDomain";
NSString* const TauCentralDataServiceErrorDomain = @"home.bedroom.TongKuo.Tau4Mac.CentralDataServiceErrorDomain";
NSString* const TauUnderlyingErrorDomain = @"home.bedroom.TongKuo.Tau4Mac.UnderlyingErrorDomain";
NSString* const TauSQLiteV3ErrorDomain = @"home.bedroom.TongKuo.Tau4Mac.SQLiteV3ErrorDomain";



// ------------------------------------------------------------------------------------------------------------ //



// TauAPIService class
@implementation TauAPIService
    {
    NSMapTable __strong* mapTable_; // A TauAPIServiceCredential -> TauAPIServiceConsumerDataUnit lookup table
    }

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

#pragma mark - Singleton Instance

TauAPIService static* sYTDataService_;
+ ( instancetype ) sharedService
    {
    return [ [ self alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sYTDataService_ )
        {
        if ( self = [ super init ] )
            {
            mapTable_ = [ [ NSMapTable alloc ] initWithKeyOptions: NSMapTableCopyIn valueOptions: NSMapTableStrongMemory capacity: 0 ];
            sYTDataService_ = self;
            }
        }

    return sYTDataService_;
    }

#pragma mark - Core

@dynamic ytService;
@dynamic signedInUsername;
@dynamic isSignedIn;

GTLServiceYouTube TAU_PRIVATE* service;

- ( GTLServiceYouTube* ) ytService
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken,
    ^( void )
        {
        service = [ [ GTLServiceYouTube alloc ] init ];
        service.retryEnabled = YES;

        BOOL ( ^retryBlock )( GTLServiceTicket*, BOOL, NSError* ) =
            ^( GTLServiceTicket *ticket, BOOL suggestedWillRetry, NSError *error )
            {
            DDLogInfo( @"Will Retry: %d", suggestedWillRetry );
            return YES;
            };

        service.retryBlock = retryBlock;

        GTMOAuth2Authentication* auth =
            [ GTMOAuth2WindowController authForGoogleFromKeychainForName: TauKeychainItemName clientID: TauClientID clientSecret: TauClientSecret ];

        [ service setAuthorizer: auth ];

        NSMutableString* userAgent = [ GTMFetcherApplicationIdentifier( nil ) mutableCopy ];
        [ userAgent appendString: [ NSString stringWithFormat: @" OSX %@", [ NSProcessInfo processInfo ].operatingSystemVersionString ] ];

        NSUInteger majorVer = 0;
        NSUInteger minorVer = 0;
        NSUInteger release = 0;
        GTLFrameworkVersion( &majorVer, &minorVer, &release );

        [ userAgent appendString: [ NSString stringWithFormat: @" GTL/%ld.%ld.%ld", majorVer, minorVer, release ] ];
        service.userAgent = GTMFetcherCleanedUserAgentString( userAgent );

        DDLogVerbose( @"Current user-agent is \"%@\"", service.userAgent );
        } );

    return service;
    }

- ( NSString* ) signedInUsername
    {
    GTMOAuth2Authentication* auth = self.ytService.authorizer;

    NSString* userName = auth.userEmail ?: nil;
    return userName;
    }

- ( BOOL ) isSignedIn
    {
    return [ self signedInUsername ] != nil;
    }

+ ( void ) signOut
    {
    sYTDataService_ = nil;
    }

#pragma mark - Consumers

- ( TauAPIServiceCredential* ) registerConsumer: ( id <TauAPIServiceConsumer> )_Consumer
                            withMethodSignature: ( NSMethodSignature* )_Sig
                                consumptionType: ( TauAPIServiceConsumptionType )_ConsumptionType
    {
    Protocol* protocol = @protocol( TauAPIServiceConsumer );
    if ( ![ _Consumer conformsToProtocol: protocol ] )
        DDLogUnexpected( @"Consumer registering should conform to <%@> protocol", NSStringFromProtocol( protocol ) );

    TauAPIServiceCredential* credential =
        [ [ TauAPIServiceCredential alloc ] initWithConsumer: _Consumer applyingMethodSignature: _Sig consumptionType: _ConsumptionType ];

    TauAPIServiceConsumerDataUnit* dataUnit =
        [ [ TauAPIServiceConsumerDataUnit alloc ] initWithConsumer: _Consumer credential: credential ];

    [ mapTable_ setObject: dataUnit forKey: credential ];

    return credential;
    }

- ( void ) unregisterConsumer: ( id <TauAPIServiceConsumer> )_UnregisteringConsumer withCredential: ( TauAPIServiceCredential* )_Credential
    {
    if ( !_UnregisteringConsumer )
        {
        DDLogNotice( @"Do nothing. Unregistering consumer must not be nil" );
        return;
        }

    if ( _Credential )
        {
        [ mapTable_ removeObjectForKey: _Credential ];
        DDLogDebug( @"Removed consumer with credential {%@}.\nCurrent consumers in TDS: {%@}", _Credential, mapTable_ );
        }
    else
        {
        NSMutableArray* unregisteringCredentials = [ @[] mutableCopy ];
        for ( TauAPIServiceCredential* _Cred in mapTable_ )
            {
            // FIXME: Faield to search for consumer
            TauAPIServiceConsumerDataUnit* dataUnit = [ mapTable_ objectForKey: _Cred ];
            if ( dataUnit.consumer == _UnregisteringConsumer )
                [ unregisteringCredentials addObject: _Cred ];
            }

        for ( TauAPIServiceCredential* _Credential in unregisteringCredentials )
            {
            [ mapTable_ removeObjectForKey: _Credential ];
            DDLogDebug( @"Batch Removing... Removed consumer with credential {%@}.\nCurrent consumers in TDS: {%@}", _Credential, mapTable_ );
            }
        }
    }

- ( void ) executeConsumerOperations: ( id )_OperationsDictOrGTLQuery
                      withCredential: ( TauAPIServiceCredential* )_Credential
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    NSError* error = nil;
    if ( _Credential )
        {
        TauAPIServiceConsumerDataUnit* dataUnit = [ mapTable_ objectForKey: _Credential ];
        if ( dataUnit )
            {
            if ( [ self validateOperationsCombination_: _OperationsDictOrGTLQuery hostSel_: _cmd error_: &error ] )
                [ dataUnit executeConsumerOperations: _OperationsDictOrGTLQuery success: _CompletionHandler failure: _FailureHandler ];
            }
        else
            error = [ NSError errorWithDomain: TauCentralDataServiceErrorDomain
                                         code: TauCentralDataServiceInvalidCredentialError
                                     userInfo: @{ NSLocalizedDescriptionKey : [ NSString stringWithFormat: @"Credential {%@} is invalid. It may be already revoked.", _Credential ]
                                                , NSLocalizedRecoverySuggestionErrorKey : @"You can re-register a consumer to fetch a new valid credential from Tau Data Service."
                                                } ];
        }

    if ( error )
        {
        if ( _FailureHandler )
            TauExecuteCodeFragmentOnMainQueue( _FailureHandler( error ) );
        else
            DDLogUnexpected( @"Failed to execute consumer operations with error: {%@}", error );
        }
    }

- ( void ) executeRestRequest: ( TauRestRequest* )_Request completionHandler: ( void (^)( id _Response, NSError* _Error ) )_Handler
    {
    GTLQueryYouTube* query = [ _Request YouTubeQuery ];

    [ self.ytService executeQuery: query
                completionHandler:
    ^( GTLServiceTicket* _Ticket, id _Object, NSError* _Error )
        {
        if ( _Handler )
            {
            dispatch_async( dispatch_get_main_queue(), ( dispatch_block_t )^( void ) {
                _Handler( _Object, _Error );
                } );
            }
        } ];
    }

// FIXME: Duplicate code
- ( void ) executeGTLQuery: ( GTLQueryYouTube* )_Query
                   success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                   failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {

    }

#pragma mark - Private

// Operations Combination

- ( BOOL ) validateOperationsCombination_: ( id )_OperationsDictOrGTLQuery
                                 hostSel_: ( SEL )_HostSEL
                                   error_: ( NSError** )_Error
    {
    if ( [ _OperationsDictOrGTLQuery isKindOfClass: [ GTLQueryYouTube class ] ] )
        return YES;

    NSError* error = nil;
    NSString* errorDomain = nil;
    NSInteger errorCode = 0;
    NSDictionary* userInfo = nil;

    if ( _OperationsDictOrGTLQuery )
        {
        id requirementsField = _OperationsDictOrGTLQuery[ TauTDSOperationRequirements ];
        if ( !requirementsField )
            {
            errorDomain = TauCentralDataServiceErrorDomain;
            errorCode = TauCentralDataServiceInvalidOrConflictingOperationsCombination;

            userInfo = @{ NSLocalizedDescriptionKey :
                            [ NSString stringWithFormat: @"Data service operations combination must contain TauTDSOperationRequirements{%@} field.", TauTDSOperationRequirements ] };
            }
        else if ( requirementsField && ![ requirementsField isKindOfClass: [ NSDictionary class ]] )
            {
            errorDomain = TauCentralDataServiceErrorDomain;
            errorCode = TauCentralDataServiceInvalidOrConflictingOperationsCombination;

            userInfo = @{ NSLocalizedDescriptionKey :
                            [ NSString stringWithFormat: @"Value of TauTDSOperationRequirements{%@} must be a dictionary", TauTDSOperationRequirements ] };
            }
        else if ( [ _OperationsDictOrGTLQuery[ TauTDSOperationRequirements ] count ] == 0 )
            {
            errorDomain = TauCentralDataServiceErrorDomain;
            userInfo = @{ NSLocalizedDescriptionKey :
                            [ NSString stringWithFormat: @"TauTDSOperationRequirements{%@} in operations combination must contain least one valid field."
                                                       , TauTDSOperationRequirements ] };
            errorCode = TauCentralDataServiceInvalidOrConflictingOperationsCombination;
            }

        if ( !( _OperationsDictOrGTLQuery[ TauTDSOperationPartFilter ] ) )
            DDLogNotice( @"Tau Data Service noticed that there is no TauTDSOperationPartFilter{%@} field found within operations combination. "
                         @"Tau Data Service will select the default {part} filter that may cause the absence of your expecting data fregments."
                       , TauTDSOperationPartFilter
                       );

        if ( !( _OperationsDictOrGTLQuery[ TauTDSOperationMaxResultsPerPage ] ) )
            DDLogNotice( @"Tau Data Service noticed that there is no TauTDSOperationMaxResultsPerPage{%@} field found within operations combination. "
                          "Tau Data Service will select the default value that is subject to the change made by Google and this behavior may be not your expectation."
                       , TauTDSOperationMaxResultsPerPage
                       );
        }
    else
        {
        errorDomain = TauGeneralErrorDomain;
        errorCode = TauGeneralInvalidArgument;
        userInfo = @{ NSLocalizedDescriptionKey : [ NSString stringWithFormat: @"Operation combination parameter of {%@} must not be nil", NSStringFromSelector( _HostSEL ) ] };
        }

    if ( errorDomain )
        error = [ NSError errorWithDomain: errorDomain code: errorCode userInfo: userInfo ];

    if ( error )
        if ( _Error )
            *_Error = error;

    return ( error == nil );
    }

@end // TauAPIService class