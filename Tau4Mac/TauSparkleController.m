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

                if ( self.requiresSparkle )
                    {
                    NSMenu* appMenu = [ NSApp menu ];
                    NSLog( @"%@", appMenu );
                    }
                }

            sController = self;
            }
        }

    return sController;
    }

@dynamic requiresSparkle;
- ( BOOL ) requiresSparkle
    {
    return ( sSparkleUpdater != nil );
    }

@end // TauSparkleController class