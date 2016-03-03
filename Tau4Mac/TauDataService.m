//
//  TauDataService.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauDataService.h"
#import "TauCollectionObject.h"

#import "GTL/GTLUtilities.h"
#import "GTL/GTMSessionFetcher.h"
#import "GTL/GTMOAuth2Authentication.h"
#import "GTL/GTMOAuth2WindowController.h"

NSString static* const kClientID = @"889656423754-okdcqp9ujnlpc4ob5eno7l0658seoqo4.apps.googleusercontent.com";
NSString static* const kClientSecret = @"C8tMCJMqle9fFtuBnMwODope";

// TauDataService class
@implementation TauDataService

#pragma mark - Singleton Instance

TauDataService static* sDataService_;
+ ( instancetype ) sharedService
    {
    return [ [ self alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sDataService_ )
        if ( self = [ super init ] )
            sDataService_ = self;

    return sDataService_;
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

            service.surrogates = @{ ( id <NSCopying> )[ GTLYouTubeSearchListResponse class ] : [ TauCollectionObject class ] };
            service.retryEnabled = YES;

            BOOL ( ^retryBlock )( GTLServiceTicket*, BOOL, NSError* ) =
                ^( GTLServiceTicket *ticket, BOOL suggestedWillRetry, NSError *error )
                {
                DDLogInfo( @"Will Retry: %d", suggestedWillRetry );
                return YES;
                };

            service.retryBlock = retryBlock;

            NSUInteger majorVer = 0;
            NSUInteger minorVer = 0;
            NSUInteger release = 0;
            GTLFrameworkVersion( &majorVer, &minorVer, &release );

            service.userAgent = [ NSString stringWithFormat:
                  @"%@ 1.0 (Macintosh; OS X %@) GTL/%ld.%ld.%ld"
                , [ NSProcessInfo processInfo ].processName
                , [ NSProcessInfo processInfo ].operatingSystemVersionString
                , majorVer, minorVer, release ];

            DDLogInfo( @"Current user-agent is %@", service.userAgent );
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

@end // TauDataService class