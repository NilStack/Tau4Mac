//
//  TauItemLayer.m
//  Tau4Mac
//
//  Created by Tong G. on 3/4/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauItemLayer.h"

// TauItemLayer class
@implementation TauItemLayer

#pragma mark - Initialozations

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        [ CATransaction begin ];
        [ CATransaction setDisableActions: YES ];
        self.borderColor = [ NSColor blackColor ].CGColor;
        self.borderWidth = 1.f;
        self.backgroundColor = [ NSColor lightGrayColor ].CGColor;
        [ CATransaction commit ];
        }

    return self;
    }

@end // TauItemLayer class