//
//  TauAppDelegate.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAppDelegate.h"

// Private Interfaces
@interface TauAppDelegate ()

// Logging

- ( void ) configureLogging_;

@end // Private Interfaces

// TauAppDelegate class
@implementation TauAppDelegate

#pragma mark - Conforms <NSApplicationDelegate>

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notification
    {
    [ self configureLogging_ ];
    }

#pragma mark - Private Interfaces

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
    [ DDLog addLogger: fileLogger withLevel: DDLogLevelError | DDLogLevelWarning ];
    }

@end // TauAppDelegate class