//
//  TauYouTubeChannelBadge.m
//  Tau4Mac
//
//  Created by Tong G. on 3/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeChannelBadge.h"
#import "PriTauBadgeTextInternalCell_.h"

// TauYouTubeChannelBadge class
@implementation TauYouTubeChannelBadge

#pragma mark - Initializations

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self.cell setBadgeText: NSLocalizedString( @"CHANNEL", nil ) ];

    return self;
    }

@end // TauYouTubeChannelBadge class