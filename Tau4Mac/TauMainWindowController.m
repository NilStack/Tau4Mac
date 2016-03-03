//
//  TauMainWindowController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainWindowController.h"

#import "GTL/GTMOAuth2WindowController.h"

#import "TauTTYLogFormatter.h"

// Private Interfaces
@interface TauMainWindowController ()

// Signning in
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler;

// Logging
- ( void ) configureLogging_;

@end // Private Interfaces

@implementation TauMainWindowController

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];

    [ NSApp setDelegate: self ];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

#pragma mark - Conforms to <NSApplicationDelegate>

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notif
    {
    [ self configureLogging_ ];

    if ( ![ [ TauDataService sharedService ] isSignedIn ] )
        [ self runSignInThenHandler_: nil ];
    }

#pragma mark - Private Interfaces

// Signning in
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler
    {
    NSBundle* frameworkBundle = [ NSBundle bundleForClass: [ GTMOAuth2WindowController class ] ];

    GTMOAuth2WindowController* authWindow = [ GTMOAuth2WindowController
        controllerWithScope: TauManageAuthScope
                   clientID: TauClientID
               clientSecret: TauClientSecret
           keychainItemName: TauKeychainItemName
             resourceBundle: frameworkBundle ];

    [ authWindow signInSheetModalForWindow: self.window completionHandler:
        ^( GTMOAuth2Authentication* _Auth, NSError* _Error )
            {
            [ [ TauDataService sharedService ].ytService setAuthorizer: _Auth ];
            if ( _Handler ) _Handler();
            } ];
    }

// Logging
- ( void ) configureLogging_
    {
    NSColor* errorOutputColor = [ NSColor colorWithRed: 248 / 255.f green: 98 / 255.0 blue: 98 / 255.0 alpha: 1.f ];
    NSColor* debugOutputColor = [ NSColor colorWithRed: 151 / 255.f green: 204 / 255.0 blue: 245 / 255.0 alpha: 1.f ];
    NSColor* infoOutputColor = [ NSColor colorWithRed: 184 / 255.f green: 233 / 255.0 blue: 134 / 255.0 alpha: 1.f ];
    NSColor* warningOutputColor = [ NSColor colorWithRed: 246 / 255.f green: 174 / 255.0 blue: 55 / 255.0 alpha: 1.f ];
    NSColor* verboseOutputColor = [ NSColor lightGrayColor ];

    // Configuring TTY Logger
    DDTTYLogger* sharedTTYLogger = [ DDTTYLogger sharedInstance ];
    DDASLLogger* sharedASLLogger = [ DDASLLogger sharedInstance ];

    [ sharedTTYLogger setLogFormatter: [ [ TauTTYLogFormatter alloc ] init ] ];
    [ sharedASLLogger setLogFormatter: [ [ TauTTYLogFormatter alloc ] init ] ];

    [ sharedTTYLogger setColorsEnabled: YES ];
    [ sharedTTYLogger setForegroundColor: errorOutputColor backgroundColor: nil forFlag: DDLogFlagError ];
    [ sharedTTYLogger setForegroundColor: debugOutputColor backgroundColor: nil forFlag: DDLogFlagDebug ];
    [ sharedTTYLogger setForegroundColor: infoOutputColor backgroundColor: nil forFlag: DDLogFlagInfo ];
    [ sharedTTYLogger setForegroundColor: warningOutputColor backgroundColor: nil forFlag: DDLogFlagWarning ];
    [ sharedTTYLogger setForegroundColor: verboseOutputColor backgroundColor: nil forFlag: DDLogFlagVerbose ];

    // Configuring file logger
    DDFileLogger* fileLogger = [ [ DDFileLogger alloc ] init ];

    fileLogger.rollingFrequency = 60 * 60 * 24 * 3; // Three day
    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;

    [ DDLog addLogger: sharedTTYLogger ];
    [ DDLog addLogger: sharedASLLogger ];
    [ DDLog addLogger: fileLogger withLevel: DDLogLevelError | DDLogLevelWarning ];
    }

@end
