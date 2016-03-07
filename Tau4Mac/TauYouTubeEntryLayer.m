//
//  TauYouTubeEntryLayer.m
//  Tau4Mac
//
//  Created by Tong G. on 3/4/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeEntryLayer.h"

// TauYouTubeEntryLayer class
@implementation TauYouTubeEntryLayer

#pragma mark - Overrides

- ( void ) setContents: ( id )_Contents
    {
    [ super setContents: _Contents ];

    [ CATransaction begin ];
    [ CATransaction setDisableActions: YES ];
    if ( self.contents )
        {
        self.borderColor = [ NSColor blackColor ].CGColor;
        self.borderWidth = .5f;
        self.backgroundColor = [ NSColor blackColor ].CGColor;
        }
    else
        {
        self.borderColor = [ NSColor clearColor ].CGColor;
        self.borderWidth = 0.f;
        }

    [ CATransaction commit ];
    }

@end // TauYouTubeEntryLayer class