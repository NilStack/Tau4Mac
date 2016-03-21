//
//  TauYTDataService.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataServiceConsumerDataUnit.h"

#import "GTL/GTLUtilities.h"
#import "GTL/GTMSessionFetcher.h"
#import "GTL/GTMOAuth2Authentication.h"
#import "GTL/GTMOAuth2WindowController.h"
#import "GTL/GTMSessionFetcher.h"

#import "PriTauYTDataServiceCredential_.h"

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
        {
        [ mapTable_ removeObjectForKey: _Credential ];
        DDLogDebug( @"Removed consumer with credential {%@}.\nCurrent consumers in TDS: {%@}", _Credential, mapTable_ );
        }
    else
        {
        NSMutableArray* unregisteringCredentials = [ @[] mutableCopy ];
        for ( TauYTDataServiceCredential* _Cred in mapTable_ )
            {
            // FIXME: Faield to search for consumer
            TauYTDataServiceConsumerDataUnit* dataUnit = [ mapTable_ objectForKey: _Cred ];
            if ( dataUnit.consumer == _UnregisteringConsumer )
                [ unregisteringCredentials addObject: _Cred ];
            }

        for ( TauYTDataServiceCredential* _Credential in unregisteringCredentials )
            {
            [ mapTable_ removeObjectForKey: _Credential ];
            DDLogDebug( @"Batch Removing... Removed consumer with credential {%@}.\nCurrent consumers in TDS: {%@}", _Credential, mapTable_ );
            }
        }
    }

- ( void ) executeConsumerOperations: ( NSDictionary* )_OperationsDict
                      withCredential: ( TauYTDataServiceCredential* )_Credential
                             success: ( void (^)( NSString* _PrevPageToken, NSString* _NextPageToken ) )_CompletionHandler
                             failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    NSError* error = nil;
    if ( _Credential )
        {
        TauYTDataServiceConsumerDataUnit* dataUnit = [ mapTable_ objectForKey: _Credential ];
        if ( dataUnit )
            {
            if ( [ self validateOperationsCombination_: _OperationsDict hostSel_: _cmd error_: &error ] )
                [ dataUnit executeConsumerOperations: _OperationsDict success: _CompletionHandler failure: _FailureHandler ];
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
            _FailureHandler( error );
        else
            DDLogUnexpected( @"Failed to execute consumer operations due to: {%@}", error );
        }
    }

#pragma mark - Remote Image & Video Fetching

NSString static* const kPreferredThumbKey = @"kPreferredThumbKey";
NSString static* const kBackingThumbKey = @"kBackingThumbKey";

- ( NSURL* ) imageCacheUrl_: ( NSURL* )_ImageUrl
    {
    NSData* cacheNameData = [ [ _ImageUrl.path stringByRemovingPercentEncoding ] dataUsingEncoding: NSUTF8StringEncoding ];
    unsigned char buffer[ CC_SHA1_DIGEST_LENGTH ];
    CC_SHA1( cacheNameData.bytes, ( unsigned int )( cacheNameData.length ), buffer );

    NSData* hashedCacheName = [ NSData dataWithBytes: buffer length: CC_SHA1_DIGEST_LENGTH ];
    NSError* err = nil;
    NSURL* cacheURL = [ [ NSFileManager defaultManager ] URLForDirectory: NSCachesDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &err ];
    cacheURL = [ cacheURL URLByAppendingPathComponent: hashedCacheName.description ];
    if ( !cacheURL )
        DDLogFatal( @"Failed to create the cache dir due to {%@}.", err );

    return cacheURL;
    }

- ( NSImage* ) loadCacheForImageUrl_: ( NSURL* )_ImageUrl
    {
    NSImage* awakenImage = nil;

    NSURL* cacheURL = [ self imageCacheUrl_: _ImageUrl ];
    BOOL isDir = NO;
    if ( [ [ NSFileManager defaultManager ] fileExistsAtPath: cacheURL.path isDirectory: &isDir ] && !isDir )
        awakenImage = [ [ NSImage alloc ] initWithContentsOfURL: cacheURL ];

    return awakenImage;
    }

- ( void ) getThumbUrls_: ( out NSDictionary <NSString*, NSURL*>* __autoreleasing* )_ioUrlsDict fromThumbnails_: ( GTLYouTubeThumbnailDetails* )_ThumbnailDetails
    {
    // Pick up the thumbnail that has the highest definition as far as possible
    GTLYouTubeThumbnail* preferredThumbnail =
            /* 1280x720 px */
        _ThumbnailDetails.maxres
            /* 640x480 px */
            ?: _ThumbnailDetails.standard
            /* 480x360 px */
            ?: _ThumbnailDetails.high
            /* 320x180 px */
            ?: _ThumbnailDetails.medium
            /* 120x90 px */
            ?: _ThumbnailDetails.defaultProperty
             ;

    if ( !preferredThumbnail )
        {
        DDLogUnexpected( @"Coundn't find out the preferred thumbnail from {%@}.", preferredThumbnail );
        return;
        }

    NSMutableDictionary* urlsDictResult = [ NSMutableDictionary dictionary ];

    NSURL* backingUrl = nil;
    NSURL* preferredUrl = nil;

    if ( ( backingUrl = [ NSURL URLWithString: preferredThumbnail.url ] ) )
        [ urlsDictResult addEntriesFromDictionary: @{ kBackingThumbKey : backingUrl } ];

    NSString* maxresName = @"maxresdefault.jpg";
    if ( ![ [ backingUrl.lastPathComponent stringByDeletingPathExtension ] isEqualToString: maxresName ] )
        if ( ( preferredUrl = [ [ backingUrl URLByDeletingLastPathComponent ] URLByAppendingPathComponent: maxresName ] ) )
            [ urlsDictResult addEntriesFromDictionary: @{ kPreferredThumbKey : preferredUrl } ];

    if ( urlsDictResult.count > 0 )
        {
        if ( _ioUrlsDict )
            *_ioUrlsDict = [ urlsDictResult copy ];
        }
    else
        DDLogUnexpected( @"Urls dict I/O argument didn't get polulated from {%@}.", _ThumbnailDetails );
    }

