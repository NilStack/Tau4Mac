//
//  TauTestCase.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauTestCase.h"

// TauTestCase class
@implementation TauTestCase

- ( void ) setUp
    {
    [ super setUp ];

    [ DDLog addLogger: [ DDTTYLogger sharedInstance ] ];
    }

@end // TauTestCase class