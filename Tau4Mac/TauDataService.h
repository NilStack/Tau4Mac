//
//  TauDataService.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#pragma mark - Keychain Item Name

// TauDataService class
@interface TauDataService : NSObject

#pragma mark - Core

@property ( strong, readonly ) GTLServiceYouTube* ytService;

@property ( strong, readonly ) NSString* signedInUsername;
@property ( assign, readonly ) BOOL isSignedIn;

#pragma mark - Singleton Instance

+ ( instancetype ) sharedService;

@end // TauDataService class