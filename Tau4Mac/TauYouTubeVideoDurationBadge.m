//
//  TauYouTubeVideoDurationBadge.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeVideoDurationBadge.h"
#import "PriTauBadgeTextInternalCell_.h"

// TauYouTubeVideoDurationBadge class
@implementation TauYouTubeVideoDurationBadge

#pragma mark - Initializations

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self.cell setBadgeText: NSLocalizedString( @"CHANNEL", nil ) ];

    return self;
    }

@end // TauYouTubeVideoDurationBadge class