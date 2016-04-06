//
//  TauSparkleController.m
//  Tau4Mac
//
//  Created by Tong G. on 4/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSparkleController.h"

// Private
@interface TauSparkleController ()

@property ( assign, readwrite ) BOOL isUpdating;

@end // Private

// TauSparkleController class
@implementation TauSparkleController

#pragma mark - Singleton

TauSparkleController static* sController;
+ ( instancetype ) sharedController
    {
    return [ [ self alloc ] init ];
    }

SUUpdater static* sSparkleUpdater;
- ( instancetype ) init
    {
    if ( !sController )
        {
        if ( self = [ super init ] )
            {
            if ( ![ [ NSBundle mainBundle ] isSandboxed ] )
                {
                // SUUpdater has a singleton for each bundle.
                // An NSBundle instances are also singletons.
                sSparkleUpdater = [ [ SUUpdater alloc ] init ];
                sSparkleUpdater.delegate = self;
                }

            sController = self;
            }
        }

    return sController;
    }

#pragma mark - Determine Necessity of Sparkle

@dynamic requiresSparkle;
- ( BOOL ) requiresSparkle
    {
    return ( sSparkleUpdater != nil );
    }

@dynamic isUpdating;
- ( BOOL ) isUpdating
    {
    if ( !self.requiresSparkle )
        return NO;

    return sSparkleUpdater.updateInProgress;
    }

#pragma mark - Update Operation

- ( IBAction ) checkForUpdates: ( id )_Sender
    {
    if ( self.requiresSparkle )
        {
        [ sSparkleUpdater checkForUpdates: _Sender ];
        [ _Sender setEnabled: !sSparkleUpdater.updateInProgress ];
        }
    else
        DDLogFatal( @"We don't need the Sparkle for MAS version of Tau4Mac. Sender of %@ should not be visible for user, it's a programmer error", THIS_METHOD );
    }

#pragma mark - Conforms to <SUUpdaterDelegate>
// TODO:

@end // TauSparkleController class