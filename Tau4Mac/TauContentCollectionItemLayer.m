//
//  TauContentCollectionItemLayer.m
//  Tau4Mac
//
//  Created by Tong G. on 3/4/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionItemLayer.h"

// TauContentCollectionItemLayer class
@implementation TauContentCollectionItemLayer

#pragma mark - Overrides

- ( void ) setContents: ( id )_Contents
    {
    [ super setContents: _Contents ];

    [ CATransaction begin ];
    [ CATransaction setDisableActions: YES ];

    if ( self.contents )
        {
//        self.borderColor = [ NSColor blackColor ].CGColor;
//        self.borderWidth = .7f;
        }
    else
        {
//        self.borderColor = [ NSColor clearColor ].CGColor;
//        self.borderWidth = 0.f;
        }

    [ CATransaction commit ];
    }

@end // TauContentCollectionItemLayer class