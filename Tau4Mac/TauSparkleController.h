//
//  TauSparkleController.h
//  Tau4Mac
//
//  Created by Tong G. on 4/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauSparkleController class
@interface TauSparkleController : NSObject

#pragma mark - Singleton

+ ( instancetype ) sharedController;

#pragma mark - Determine Necessity of Sparkle

@property ( assign, readonly ) BOOL requiresSparkle;    // KVB-Compliant

#pragma mark - Update Operation

- ( IBAction ) checkForUpdates: ( id )_Sender;

@end // TauSparkleController class