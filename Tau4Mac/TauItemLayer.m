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
        ;

    return self;
    }

- ( void ) setContents: ( id )_Contents
    {
    [ super setContents: _Contents ];

    if ( self.contents )
        {
        [ CATransaction begin ];
        [ CATransaction setDisableActions: YES ];
        self.borderColor = [ NSColor blackColor ].CGColor;
        self.borderWidth = 1.f;
        self.backgroundColor = [ NSColor lightGrayColor ].CGColor;
        [ CATransaction commit ];
        }
    }

@end // TauItemLayer class