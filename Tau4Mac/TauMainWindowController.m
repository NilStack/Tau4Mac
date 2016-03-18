//
//  TauMainWindowController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainWindowController.h"
#import "TauYouTubeEntryView.h"
#import "TauToolbarController.h"

#import "GTL/GTMOAuth2WindowController.h"

#import "TauTTYLogFormatter.h"

// Private Interfaces
@interface TauMainWindowController ()

@property ( strong, readonly ) GTMOAuth2WindowController* authWindow_;

// Signning In
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler;

@end // Private Interfaces

NSString* const TauShouldSwitch2SearchSegmentNotif = @"Should.Switch2SearchSegment.Notif";
NSString* const TauShouldSwitch2MeTubeSegmentNotif = @"Should.Switch2MeTubeSegment.Notif";
NSString* const TauShouldSwitch2PlayerSegmentNotif = @"Should.Switch2PlayerSegment.Notif";

NSString* const TauShouldPlayVideoNotif = @"Should.PlayVideo.Notif";

NSString* const kRequester = @"kRequester";

@implementation TauMainWindowController
    {
    FBKVOController __strong* kvoController_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder] )
        ;

    return self;
    }

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];

    [ self.toolbar setAllowsUserCustomization: NO ];

    [ NSApp setDelegate: self ];

    kvoController_ = [ [ FBKVOController alloc ] initWithObserver: self.contentViewController ];

    [ [ TauToolbarController sharedController ].segSwitcher selectSegmentWithTag: TauSearchContentViewTag ];
//    [ [ NSNotificationCenter defaultCenter ]
//        addObserver: self selector: @selector( shouldSwitch2PlayerSegment_: ) name: TauShouldSwitch2PlayerSegmentNotif object: nil ];
    }

//- ( void ) shouldSwitch2PlayerSegment_: ( NSNotification* )_Notif
//    {
//    [ [ TauToolbarController sharedController ].segSwitcher selectSegmentWithTag: TauPlayerContentViewTag ];
//
//    TauYouTubeEntryView* requester = _Notif.userInfo[ kRequester ];
//
//    NSNotification* shouldPlayVideoNotif = [ NSNotification notificationWithName: TauShouldPlayVideoNotif object: self userInfo: @{ kGTLObject : requester.ytContent } ];
//    [ [ NSNotificationCenter defaultCenter ] postNotification: shouldPlayVideoNotif ];
//    }

#pragma mark - Conforms to <NSApplicationDelegate>

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notif
    {
    if ( ![ [ TauYTDataService sharedService ] isSignedIn ] )
        [ self runSignInThenHandler_: nil ];
    }

- ( BOOL ) applicationShouldHandleReopen: ( NSApplication* )_Sender
                       hasVisibleWindows: ( BOOL )_Flag
    {
    if ( _Flag )
        [ self.window orderFront: self ];
    else
        [ self.window makeKeyAndOrderFront: self ];

    if ( !( [ TauYTDataService sharedService ].isSignedIn ) )
        [ self runSignInThenHandler_: nil ];

    return YES;
    }

#pragma mark - Private Interfaces

@dynamic authWindow_;

- ( GTMOAuth2WindowController* ) authWindow_
    {
    NSBundle* frameworkBundle = [ NSBundle bundleForClass: [ GTMOAuth2WindowController class ] ];

    GTMOAuth2WindowController* authWindow = [ GTMOAuth2WindowController
        controllerWithScope: TauManageAuthScope
                   clientID: TauClientID
               clientSecret: TauClientSecret
           keychainItemName: TauKeychainItemName
             resourceBundle: frameworkBundle ];

    return authWindow;
    }


// Signning in
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler
    {
    [ self.authWindow_ signInSheetModalForWindow: self.window completionHandler:
        ^( GTMOAuth2Authentication* _Auth, NSError* _Error )
            {
            if ( _Auth && !_Error )
                {
                [ [ TauYTDataService sharedService ].ytService setAuthorizer: _Auth ];
                if ( _Handler ) _Handler();
                }
            else
                {
                DDLogUserError( @"Auth Window was prematurely closed" );
                [ self.window orderOut: self ];
                }
            } ];
    }

// Signing Out
//- ( void ) signOutAction: ( id )_Sender
//    {
//    [ TauYTDataService sharedService ].ytService.authorizer = nil;
//    [ GTMOAuth2WindowController removeAuthFromKeychainForName: TauKeychainItemName ];
//    [ self runSignInThenHandler_: nil ];
//    }

@end
