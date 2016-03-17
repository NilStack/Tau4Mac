//
//  TauYTDataService.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataService.h"
#import "TauCollectionObject.h"
#import "TauYTDataServiceConsumerDataUnit.h"

#import "GTL/GTLUtilities.h"
#import "GTL/GTMSessionFetcher.h"
#import "GTL/GTMOAuth2Authentication.h"
#import "GTL/GTMOAuth2WindowController.h"
#import "GTL/GTMSessionFetcher.h"

#import "PriTauYTDataServiceCredential_.h"

#import "TauTTYLogFormatter.h"
#import "NSColor+TauDrawing.h"

__attribute__( ( constructor ) )
static void sConfigureLogging()
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken,
    ( dispatch_block_t )^( void )
        {
        DDTTYLogger* sharedTTYLogger = [ DDTTYLogger sharedInstance ];

        NSColor* fatalColor = [ NSColor colorWithHTMLColor: @"CC0066" ];
        NSColor* recoverableErrColor = [ NSColor colorWithHTMLColor: @"FE6262" ];
        NSColor* warningColor = [ NSColor colorWithHTMLColor: @"FEFEA4" ];
        NSColor* infoColor = [ NSColor colorWithHTMLColor: @"D5FBFF" ];
        NSColor* verboseColor = [ NSColor colorWithHTMLColor: @"CACBCE" ];

        [ sharedTTYLogger setColorsEnabled: YES ];
        [ sharedTTYLogger setForegroundColor: fatalColor backgroundColor: [ NSColor whiteColor ] forFlag: DDLogFlagFatal ];
        [ sharedTTYLogger setForegroundColor: recoverableErrColor backgroundColor: nil forFlag: DDLogFlagRecoverable ];

        [ sharedTTYLogger setForegroundColor: warningColor backgroundColor: nil forFlag: DDLogFlagWarning ];
        [ sharedTTYLogger setForegroundColor: warningColor backgroundColor: nil forFlag: DDLogFlagNotice ];
        [ sharedTTYLogger setForegroundColor: warningColor backgroundColor: nil forFlag: DDLogFlagUnexpected ];

        [ sharedTTYLogger setForegroundColor: infoColor backgroundColor: nil forFlag: DDLogFlagInfo ];
        [ sharedTTYLogger setForegroundColor: infoColor backgroundColor: nil forFlag: DDLogFlagDebug ];

        [ sharedTTYLogger setForegroundColor: verboseColor backgroundColor: nil forFlag: DDLogFlagVerbose ];

        [ sharedTTYLogger setLogFormatter: [ [ TauTTYLogFormatter alloc ] init ] ];
        [ DDLog addLogger: sharedTTYLogger ];
        } );
    }

// Privvate Interfaces
@interface TauYTDataService ()

- ( TauYTDataServiceCredential* ) registerConsumer: ( id <TauYTDataServiceConsumer> )_Consumer
                               withMethodSignature: ( NSMethodSignature* )_Sig
                                   consumptionType: ( TauYTDataServiceConsumptionType )_ConsumptionType;
@end // Privvate Interfaces

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

NSString* const TauYTDataServiceDataActionPartFilter = @"part";
NSString* const TauYTDataServiceDataActionFieldsFilter = @"fields";
NSString* const TauYTDataServiceDataActionMaxResultsPerPage = @"maxResults";
NSString* const TauYTDataServiceDataActionPageToken = @"pageToken";

NSString* const TauYTDataServiceDataActionRequirements = @"TauYTDataServiceDataActionRequirements";
    NSString* const TauYTDataServiceDataActionRequirementQ          = @"q";
    NSString* const TauYTDataServiceDataActionRequirementID         = @"id";
    NSString* const TauYTDataServiceDataActionRequirementChannelID  = @"channelId";
    NSString* const TauYTDataServiceDataActionRequirementPlaylistID = @"playlistId";
    NSString* const TauYTDataServiceDataActionRequirementMine       = @"mine";
    NSString* const TauYTDataServiceDataActionRequirementType       = @"type";

NSString* const TauGeneralErrorDomain = @"home.bedroom.TongKuo.Tau4Mac.GeneralErrorDomain";
NSString* const TauCentralDataServiceErrorDomain = @"home.bedroom.TongKuo.Tau4Mac.CentralDataServiceErrorDomain";
NSString* const TauUnderlyingErrorDomain = @"home.bedroom.TongKuo.Tau4Mac.UnderlyingErrorDomain";

// TauYTDataService class
@implementation TauYTDataService
    {
    NSMapTable __strong* mapTable_;
    }

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

#pragma mark - Singleton Instance

TauYTDataService static* sYTDataService_;
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