- ( void ) getImageInCache_: ( out NSImage* __autoreleasing* )_Imageptr forUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_UrlDict
    {
    NSURL* url = _UrlDict[ kPreferredThumbKey ] ?: _UrlDict[ kBackingThumbKey ];

    NSImage* image = [ self loadCacheForImageUrl_: url ];
    if ( image )
        {
        if ( _Imageptr )
            *_Imageptr = image;
        }
    else
        {
        if ( ( _UrlDict[ kPreferredThumbKey ] ) && ( _UrlDict[ kBackingThumbKey ] ) )
            [ self getImageInCache_: _Imageptr forUrlsDict_: @{ kBackingThumbKey : _UrlDict[ kBackingThumbKey ] } ];
        }
    }

- ( void ) fetchThumbImagesFromUrlDict_: ( NSDictionary <NSString*, NSURL*>* )_UrlDict
                               success_: ( void (^)( NSImage* _Nullable _Image, BOOL _LoadsFromCache ) )_SuccessHandler
                               failure_: ( void (^)( NSError* _Errpr ) )_FailureHandler
    {
    NSImage* image = nil;
    [ self getImageInCache_: &image forUrlsDict_: _UrlDict ];

    if ( image )
        {
        if ( _SuccessHandler )
            _SuccessHandler ( image, YES );
        return;
        }

    NSURL* url = _UrlDict[ kPreferredThumbKey ] ?: _UrlDict[ kBackingThumbKey ];

    GTMSessionFetcher* fetcher = [ GTMSessionFetcher fetcherWithURL: url ];
    NSString* fetchID = [ NSString stringWithFormat: @"(fetchID=%@)", TKNonce() ];
    [ fetcher setComment: fetchID ];
    [ fetcher setUserData: _UrlDict ];

    [ fetcher beginFetchWithCompletionHandler:
    ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
        {
        if ( _Data && !_Error )
            {
            DDLogDebug( @"Finished fetching thumbnail %@", fetchID );

            NSImage* image = [ [ NSImage alloc ] initWithData: _Data ];
            [ _Data writeToURL: [ self imageCacheUrl_: url ] atomically: YES ];

            if ( _SuccessHandler )
                _SuccessHandler( image, NO );
            }
        else
            {
            if ( [ _Error.domain isEqualToString: kGTMSessionFetcherStatusDomain ] && ( _Error.code == 404 ) )
                {
                DDLogRecoverable( @"404 NOT FOUND. Couldn't fetch the thumb at {%@} error={%@} comment=%@.\n"
                                  "(Attempting to fetch the backing thumbnail...)"
                                 , fetcher.userData[ kPreferredThumbKey ]
                                 , _Error
                                 , fetcher.comment
                                 );

                [ self fetchThumbImagesFromUrlDict_: @{ kBackingThumbKey : _UrlDict[ kBackingThumbKey ] }
                                           success_: _SuccessHandler
                                           failure_: _FailureHandler ];
                }
            else
                if ( _FailureHandler )
                    _FailureHandler( _Error );
            }
        } ];
    }


- ( void ) fetchPreferredThumbnailFrom: ( GTLYouTubeThumbnailDetails* )_ThumbnailDetails
                               success: ( void (^)( NSImage* _Image, BOOL _LoadsFromCache ) )_CompletionHandler
                               failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    NSDictionary <NSString*, NSURL*>* urlsDict = nil;
    [ self getThumbUrls_: &urlsDict fromThumbnails_: _ThumbnailDetails ];

    [ self fetchThumbImagesFromUrlDict_: urlsDict
                               success_:
    ^( NSImage* _Nullable _Image, BOOL _LoadsFromCache )
        {
        if ( _CompletionHandler )
            _CompletionHandler( _Image, _LoadsFromCache );
        } failure_: ^( NSError* _Errpr )
            {
            if ( _FailureHandler )
                _FailureHandler( _Errpr );
            } ];
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
        id requirementsField = _OperationsDict[ TauTDSOperationRequirements ];
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
        else if ( [ _OperationsDict[ TauTDSOperationRequirements ] count ] == 0 )
            {
            errorDomain = TauCentralDataServiceErrorDomain;
            userInfo = @{ NSLocalizedDescriptionKey :
                            [ NSString stringWithFormat: @"TauTDSOperationRequirements{%@} in operations combination must contain least one valid field."
                                                       , TauTDSOperationRequirements ] };
            errorCode = TauCentralDataServiceInvalidOrConflictingOperationsCombination;
            }

        if ( !( _OperationsDict[ TauTDSOperationPartFilter ] ) )
            DDLogNotice( @"Tau Data Service noticed that there is no TauTDSOperationPartFilter{%@} field found within operations combination. "
                         @"Tau Data Service will select the default {part} filter that may cause the absense of your expecting data fregments."
                       , TauTDSOperationPartFilter
                       );

        if ( !( _OperationsDict[ TauTDSOperationMaxResultsPerPage ] ) )
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

@end // TauYTDataService class