//
//  TauDataService.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#pragma mark - Keychain Item Name

NSString extern* const TauKeychainItemName;

#pragma mark - Client Credentials

/** The OAuth 2.0 client ID for Tau4Mac. Find this value here https://console.developers.google.com/ */
NSString extern* const TauClientID;

/** The client secret associated with client ID of Tau4Mac. */
NSString extern* const TauClientSecret;

#pragma mark - Auth Scopes

/** Manage users' YouTube account. This scope requires communication with the API server to happen over an SSL connection. */
NSString extern* const TauManageAuthScope;

/** View usersa' YouTube account. */
NSString extern* const TauReadonlyAuthScope;

/** Upload YouTube videos and manage users' YouTube videos. */
NSString extern* const TauUploadAuthScope;

/** Retrieve the auditDetails part in a channel resource. */
NSString extern* const TauPartnerChannelAuditAuthScope;

// TauDataService class
@interface TauDataService : NSObject

#pragma mark - Core

@property ( strong, readonly ) GTLServiceYouTube* ytService;

@property ( strong, readonly ) NSString* signedInUsername;
@property ( assign, readonly ) BOOL isSignedIn;

#pragma mark - Singleton Instance

+ ( instancetype ) sharedService;

@end // TauDataService class