- ( GTLServiceYouTube* ) ytService
    {
    GTLServiceYouTube static* service;

    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
        , ^( void )
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

#pragma mark - Consumers

- ( TauYTDataServiceCredential* ) registerConsumer: ( id <TauYTDataServiceConsumer> )_Consumer
                               withMethodSignature: ( NSMethodSignature* )_Sig
                                   consumptionType: ( TauYTDataServiceConsumptionType )_ConsumptionType
    {
    Protocol* protocol = @protocol( TauYTDataServiceConsumer );
    if ( ![ _Consumer conformsToProtocol: protocol ] )
        DDLogUnexpected( @"Consumer registering should conform to <%@> protocol", NSStringFromProtocol( protocol ) );

    TauYTDataServiceCredential* credential =
        [ [ TauYTDataServiceCredential alloc ] initWithConsumer: _Consumer applyingMethodSignature: _Sig consumptionType: _ConsumptionType ];

    TauYTDataServiceConsumerDataUnit* dataUnit =
        [ [ TauYTDataServiceConsumerDataUnit alloc ] initWithConsumer: _Consumer credential: credential ];

    [ mapTable_ setObject: dataUnit forKey: credential ];

    return credential;
    }

- ( void ) unregisterConsumer: ( id <TauYTDataServiceConsumer> )_UnregisteringConsumer withCredential: ( TauYTDataServiceCredential* )_Credential
    {
    if ( !_UnregisteringConsumer )
        {
        DDLogNotice( @"Do nothing. Unregistering consumer must not be nil" );
        return;
        }

    if ( _Credential )
        [ mapTable_ removeObjectForKey: _Credential ];
    else
        {
        NSMutableArray* unregisteringCredentials = [ @[] mutableCopy ];
        for ( TauYTDataServiceCredential* _Credential in mapTable_ )
            {
            TauYTDataServiceConsumerDataUnit* dataUnit = [ mapTable_ objectForKey: _Credential ];
            if ( dataUnit.consumer == _UnregisteringConsumer )
                [ unregisteringCredentials addObject: _Credential ];
            }

        for ( TauYTDataServiceCredential* _Credential in unregisteringCredentials )
            [ mapTable_ removeObjectForKey: _Credential ];
        }
    }

- ( void ) executeConsumerOperations: ( NSDictionary* )_OperationsDict
                      withCredential: ( TauYTDataServiceCredential* )_Credential
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    NSError* error = nil;
    if ( [ self validateOperationsCombination_: _OperationsDict hostSel_: _cmd error_: &error ] )
        {
        if ( _Credential )
            {
            TauYTDataServiceConsumerDataUnit* dataUnit = [ mapTable_ objectForKey: _Credential ];

            if ( dataUnit )
                [ dataUnit executeConsumerOperations: _OperationsDict success: _CompletionHandler failure: _FailureHandler ];
            else
                error = [ NSError errorWithDomain: TauCentralDataServiceErrorDomain
                                             code: TauCentralDataServiceInvalidCredentialError
                                         userInfo: @{ NSLocalizedDescriptionKey : [ NSString stringWithFormat: @"Credential {%@} is invalid. It may be already revoked.", _Credential ]
                                                    , NSLocalizedRecoverySuggestionErrorKey : @"You can re-register a consumer to fetch a new valid credential from Tau Data Service."
                                                    } ];
            }
        }

    if ( error )
        {
        if ( _FailureHandler )
            _FailureHandler( error );
        else
            DDLogUnexpected( @"Failed to execute consumer operations due to: {%@}", error );
        }
    }

#pragma mark - Private Interfaces

- ( BOOL ) validateOperationsCombination_: ( NSDictionary* )_OperationsDict
                                 hostSel_: ( SEL )_HostSEL
                                   error_: ( NSError** )_Error
    {
    NSError* error = nil;
    NSString* errorDomain = nil;
    NSInteger errorCode = 0;
    NSDictionary* userInfo = nil;

    if ( _OperationsDict )
        {
        id requirementsField = _OperationsDict[ TauYTDataServiceDataActionRequirements ];
        if ( !requirementsField )
            {
            errorDomain = TauCentralDataServiceErrorDomain;
            errorCode = TauCentralDataServiceInvalidOrConflictingOperationsCombination;

            userInfo = @{ NSLocalizedDescriptionKey :
                            [ NSString stringWithFormat: @"Data service operations combination must contain TauYTDataServiceDataActionRequirements{%@} field.", TauYTDataServiceDataActionRequirements ] };
            }
        else if ( requirementsField && ![ requirementsField isKindOfClass: [ NSDictionary class ]] )
            {
            errorDomain = TauCentralDataServiceErrorDomain;
            errorCode = TauCentralDataServiceInvalidOrConflictingOperationsCombination;

            userInfo = @{ NSLocalizedDescriptionKey :
                            [ NSString stringWithFormat: @"Value of TauYTDataServiceDataActionRequirements{%@} must be a dictionary", TauYTDataServiceDataActionRequirements ] };
            }
        else if ( [ _OperationsDict[ TauYTDataServiceDataActionRequirements ] count ] == 0 )
            {
            errorDomain = TauCentralDataServiceErrorDomain;
            userInfo = @{ NSLocalizedDescriptionKey :
                            [ NSString stringWithFormat: @"TauYTDataServiceDataActionRequirements{%@} in operations combination must contain least one valid field."
                                                       , TauYTDataServiceDataActionRequirements ] };
            errorCode = TauCentralDataServiceInvalidOrConflictingOperationsCombination;
            }

        if ( !( _OperationsDict[ TauYTDataServiceDataActionPartFilter ] ) )
            DDLogNotice( @"Tau Data Service noticed that there is no TauYTDataServiceDataActionPartFilter{%@} field found within operations combination. "
                         @"Tau Data Service will select the default {part} filter that may cause the absense of your expecting data fregments."
                       , TauYTDataServiceDataActionPartFilter
                       );

        if ( !( _OperationsDict[ TauYTDataServiceDataActionMaxResultsPerPage ] ) )
            DDLogNotice( @"Tau Data Service noticed that there is no TauYTDataServiceDataActionMaxResultsPerPage{%@} field found within operations combination. "
                          "Tau Data Service will select the default value that is subject to the change made by Google and this behavior may be not your expectation."
                       , TauYTDataServiceDataActionMaxResultsPerPage
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

@end // TauYTDataService class