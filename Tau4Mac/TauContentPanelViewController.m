//
//  TauContentPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentPanelViewController.h"

#import "GTL/GTLUtilities.h"
#import "GTL/GTMSessionFetcher.h"
#import "GTL/GTMOAuth2Authentication.h"
#import "GTL/GTMOAuth2WindowController.h"

#import "TauCollectionObject.h"

// Private Interfaces
@interface TauContentPanelViewController ()

@property ( strong, readonly ) GTLServiceYouTube* ytService_;
@property ( strong, readonly ) NSString* signedInUsername_;
@property ( assign, readonly ) BOOL isSignedIn_;

@end // Private Interfaces

NSString static* const kClientID = @"889656423754-okdcqp9ujnlpc4ob5eno7l0658seoqo4.apps.googleusercontent.com";
NSString static* const kClientSecret = @"C8tMCJMqle9fFtuBnMwODope";

// TauContentPanelViewController class
@implementation TauContentPanelViewController
    {
@protected
    GTLCollectionObject __strong* repContents_;
    }

#pragma mark - Initializations

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    self.ytService_;
    }

#pragma mark - Private Interfaces

@dynamic ytService_;
@dynamic signedInUsername_;
@dynamic isSignedIn_;

- ( GTLServiceYouTube* ) ytService_
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

            NSLog( @"%@", service.userAgent );
            } );

    return service;
    }

- ( NSString* ) signedInUsername_
    {
    GTMOAuth2Authentication* auth = self.ytService_.authorizer;

    NSString* userName = auth.userEmail ?: nil;
    return userName;
    }

- ( BOOL ) isSignedIn_
    {
    return [ self signedInUsername_ ] != nil;
    }

@end // TauContentPanelViewController class