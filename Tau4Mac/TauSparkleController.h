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

@property ( assign, readonly ) BOOL requiresSparkle;

@end // TauSparkleController class